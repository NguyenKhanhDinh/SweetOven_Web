// ── Filter ───────────────────────────────────────────────────────────────────
function submitFilter() {
    const kw     = document.getElementById('searchInput').value.trim();
    const status = document.getElementById('filterStatus').value;
    const method = document.getElementById('filterMethod').value;
    let url = CONTEXT_PATH + '/admin/orders?page=1';
    if (kw)              url += '&keyword='       + encodeURIComponent(kw);
    if (status !== '-1') url += '&status='        + status;
    if (method !== '-1') url += '&paymentMethod=' + method;
    window.location.href = url;
}

function resetFilter() {
    window.location.href = CONTEXT_PATH + '/admin/orders';
}

document.addEventListener('DOMContentLoaded', function () {
    // Enter trong ô tìm kiếm
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') submitFilter();
        });
    }

    // THÊM: dropdown tự filter ngay khi đổi giá trị, không cần nhấn nút "Áp dụng"
    const filterStatus = document.getElementById('filterStatus');
    const filterMethod = document.getElementById('filterMethod');
    if (filterStatus) filterStatus.addEventListener('change', submitFilter); // THÊM
    if (filterMethod) filterMethod.addEventListener('change', submitFilter); // THÊM

    // Auto-hide alert toast
    const alert = document.getElementById('alertFloating');
    if (alert) {
        setTimeout(() => {
            alert.style.transition = 'opacity .5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 3500);
    }
});

// ── Mở modal chi tiết đơn hàng ───────────────────────────────────────────────
function openOrderDetail(id) {
    const modal = document.getElementById('orderDetailModal');
    const body  = document.getElementById('orderDetailBody');
    const footer = document.getElementById('orderDetailFooter');

    // Reset footer buttons về trạng thái chờ
    document.getElementById('btnNextStatus').disabled  = true;
    document.getElementById('btnCancelOrder').disabled = true;
    document.getElementById('cancelOrderForm').style.display = 'none';

    body.innerHTML = '<div class="text-center py-4"><div class="spinner-border" style="color:var(--accent)"></div></div>';
    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();

    // SỬA: thêm kiểm tra response.ok + nút Thử lại
    // Trước: server trả 500 vẫn cố parse JSON → crash im lặng, modal treo spinner
    fetch(CONTEXT_PATH + '/admin/orders?action=api&id=' + id)
        .then(r => {
            if (!r.ok) throw new Error('HTTP ' + r.status); // THÊM
            return r.text();
        })
        .then(text => {
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                throw new Error('Phản hồi không hợp lệ từ server'); // THÊM
            }
            if (data.error) {
                body.innerHTML = '<div class="text-center py-4 text-danger"><i class="fas fa-exclamation-circle fa-2x mb-2"></i><p>' + data.error + '</p></div>';
                return;
            }
            renderOrderDetail(data);
        })
        .catch(err => {
            body.innerHTML = '<div class="text-center py-4 text-danger"><i class="fas fa-wifi fa-2x mb-2"></i><p>Lỗi kết nối: ' + err.message + '</p><button class="btn btn-sm btn-outline-secondary mt-2" onclick="openOrderDetail(' + id + ')">Thử lại</button></div>';
        });
}

const STATUS_LABELS = ['', 'Chờ xác nhận', 'Đang xử lý', 'Đang giao', 'Đã giao', 'Đã huỷ'];
const STATUS_ICONS  = ['', 'fa-clock', 'fa-cog', 'fa-truck', 'fa-check-circle', 'fa-times-circle'];
const PAY_LABELS    = {1: 'COD', 2: 'MoMo', 3: 'VNPay'};
const PAY_CLASSES   = {1: 'pay-cod', 2: 'pay-momo', 3: 'pay-vnpay'};
const PAY_ICONS     = {1: 'fa-money-bill-wave', 2: 'fa-wallet', 3: 'fa-credit-card'};

