<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Voucher Ưu Đãi | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/header.css"/>
    <style>
        :root {
            --brand: #3C2F27;
            --brand2: #b85a1a;
            --brand3: #8B4513;
            --brand-light: #d4722a;
            --bg: #fffff;
            --border: #e9ddd0;
            --green: #16a34a;
        }

        body {
            background: white;
            font-family: 'Quicksand', sans-serif;
        }

        .page-wrapper {
            margin-top: 90px;
            padding-bottom: 60px;
        }

        /* HERO */
        .vc-hero {
            background: var(--brand);
            padding: 26px 36px;
            color: #fff;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            position: relative;
            overflow: hidden;
        }

        .vc-hero h2 {
            font-size: 22px;
            font-weight: 700;
            margin: 0 0 4px;
        }

        .vc-hero p {
            font-size: 13px;
            opacity: .85;
            margin: 0;
        }

        .vc-hero-stats {
            display: flex;
            gap: 16px;
            z-index: 1;
            flex-shrink: 0;
        }

        .vc-stat {
            background: rgba(255, 255, 255, .13);
            padding: 10px 18px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, .15);
        }

        .vc-stat .n {
            font-size: 22px;
            font-weight: 700;
            line-height: 1;
        }

        .vc-stat .l {
            font-size: 11px;
            opacity: .8;
            margin-top: 2px;
        }

        /* TABS */
        .vc-tabs {
            display: flex;
            gap: 0;
            border-bottom: 2px solid var(--border);
            margin-bottom: 20px;
        }

        .vc-tab {
            padding: 10px 20px;
            border: none;
            background: transparent;
            font-family: 'Quicksand', sans-serif;
            font-size: 14px;
            font-weight: 600;
            color: #6b7280;
            cursor: pointer;
            position: relative;
            bottom: -2px;
            transition: color .15s;
        }

        .vc-tab.active {
            background: #ffffff;
            color: var(--brand2);
            border: 2px solid var(--border);
            border-bottom-color: #fff;
        }

        .vc-tab .badge {
            background: var(--brand2);
            color: #fff;
            font-size: 10px;
            font-weight: 700;
            padding: 1px 7px;
            margin-left: 5px;
            border-radius: 2px;
        }

        .vc-tab.active .badge {
            background: var(--brand);
        }

        .tab-pane {
            display: none;
        }

        .tab-pane.active {
            display: block;
        }

        /* GRID — 2 cột cố định, card rộng hơn */
        .vc-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(420px, 1fr));
            gap: 10px;
        }

        /* ── SHOPEE-STYLE CARD ── */
        .vc-card {
            background: #ffffff;
            display: flex;
            overflow: visible; /* cần để notch hiện ra ngoài */
            border: 1px solid var(--border);
            transition: box-shadow .18s, border-color .18s;
            position: relative;
            min-height: 0; /* tự co theo nội dung */
        }

        .vc-card:hover {
            box-shadow: 0 4px 22px rgba(139, 69, 19, .13);
            border-color: #ffffff;
        }

        .vc-card.saved {
            border-color: #86efac;
            background: #f0fdf4;
        }

        .vc-card.saved .vc-logo-panel {
            background: linear-gradient(160deg, #22c55e, #15803d);
        }

        /* Shopee notch — 2 lõm tròn tại đường chia */
        .vc-card::before,
        .vc-card::after {
            content: '';
            position: absolute;
            left: 100px; /* khớp với width logo-panel */
            width: 16px;
            height: 16px;
            background: white;
            border: 1px solid var(--border);
            border-radius: 50%;
            z-index: 3;
        }

        .vc-card::before {
            top: -8px;
        }

        .vc-card::after {
            bottom: -8px;
        }

        .vc-card.saved::before,
        .vc-card.saved::after {
            background: #f0fdf4;
            border-color: #86efac;
        }

        /* LEFT: Logo-only panel — nhỏ gọn, chỉ logo + tên */
        .vc-logo-panel {
            width: 108px;
            flex-shrink: 0;
            background: var(--brand);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 14px 8px;
            gap: 5px;
            position: relative;
        }

        .vc-logo-panel::after {
            content: '';
            position: absolute;
            right: 0;
            top: 12px;
            bottom: 12px;
            border-right: 2px dashed rgba(255, 255, 255, .22);
        }

        .vc-logo-panel .logo-voucher-img {
            width: 46px;
            height: 46px;
            object-fit: contain;

            /* ép nằm gọn trong khung */
            max-width: 100%;
            max-height: 100%;

            display: block;
        }

        .vc-logo-panel .logo-fallback {
            font-size: 28px;
            color: #fff;
            opacity: .85;
            display: none;
        }

        .vc-logo-panel .logo-name {
            color: #fff;
            font-size: 10px;
            font-weight: 700;
            text-align: center;
            line-height: 1.3;
            opacity: .88;
            letter-spacing: .2px;
        }

        /* RIGHT: Content */
        .vc-body {
            flex: 1;
            padding: 11px 14px 10px;
            min-width: 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* Top row: code + badge */
        .vc-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
            margin-bottom: 3px;
        }

        .vc-code {
            font-weight: 700;
            font-size: 13px;
            color: var(--brand);
            letter-spacing: .6px;
            background: #FFF3E0;
            border: 1px dashed #D4A76A;
            padding: 1px 8px;
            font-family: monospace;
        }

        .vc-badge {
            font-size: 10px;
            font-weight: 700;
            padding: 2px 8px;
            white-space: nowrap;
        }

        .badge-new {
            background: #fef3c7;
            color: #b45309;
        }

        .badge-saved {
            background: #dcfce7;
            color: #15803d;
        }

        /* Description — nổi bật, là dòng chính user nhìn đầu tiên */
        .vc-desc-main {
            font-size: 15px;
            font-weight: 700;
            color: var(--brand);
            margin: 2px 0 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.3;
        }

        /* Meta row */
        .vc-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            font-size: 11.5px;
            color: #888;
            margin-bottom: 0;
        }

        .vc-meta span {
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .vc-meta b {
            color: var(--brand3);
            font-weight: 700;
        }

        /* Footer: expire + button */
        .vc-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 8px;
            padding-top: 7px;
            border-top: 1px dashed var(--border);
        }

        .vc-expire {
            font-size: 11px;
            color: #aaa;
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .btn-save {
            background: var(--brand2);
            color: #fff;
            border: 1px solid transparent;
            padding: 5px 16px;
            font-size: 12px;
            font-weight: 700;
            font-family: 'Quicksand', sans-serif;
            cursor: pointer;
            white-space: nowrap;
            transition: background .15s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-save:hover {
            background: var(--brand);
            color: #fff;
        }

        .btn-use {
            background: #fff;
            color: var(--green);
            border: 1px solid var(--green);
            padding: 5px 14px;
            font-size: 12px;
            font-weight: 700;
            font-family: 'Quicksand', sans-serif;
            cursor: pointer;
            white-space: nowrap;
            transition: background .15s, color .15s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-use:hover {
            background: #f0fdf4;
            color: var(--green);
        }

        .info-strip {
            background: #ffffff;
            border: 1px solid #e5e7eb;
        }

        /* Empty */
        .vc-empty {
            grid-column: 1/-1;
            text-align: center;
            padding: 56px 20px;
            color: #bbb;
        }

        .vc-empty i {
            font-size: 50px;
            margin-bottom: 14px;
            display: block;
        }

        /* Toast */
        .toast-wrap {
            position: fixed;
            top: 82px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .toast-item {
            background: #fff;
            box-shadow: 0 4px 20px rgba(0, 0, 0, .12);
            padding: 12px 18px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn .3s ease;
            min-width: 260px;
        }

        .toast-success {
            border-left: 4px solid #22c55e;
        }

        .toast-error {
            border-left: 4px solid #ef4444;
        }

        @keyframes slideIn {
            from {
                transform: translateX(110%);
                opacity: 0
            }
            to {
                transform: translateX(0);
                opacity: 1
            }
        }
    </style>
</head>
<body>
<%@ include file="/components/header.jsp" %>

<%-- TOASTS --%>
<div class="toast-wrap" id="toast-wrap">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast-item toast-success" id="t-ok">
            <i class="fa fa-check-circle text-success"></i><span>${sessionScope.successMsg}</span>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast-item toast-error" id="t-err">
            <i class="fa fa-times-circle text-danger"></i><span>${sessionScope.errorMsg}</span>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>
</div>

<div class="container page-wrapper">

    <%-- HERO --%>
    <div class="vc-hero">
        <div style="z-index:1;">
            <h2><i class="fa fa-ticket-alt me-2"></i>Kho Voucher Ưu Đãi</h2>
            <p>Lưu và dùng ngay để tiết kiệm cho đơn hàng của bạn!</p>
        </div>
        <div class="vc-hero-stats">
            <div class="vc-stat">
                <div class="n" id="hero-total">0</div>
                <div class="l">Voucher hiện có</div>
            </div>
            <div class="vc-stat">
                <div class="n" id="hero-saved">${not empty savedActiveCount ? savedActiveCount : 0}</div>
                <div class="l">Đã lưu</div>
            </div>
        </div>
    </div>

    <%-- Thông báo khách chưa đăng nhập --%>
    <c:if test="${empty sessionScope.user}">
        <div class="info-strip">
            <i class="fa fa-circle-info"></i>
            <span>Đăng nhập để lưu và sử dụng voucher khi thanh toán.
                <a href="${pageContext.request.contextPath}/login?redirect=vouchers"
                   style="color:var(--brand);font-weight:700;">Đăng nhập ngay →</a></span>
        </div>
    </c:if>

    <%-- TABS --%>
    <div class="vc-tabs">
        <button class="vc-tab active" onclick="switchTab(this,'all')">
            Tất cả <span class="badge" id="cnt-all">0</span>
        </button>
        <button class="vc-tab" onclick="switchTab(this,'unsaved')">
            Chưa lưu <span class="badge" id="cnt-unsaved">0</span>
        </button>
        <button class="vc-tab" onclick="switchTab(this,'saved')">
            Đã lưu <span class="badge" id="cnt-saved">0</span>
        </button>
    </div>

    <div class="tab-pane active" id="tab-all">
        <div class="vc-grid" id="grid-all">
            <c:choose>
                <c:when test="${empty discounts}">
                    <div class="vc-empty">
                        <i class="fa fa-tags"></i>
                        <p>Hiện chưa có voucher nào. Hãy quay lại sau!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="d" items="${discounts}">
                        <c:set var="isSaved" value="${savedDiscountIds != null && savedDiscountIds.contains(d.id)}"/>
                        <c:set var="isUsed" value="${usedDiscountIds  != null && usedDiscountIds.contains(d.id)}"/>
                        <c:if test="${!isUsed}">
                        <div class="vc-card ${isSaved ? 'saved' : ''}" data-saved="${isSaved}" data-id="${d.id}">

                                <%-- LEFT: Logo only --%>
                            <div class="vc-logo-panel">
                                <img src="${pageContext.request.contextPath}/assets/picture/logo-voucher.png"
                                     alt="Sweet Oven" class="logo-voucher-img"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                <i class="fas fa-bread-slice logo-fallback"></i>
                                <div class="logo-name">Sweet Oven<br>Bakery</div>
                            </div>

                                <%-- RIGHT: Content --%>
                            <div class="vc-body">
                                <div>
                                    <div class="vc-top">
                                        <span class="vc-code">${d.code}</span>
                                        <c:choose>
                                            <c:when test="${isSaved}">
                                                <span class="vc-badge badge-saved"><i class="fa fa-check me-1"></i>Đã lưu</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="vc-badge badge-new">✦ Mới</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="vc-desc-main">${d.description}</div>
                                    <div class="vc-meta">
                                        <span><i
                                                class="fa fa-receipt"></i>Đơn tối thiểu: <b>${d.displayMinOrder}</b></span>
                                    </div>
                                </div>
                                <div class="vc-footer">
                                    <span class="vc-expire"><i class="fa fa-clock"></i>&nbsp;HSD: <b
                                            style="color:var(--brand3);">${d.formattedEndDate}</b></span>
                                    <c:choose>
                                        <c:when test="${isSaved}">
                                            <a href="${pageContext.request.contextPath}/my-cart?pendingVoucher=${d.code}"
                                               class="btn-use">Dùng ngay</a>
                                        </c:when>
                                        <c:when test="${empty sessionScope.user}">
                                            <a href="${pageContext.request.contextPath}/login?redirect=vouchers"
                                               class="btn-save"><i class="fa fa-bookmark"></i>Lưu ngay</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn-save"
                                                    onclick="saveVoucher(this, ${d.id})">
                                                <i class="fa fa-bookmark"></i>Lưu ngay
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="tab-pane" id="tab-unsaved">
        <div class="vc-grid" id="grid-unsaved"></div>
    </div>
    <div class="tab-pane" id="tab-saved">
        <div class="vc-grid" id="grid-saved"></div>
    </div>

</div>

<%@ include file="/components/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/menu.js"></script>
<script>
    var _ctx = '${pageContext.request.contextPath}';

    /* ── Toast helper ── */
    function showVcToast(type, msg) {
        if (typeof window.showGlobalToast === 'function') {
            window.showGlobalToast(type, msg);
            return;
        }
        var t = document.createElement('div');
        t.style.cssText = 'position:fixed;bottom:24px;right:24px;z-index:9999;padding:12px 20px;border-radius:8px;font-weight:600;font-size:13px;color:#fff;box-shadow:0 4px 16px rgba(0,0,0,.18);transition:opacity .4s;';
        t.style.background = type === 'success' ? '#16a34a' : '#dc2626';
        t.textContent = msg;
        document.body.appendChild(t);
        setTimeout(function () {
            t.style.opacity = '0';
            setTimeout(function () {
                t.remove();
            }, 400);
        }, 3000);
    }

    /* ── AJAX lưu voucher ── */
    function saveVoucher(btn, discountId) {
        btn.disabled = true;
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i>';

        fetch(_ctx + '/save-voucher', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'discountId=' + encodeURIComponent(discountId)
        })
            .then(function (r) {
                return r.json();
            })
            .then(function (data) {
                if (data.status === 'ok') {
                    /* Cập nhật TẤT CẢ card trùng discountId (all-tab + clone ở unsaved-tab) */
                    document.querySelectorAll('.vc-card[data-id="' + discountId + '"]').forEach(function (card) {
                        /* đổi class → saved */
                        card.classList.add('saved');
                        card.dataset.saved = 'true';
                        /* badge */
                        var badge = card.querySelector('.vc-badge');
                        if (badge) {
                            badge.className = 'vc-badge badge-saved';
                            badge.innerHTML = '<i class="fa fa-check me-1"></i>Đã lưu';
                        }
                        /* footer: đổi nút → link dùng ngay */
                        var code = card.querySelector('.vc-code') ? card.querySelector('.vc-code').textContent.trim() : '';
                        var footer = card.querySelector('.vc-footer');
                        if (footer) {
                            var oldBtn = footer.querySelector('button.btn-save');
                            if (oldBtn) {
                                var a = document.createElement('a');
                                a.href = _ctx + '/my-cart?pendingVoucher=' + encodeURIComponent(code);
                                a.className = 'btn-use';
                                a.textContent = 'Dùng ngay';
                                oldBtn.replaceWith(a);
                            }
                        }
                        /* notch màu saved */
                        card.querySelectorAll('.vc-card::before,.vc-card::after').forEach(function (n) {
                            n;
                        });
                    });
                    /* Cập nhật lại sub-tab saved / unsaved */
                    rebuildTabs();
                    showVcToast('success', data.message);
                } else {
                    btn.disabled = false;
                    btn.innerHTML = orig;
                    showVcToast('error', data.message);
                }
            })
            .catch(function () {
                btn.disabled = false;
                btn.innerHTML = orig;
                showVcToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
            });
    }

    /* ── Build / rebuild sub-tabs ── */
    function rebuildTabs() {
        var allCards = Array.from(document.querySelectorAll('#grid-all .vc-card'));
        var savedGrid = document.getElementById('grid-saved');
        var unsavedGrid = document.getElementById('grid-unsaved');
        var savedCards = allCards.filter(function (c) {
            return c.dataset.saved === 'true';
        });
        var unsavedCards = allCards.filter(function (c) {
            return c.dataset.saved !== 'true';
        });

        savedGrid.innerHTML = '';
        unsavedGrid.innerHTML = '';

        if (savedCards.length)
            savedCards.forEach(function (c) {
                savedGrid.appendChild(c.cloneNode(true));
            });
        else
            savedGrid.innerHTML = '<div class="vc-empty"><i class="fa fa-bookmark"></i><p>Bạn chưa lưu voucher nào.</p></div>';

        if (unsavedCards.length)
            unsavedCards.forEach(function (c) {
                unsavedGrid.appendChild(c.cloneNode(true));
            });
        else
            unsavedGrid.innerHTML = '<div class="vc-empty"><i class="fa fa-tags"></i><p>Bạn đã lưu tất cả voucher!</p></div>';

        document.getElementById('cnt-all').textContent = allCards.length;
        document.getElementById('cnt-saved').textContent = savedCards.length;
        document.getElementById('cnt-unsaved').textContent = unsavedCards.length;
        document.getElementById('hero-total').textContent = allCards.length;
        document.getElementById('hero-saved').textContent = savedCards.length;  
    }

    function switchTab(btn, id) {
        document.querySelectorAll('.vc-tab').forEach(function (t) {
            t.classList.remove('active');
        });
        document.querySelectorAll('.tab-pane').forEach(function (p) {
            p.classList.remove('active');
        });
        btn.classList.add('active');
        document.getElementById('tab-' + id).classList.add('active');
    }

    document.addEventListener('DOMContentLoaded', function () {
        /* Auto-dismiss server-side toast */
        ['t-ok', 't-err'].forEach(function (id) {
            var el = document.getElementById(id);
            if (!el) return;
            setTimeout(function () {
                el.style.transition = 'opacity .4s';
                el.style.opacity = '0';
                setTimeout(function () {
                    el.remove();
                }, 400);
            }, 3500);
        });
        rebuildTabs();
    });
</script>
</body>
</html>
