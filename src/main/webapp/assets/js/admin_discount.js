document.addEventListener('DOMContentLoaded', function () {
    // ── Toast alert auto-hide ──────────────────────────────────────────────
    const alertEl = document.getElementById('alertFloating');
    if (alertEl) {
        setTimeout(() => {
            alertEl.style.opacity = '0';
            alertEl.style.transition = 'opacity 0.5s';
            setTimeout(() => alertEl.remove(), 500);
        }, 4000);
    }

    // ── Auto-open modal (sau redirect) ────────────────────────────────────
    const autoOpen = document.getElementById('autoOpenModal');
    if (autoOpen && autoOpen.value) {
        const el = document.getElementById(autoOpen.value);
        if (el) new bootstrap.Modal(el).show();
    }

    // ── Search on Enter ──────────────────────────────────────────────────
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keydown', e => {
            if (e.key === 'Enter') submitFilter();
        });
    }

    // ── Toggle value unit label khi đổi loại trong form thêm/sửa ─────────
    document.querySelectorAll('input[name="discountType"]').forEach(radio => {
        radio.addEventListener('change', updateValueUnit);
    });
    updateValueUnit();
});

/* ── Filter ──────────────────────────────────────────────────────────────── */
function submitFilter() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const type    = document.getElementById('filterType')?.value ?? '-1';
    const status  = document.getElementById('filterStatus')?.value ?? '-1';
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', keyword);
    url.searchParams.set('type',    type);
    url.searchParams.set('status',  status);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function resetFilter() {
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', '');
    url.searchParams.set('type',    '-1');
    url.searchParams.set('status',  '-1');
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

/* ── Copy mã khuyến mãi ──────────────────────────────────────────────────── */
function copyCode(code) {
    navigator.clipboard.writeText(code).then(() => {
        showToast('success', `Đã sao chép mã <strong>${code}</strong>`);
    }).catch(() => {
        showToast('error', 'Không thể sao chép mã');
    });
}

/* ── Mở modal xem chi tiết ──────────────────────────────────────────────── */
function openViewModal(id) {
    fetch(`${CONTEXT_PATH}/admin/discounts?action=api&id=${id}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast('error', data.error); return; }

            const typeLabel = data.discountType == 1
                ? '<span class="type-badge type-percent"><i class="fas fa-percent"></i> Phần trăm</span>'
                : '<span class="type-badge type-fixed"><i class="fas fa-hand-holding-usd"></i> Cố định</span>';

            document.getElementById('viewCode').textContent        = data.code || '—';
            document.getElementById('viewDesc').textContent        = data.description || '—';
            document.getElementById('viewType').innerHTML          = typeLabel;
            document.getElementById('viewValue').textContent       = data.displayValue || '—';
            document.getElementById('viewMinOrder').textContent    = data.displayMinOrder || '0 VNĐ';
            document.getElementById('viewStartDate').textContent   = data.formattedStartDate || '—';
            document.getElementById('viewEndDate').textContent     = data.formattedEndDate || '—';
            document.getElementById('viewCreatedAt').textContent   = data.formattedCreatedAt || '—';

            const statusEl = document.getElementById('viewStatusBadge');
            if (data.status === 'ACTIVE')
                statusEl.innerHTML = '<span class="status-badge ds-active"><i class="fas fa-check-circle"></i> Đang hiệu lực</span>';
            else if (data.status === 'EXPIRED')
                statusEl.innerHTML = '<span class="status-badge ds-expired"><i class="fas fa-times-circle"></i> Đã hết hạn</span>';
            else
                statusEl.innerHTML = '<span class="status-badge ds-upcoming"><i class="fas fa-clock"></i> Chưa bắt đầu</span>';

            new bootstrap.Modal(document.getElementById('viewDiscountModal')).show();
        })
        .catch(() => showToast('error', 'Không thể tải dữ liệu'));
}

/* ── Mở modal sửa ────────────────────────────────────────────────────────── */
function openEditModal(id) {
    fetch(`${CONTEXT_PATH}/admin/discounts?action=api&id=${id}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast('error', data.error); return; }

            document.getElementById('editId').value          = data.id;
            document.getElementById('editCode').value        = data.code || '';
            document.getElementById('editDescription').value = data.description || '';
            document.getElementById('editValue').value       = data.value || '';
            document.getElementById('editMinOrder').value = data.minOrderValue || '';
            document.getElementById('editStartDate').value   = data.startDateInput || '';
            document.getElementById('editEndDate').value     = data.endDateInput || '';

            // Set radio button loại giảm giá
            document.querySelectorAll('#editDiscountModal input[name="discountType"]').forEach(r => {
                r.checked = (parseInt(r.value) === parseInt(data.discountType));
            });
            updateValueUnit();

            new bootstrap.Modal(document.getElementById('editDiscountModal')).show();
        })
        .catch(() => showToast('error', 'Không thể tải dữ liệu'));
}

/* ── Xác nhận xoá ────────────────────────────────────────────────────────── */
function confirmDelete(id, code) {
    Swal.fire({
        title: 'Xoá khuyến mãi?',
        html: `Bạn chắc chắn muốn xoá mã <strong>${code}</strong>?<br><small style="color:#888">Hành động này không thể hoàn tác.</small>`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#e53935',
        cancelButtonColor: '#aaa',
        confirmButtonText: '<i class="fas fa-trash"></i> Xoá',
        cancelButtonText: 'Huỷ',
        customClass: { popup: 'swal-font' }
    }).then(result => {
        if (result.isConfirmed) {
            const form = document.getElementById('deleteForm');
            document.getElementById('deleteId').value = id;
            form.submit();
        }
    });
}

/* ── Cập nhật nhãn đơn vị cho ô value ─────────────────────────────────────── */
function updateValueUnit() {
    ['', 'edit'].forEach(prefix => {
        const radios = document.querySelectorAll(
            `${prefix ? '#' + prefix + 'DiscountModal ' : ''}input[name="discountType"]`
        );
        let selectedVal = null;
        radios.forEach(r => { if (r.checked) selectedVal = r.value; });
        if (!selectedVal) return;

        const unitEl = document.getElementById(prefix ? 'editValueUnit' : 'addValueUnit');
        if (unitEl) {
            unitEl.textContent = selectedVal == '1' ? '%' : 'VNĐ';
        }
    });
}

/* ── Toast helper ────────────────────────────────────────────────────────── */
function showToast(type, msg) {
    const existing = document.getElementById('alertFloating');
    if (existing) existing.remove();

    const div = document.createElement('div');
    div.id = 'alertFloating';
    div.className = `alert-floating alert-${type === 'success' ? 'success' : 'danger'}`;
    div.innerHTML = `<i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i> ${msg}`;
    document.body.appendChild(div);

    setTimeout(() => {
        div.style.opacity = '0';
        div.style.transition = 'opacity 0.5s';
        setTimeout(() => div.remove(), 500);
    }, 4000);
}