function renderOrderDetail(d) {
    const body = document.getElementById('orderDetailBody');

    // ── Timeline ─────────────────────────────────────────────────────────────
    const steps = [
        {label: 'Chờ xác nhận', icon: 'fa-clock'},
        {label: 'Đang xử lý',   icon: 'fa-cog'},
        {label: 'Đang giao',    icon: 'fa-truck'},
        {label: 'Đã giao',      icon: 'fa-check'},
    ];
    const isCancelled = d.orderStatus === 5;
    let timelineHtml = '<div class="status-timeline">';
    if (isCancelled) {
        timelineHtml += `<div class="timeline-step cancelled" style="flex:1"><div class="step-dot"><i class="fas fa-times"></i></div><div class="step-label">Đã huỷ</div></div>`;
    } else {
        steps.forEach((s, i) => {
            const idx = i + 1;
            const cls = idx < d.orderStatus ? 'done' : idx === d.orderStatus ? 'current' : '';
            timelineHtml += `<div class="timeline-step ${cls}"><div class="step-dot"><i class="fas ${s.icon}"></i></div><div class="step-label">${s.label}</div></div>`;
        });
    }
    timelineHtml += '</div>';

    // ── Header ───────────────────────────────────────────────────────────────
    const statusCls = ['','os-pending','os-processing','os-shipping','os-delivered','os-cancelled'][d.orderStatus] || '';
    const hasGhn    = d.isGhnCreated;
    const headerHtml = `
    <div class="order-detail-header">
        <div>
            <div class="order-detail-code"><i class="fas fa-receipt"></i> #${d.orderCode}
                ${hasGhn ? '<span class="badge bg-success ms-2" style="font-size:.72rem"><i class="fas fa-truck"></i> GHN</span>' : ''}
            </div>
            <div class="order-detail-date"><i class="fas fa-calendar-alt" style="color:var(--accent)"></i> ${d.orderDate}</div>
        </div>
        <span class="order-status-badge ${statusCls}">
            <i class="fas ${STATUS_ICONS[d.orderStatus] || ''}"></i>
            ${STATUS_LABELS[d.orderStatus] || ''}
        </span>
    </div>`;

    // ── Info grid ────────────────────────────────────────────────────────────
    const payClass = PAY_CLASSES[d.paymentMethod] || '';
    const payLabel = PAY_LABELS[d.paymentMethod] || '-';
    const payIcon  = PAY_ICONS[d.paymentMethod]  || 'fa-credit-card';
    const infoHtml = `
    <div class="info-grid">
        <div class="info-row">
            <span class="info-lbl"><i class="fas fa-user"></i> Khách hàng</span>
            <span class="info-val">${d.fullName || '-'}</span>
        </div>
        <div class="info-row">
            <span class="info-lbl"><i class="fas fa-phone"></i> Điện thoại</span>
            <span class="info-val">${d.phoneNumber || '-'}</span>
        </div>
        <div class="info-row full-row">
            <span class="info-lbl"><i class="fas fa-map-marker-alt"></i> Địa chỉ</span>
            <span class="info-val">${d.address || '-'}</span>
        </div>
        <div class="info-row">
            <span class="info-lbl"><i class="fas fa-credit-card"></i> Thanh toán</span>
            <span class="info-val"><span class="pay-badge ${payClass}"><i class="fas ${payIcon}"></i> ${payLabel}</span></span>
        </div>
        <div class="info-row">
            <span class="info-lbl"><i class="fas fa-sticky-note"></i> Ghi chú</span>
            <span class="info-val">${d.note || '—'}</span>
        </div>
        ${d.cancelReason ? `<div class="info-row full-row">
            <span class="info-lbl"><i class="fas fa-ban"></i> Lý do huỷ</span>
            <span class="info-val" style="color:var(--danger)">${d.cancelReason}</span>
        </div>` : ''}
    </div>`;

    // ── Sản phẩm ─────────────────────────────────────────────────────────────
    let productsHtml = '<div class="product-section-title"><i class="fas fa-box-open"></i> Sản phẩm đặt hàng</div><div class="product-list">';
    if (d.details && d.details.length > 0) {
        d.details.forEach(item => {
            const imgHtml = item.productImage
                ? `<img src="${item.productImage}" class="product-row-img" alt="${item.productName}">`
                : `<div class="product-row-img-placeholder"><i class="fas fa-image"></i></div>`;
            productsHtml += `
            <div class="product-row">
                ${imgHtml}
                <div class="product-row-info">
                    <div class="product-row-name">${item.productName || 'Sản phẩm'}</div>
                    <div class="product-row-qty">Đơn giá: ${item.buyPrice} &nbsp;×&nbsp; ${item.quantity}</div>
                </div>
                <div class="product-row-price">${item.totalPrice}</div>
            </div>`;
        });
    } else {
        productsHtml += '<p style="font-size:.83rem;color:var(--text-muted);text-align:center">Không có sản phẩm</p>';
    }
    productsHtml += '</div>';

    // ── Tổng tiền ────────────────────────────────────────────────────────────
    const totalsHtml = `
    <div class="total-section">
        <div class="total-row"><span class="total-lbl">Tạm tính</span><span class="total-val">${d.subTotal}</span></div>
        <div class="total-row"><span class="total-lbl">Giảm giá</span><span class="total-val discount">- ${d.discountAmount}</span></div>
        <div class="total-row"><span class="total-lbl">Phí vận chuyển</span><span class="total-val">${d.shippingFee}</span></div>
        <div class="total-row grand"><span class="total-lbl">Tổng cộng</span><span class="total-val">${d.totalAmount}</span></div>
    </div>`;

    body.innerHTML = timelineHtml + headerHtml + infoHtml + productsHtml + totalsHtml;

    // ── Footer buttons ────────────────────────────────────────────────────────
    const nextBtn    = document.getElementById('btnNextStatus');
    const cancelBtn  = document.getElementById('btnCancelOrder');
    const cancelForm = document.getElementById('cancelOrderForm');
    const ghnBtn     = document.getElementById('btnCreateGhn');
    const syncBtn    = document.getElementById('btnSyncGhn');

    // Reset
    nextBtn.disabled   = true;
    cancelBtn.disabled = true;
    nextBtn.onclick    = null;
    cancelBtn.onclick  = null;
    cancelForm.style.display = 'none';
    document.getElementById('cancelOrderId').value = d.id;
    document.getElementById('nextOrderId').value   = d.id;

    // Nút GHN: chỉ hiện khi status=2 (Đang xử lý) và chưa tạo đơn GHN
    if (ghnBtn) {
        const showGhn = (d.orderStatus === 2 && !d.isGhnCreated);
        ghnBtn.style.display = showGhn ? 'inline-flex' : 'none';
        if (showGhn) {
            document.getElementById('ghnOrderId').value = d.id;
        }
    }

    // Nút đồng bộ GHN: hiện khi đã có mã GHN (status 2,3) — cho phép kéo trạng thái về
    if (syncBtn) {
        const showSync = d.isGhnCreated && (d.orderStatus === 2 || d.orderStatus === 3);
        syncBtn.style.display = showSync ? 'inline-flex' : 'none';
        if (showSync) {
            document.getElementById('syncGhnOrderId').value = d.id;
        }
    }

    const canAdvance = !isCancelled && d.orderStatus < 4;
    const canCancel  = !isCancelled && d.orderStatus < 4;

    if (canAdvance) {
        nextBtn.disabled = false;
        const nextStatus = d.orderStatus + 1;
        document.getElementById('nextStatusVal').value = nextStatus;
        nextBtn.innerHTML = `<i class="fas fa-arrow-right"></i> Chuyển sang: ${STATUS_LABELS[nextStatus]}`;
    } else {
        nextBtn.innerHTML = `<i class="fas fa-check"></i> Đã hoàn thành`;
    }

    if (canCancel) {
        cancelBtn.disabled = false;
        cancelBtn.onclick = function () {
            const showing = cancelForm.style.display !== 'none';
            cancelForm.style.display = showing ? 'none' : 'block';
        };
    }
}

// Submit cập nhật trạng thái
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('btnNextStatus').addEventListener('click', function () {
        if (this.disabled) return;
        document.getElementById('formNextStatus').submit();
    });
});