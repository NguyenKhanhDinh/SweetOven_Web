<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | Sweet Oven Bakery</title>
    <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <!-- Các thư viện bên ngoài -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">


    <style>
        /* ============================================================
           DESIGN TOKENS — đồng bộ với home.css & header.css
        ============================================================ */
        :root {
            --primary:        #3C2F27;
            --primary-hover:  #4a3728;
            --accent:         #C9A96E;
            --accent-light:   #e8d5b0;
            --bg-color:       #F9F6F0;
            --white:          #ffffff;
            --light:          #F5F3EF;
            --text-main:      #2C2218;
            --text-muted:     #8a8580;
            --border-soft:    #E8E2D9;
            --shadow-card:    0 2px 16px rgba(44, 34, 24, 0.07);
            --radius-card:    8px;
            --radius-btn:     4px;
            --transition:     all 0.25s ease;
        }

        /* Layout */
        body {
            padding-top: 100px;
            font-family: 'Quicksand', sans-serif;
            background: var(--bg-color);
            color: var(--text-main);
            margin: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        main {
            padding: 36px 0 72px 0;
            flex: 1 0 auto;
        }

        /* ---- Page header ---- */
        .cart-page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .cart-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary);
            margin: 0;
            letter-spacing: 3px;
            text-transform: uppercase;
            position: relative;
            display: inline-block;
            line-height: 1;
        }

        .cart-title::after {
            content: "";
            position: absolute;
            width: 32px;
            height: 2px;
            background: var(--accent);
            left: 50%;
            transform: translateX(-50%);
            bottom: -10px;
        }

        .cart-page-label {
            display: block;
            font-size: 0.6rem;
            font-weight: 600;
            letter-spacing: 4px;
            text-transform: uppercase;
            color: var(--accent);
            margin-top: 20px;
            font-style: italic;
        }

        /* ---- Table ---- */
        .content {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
            background: var(--white);
            border-radius: var(--radius-card);
            box-shadow: var(--shadow-card);
            overflow: hidden;
        }

        .content th {
            background: #F5F0E8;
            color: var(--text-muted);
            text-align: left;
            padding: 14px 20px;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            border-bottom: 1px solid var(--border-soft);
        }

        .content td {
            padding: 20px;
            border-top: 1px solid var(--border-soft);
            vertical-align: middle;
        }

        .th-check, .td-check {
            width: 52px;
            text-align: center !important;
            padding-left: 16px !important;
            padding-right: 8px !important;
        }

        .cart-checkbox {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--accent);
        }

        tr.row-selected > td {
            background: #FBF5E8;
        }

        tr.row-out-of-stock .cart-checkbox {
            opacity: 0.3;
            cursor: not-allowed;
        }

        /* ---- Product cell ---- */
        .san-pham {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .img-container {
            position: relative;
            width: 96px;
            height: 96px;
            flex-shrink: 0;
        }

        .san-pham img {
            width: 96px;
            height: 96px;
            border-radius: var(--radius-card);
            border: 1px solid var(--border-soft);
            object-fit: cover;
        }

        .out-of-stock-overlay {
            position: absolute;
            inset: 0;
            background: rgba(44, 34, 24, 0.62);
            color: #F5E8D8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 11px;
            letter-spacing: 2px;
            text-transform: uppercase;
            border-radius: var(--radius-card);
            z-index: 2;
        }

        .stock-warning {
            color: #b94040;
            font-size: 11.5px;
            margin-top: 5px;
            display: block;
            font-weight: 500;
        }

        .product-info h2 {
            font-size: 15px;
            color: var(--primary);
            margin: 0 0 3px;
            font-weight: 700;
            line-height: 1.4;
        }

        .product-info p {
            font-size: 12.5px;
            color: var(--text-muted);
            margin: 0;
        }

        /* ---- Price cell ---- */
        .price-cell {
            font-size: 14px;
            font-weight: 700;
            color: var(--accent);
            white-space: nowrap;
        }

        .price-original {
            font-size: 12px;
            font-weight: 500;
            color: var(--text-muted);
            text-decoration: line-through;
            display: block;
            margin-bottom: 2px;
        }

        .price-discount-badge {
            display: inline-block;
            font-size: 10px;
            font-weight: 700;
            background: #C9A96E22;
            color: var(--accent);
            border: 1px solid var(--accent-light);
            border-radius: 3px;
            padding: 1px 5px;
            letter-spacing: 0.3px;
            margin-left: 4px;
            vertical-align: middle;
        }

        .total-cell {
            font-size: 14px;
            font-weight: 700;
            color: var(--accent);
            white-space: nowrap;
        }

        /* ---- Qty control ---- */
        .qty-control {
            display: inline-flex;
            align-items: center;
            border: 1.5px solid var(--border-soft);
            border-radius: var(--radius-card);
            overflow: hidden;
            background: var(--white);
            transition: border-color 0.2s;
        }

        .qty-control:focus-within {
            border-color: var(--accent);
        }

        .qty-control button {
            background: transparent;
            color: #3C2F27;
            border: none;
            width: 32px;
            height: 32px;
            cursor: pointer;
            font-size: 12px;
            transition: background 0.15s, color 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .qty-control button:hover:not(:disabled) {
            background: var(--primary);
            color: var(--white);
        }

        .qty-control button:disabled {
            color: #ccc;
            cursor: not-allowed;
        }

        .qty-control input.qty-input {
            width: 42px;
            height: 32px;
            border: none;
            border-left: 1px solid var(--border-soft);
            border-right: 1px solid var(--border-soft);
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            color: var(--primary);
            background: #FAFAF8;
            outline: none;
            font-family: 'Quicksand', sans-serif;
            -moz-appearance: textfield;
        }

        .qty-control input.qty-input::-webkit-inner-spin-button,
        .qty-control input.qty-input::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .qty-control input.qty-input:focus {
            background: var(--white);
        }

        /* ---- Delete button ---- */
        .btn-remove {
            background: none;
            border: none;
            color: var(--text-muted);
            font-size: 14px;
            cursor: pointer;
            padding: 6px 10px;
            border-radius: var(--radius-btn);
            transition: color 0.2s, background 0.2s;
            display: inline-flex;
            align-items: center;
        }

        .btn-remove:hover {
            color: #b94040;
            background: #fdf0f0;
        }

        /* ---- Empty cart ---- */
        .empty-cart-cell {
            text-align: center;
            padding: 64px 20px !important;
            color: var(--text-muted);
        }

        .empty-cart-cell i {
            color: var(--accent-light);
            display: block;
            margin-bottom: 14px;
        }

        .empty-cart-cell span {
            font-size: 14px;
            font-weight: 500;
            letter-spacing: 0.3px;
        }

        /* ---- Cart footer ---- */
        .cart-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            margin-top: 8px;
            padding: 20px 28px;
            background: var(--white);
            border-radius: var(--radius-card);
            border: 1px solid var(--border-soft);
            box-shadow: var(--shadow-card);
        }

        .footer-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .select-count-badge {
            font-size: 12.5px;
            font-weight: 500;
            color: var(--text-muted);
        }

        .select-count-badge strong {
            color: var(--primary);
            font-weight: 700;
        }

        .footer-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .cart-summary {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 2px;
        }

        .cart-summary .label {
            font-size: 10px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .cart-summary .amount {
            font-size: 22px;
            font-weight: 800;
            color: var(--accent);
            letter-spacing: -0.3px;
        }

        .divider-v {
            width: 1px;
            height: 40px;
            background: var(--border-soft);
            flex-shrink: 0;
        }

        /* Checkout button — matches .btn-featured-all from home.css */
        .btn-checkout {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            height: 46px;
            padding: 0 28px;
            background: #3C2F27;
            color: var(--white);
            border: 2px solid #3C2F27;
            border-radius: 8px;
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            cursor: pointer;
            transition: background 0.22s ease, color 0.22s ease;
            white-space: nowrap;
        }

        .btn-checkout:hover:not(:disabled) {
            background: transparent;
            color: var(--primary);
        }

        .btn-checkout i {
            transition: transform 0.22s ease;
        }

        .btn-checkout:hover:not(:disabled) i {
            transform: translateX(4px);
        }

        .btn-checkout:disabled {
            background: #EDEBE8;
            color: #A89890;
            border-color: #EDEBE8;
            cursor: not-allowed;
        }

        /* Out-of-stock warning footer */
        .stock-warning-footer {
            font-size: 11.5px;
            color: #b94040;
            text-align: right;
            margin-top: 10px;
            font-weight: 500;
            letter-spacing: 0.2px;
        }

        /* ---- Responsive ---- */
        @media (max-width: 768px) {
            .content th,
            .content td {
                padding: 14px 12px;
            }

            .san-pham {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .img-container,
            .san-pham img {
                width: 76px;
                height: 76px;
            }
        }

        @media (max-width: 576px) {
            .cart-footer {
                flex-direction: column;
                align-items: stretch;
                gap: 16px;
                padding: 16px;
            }

            .footer-right {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
            }

            .cart-summary {
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
            }

            .divider-v { display: none; }

            .btn-checkout {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>

<body>
<!-- Import component Header -->
<jsp:include page="components/header.jsp" />

<main>
    <div class="container">
        <!-- Page header đồng bộ với section-title trên trang chủ -->
        <div class="cart-page-header">
            <h1 class="cart-title">Giỏ hàng</h1>
            <span class="cart-page-label">Sweet Oven Bakery</span>
        </div>

        <table class="content" aria-label="Giỏ hàng">
            <thead>
            <tr>
                <th class="th-check">
                    <input type="checkbox" id="select-all" class="cart-checkbox" title="Chọn tất cả">
                </th>
                <th>Thông tin chi tiết sản phẩm</th>
                <th>Đơn giá</th>
                <th>Số lượng</th>
                <th>Tổng giá</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${empty cart.items}">
                <tr>
                    <td colspan="6" class="empty-cart-cell">
                        <i class="fas fa-shopping-basket fa-3x"></i>
                        <span>Giỏ hàng của bạn đang trống</span>
                    </td>
                </tr>
            </c:if>

            <c:set var="anyOutOfStock" value="false" />
            <c:forEach var="item" items="${cart.items}">
                <c:if test="${item.product.stockQuantity <= 0}">
                    <c:set var="anyOutOfStock" value="true" />
                </c:if>
                <tr class="cart-row ${item.product.stockQuantity <= 0 ? 'row-out-of-stock' : ''}"
                    data-product-id="${item.product.id}">

                    <td class="td-check">
                        <input type="checkbox"
                               class="cart-checkbox item-checkbox"
                               data-product-id="${item.product.id}"
                               data-unit-price="${item.product.displayPrice}"
                            ${item.product.stockQuantity <= 0 ? 'disabled' : ''}
                               title="${item.product.stockQuantity <= 0 ? 'Sản phẩm hết hàng' : 'Chọn sản phẩm này'}">
                    </td>

                    <td class="san-pham">
                        <div class="img-container">
                            <a href="${pageContext.request.contextPath}/product?id=${item.product.id}">
                                <img src="${item.imageUrl}" alt="${item.product.name}">
                            </a>
                            <c:if test="${item.product.stockQuantity <= 0}">
                                <div class="out-of-stock-overlay">Hết hàng</div>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <h2>${item.product.name}</h2>
                            <c:if test="${item.product.stockQuantity > 0 && item.product.stockQuantity < item.quantity}">
                                <span class="stock-warning">Số lượng trong kho không đủ (còn ${item.product.stockQuantity})</span>
                            </c:if>
                        </div>
                    </td>

                    <td class="price-cell">
                        <c:choose>
                            <c:when test="${item.product.discountPrice != null && item.product.discountPrice > 0}">
                                <span class="price-original">
                                    <fmt:formatNumber value="${item.product.originalPrice}" type="number" /> VNĐ
                                </span>
                                <fmt:formatNumber value="${item.product.discountPrice}" type="number" /> VNĐ
                                <span class="price-discount-badge">SALE</span>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${item.product.originalPrice}" type="number" /> VNĐ
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <div class="qty-control" data-product-id="${item.product.id}">
                            <button type="button" class="btn-decrease" title="Giảm">
                                <i class="fas fa-minus" style="font-size:10px;"></i>
                            </button>
                            <input type="number"
                                   class="qty-input"
                                   value="${item.quantity}"
                                   min="1"
                                   max="${item.product.stockQuantity}"
                                   data-original="${item.quantity}">
                            <button type="button" class="btn-increase" title="Tăng">
                                <i class="fas fa-plus" style="font-size:10px;"></i>
                            </button>
                        </div>
                    </td>

                    <td class="total-cell item-total-${item.product.id}">
                        <fmt:formatNumber value="${item.product.displayPrice * item.quantity}" type="number" /> VNĐ
                    </td>

                    <td style="text-align:center">
                        <button class="btn-remove" title="Xóa sản phẩm"
                                onclick="removeItem(${item.product.id})">
                            <i class="fa-solid fa-trash-can"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${not empty cart.items}">
            <div class="cart-footer">
                <div class="footer-left">
                    <span class="select-count-badge">
                        Đã chọn: <strong id="selected-count">0</strong> sản phẩm
                    </span>
                </div>
                <div class="footer-right">
                    <div class="cart-summary">
                        <span class="label">Tạm tính (đã chọn)</span>
                        <span class="amount" id="cart-total">0 VNĐ</span>
                    </div>
                    <div class="divider-v"></div>
                    <form id="checkout-form"
                          action="${pageContext.request.contextPath}/checkout"
                          method="POST"
                          style="margin:0">
                        <input type="hidden" name="selectedProductIds" id="selected-ids-input" value="">
                        <button type="submit" id="btn-checkout" class="btn-checkout" disabled
                                title="Vui lòng chọn ít nhất một sản phẩm để thanh toán">
                            Thanh toán <i class="fas fa-arrow-right" style="font-size:12px;"></i>
                        </button>
                    </form>
                </div>
            </div>
            <c:if test="${anyOutOfStock}">
                <p class="stock-warning-footer">
                    <i class="fas fa-exclamation-circle me-1"></i>
                    Sản phẩm <strong>Hết hàng</strong> không thể chọn để thanh toán.
                </p>
            </c:if>        </c:if>

    </div>
</main>

<!-- Import component Footer -->
<jsp:include page="components/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';

        function formatVND(num) {
            return Math.round(num).toLocaleString('vi-VN');
        }

        // Tính lại tổng tiền từ những sản phẩm ĐƯỢC CHỌN
        function recalcSelectedTotal() {
            var total = 0;
            var count = 0;

            document.querySelectorAll('.item-checkbox:checked').forEach(function (cb) {
                var productId = cb.dataset.productId;
                var unitPrice = parseFloat(cb.dataset.unitPrice) || 0;
                var qtyInput  = document.querySelector(
                    '.qty-control[data-product-id="' + productId + '"] .qty-input');
                var qty = qtyInput ? (parseInt(qtyInput.value) || 0) : 0;
                total += unitPrice * qty;
                count++;
            });

            document.getElementById('cart-total').textContent     = formatVND(total) + ' VNĐ';
            document.getElementById('selected-count').textContent  = count;

            var btn = document.getElementById('btn-checkout');
            btn.disabled = (count === 0);
            btn.title    = count === 0 ? 'Vui lòng chọn ít nhất một sản phẩm để thanh toán' : '';

            // Đồng bộ trạng thái "select-all"
            var allCheckable = document.querySelectorAll('.item-checkbox:not(:disabled)');
            var allChecked   = document.querySelectorAll('.item-checkbox:not(:disabled):checked');
            var selectAll    = document.getElementById('select-all');
            if (allCheckable.length === 0) {
                selectAll.checked = false;
            } else if (allChecked.length === allCheckable.length) {
                selectAll.checked = true; selectAll.indeterminate = false;
            } else if (allChecked.length === 0) {
                selectAll.checked = false; selectAll.indeterminate = false;
            } else {
                selectAll.checked = false; selectAll.indeterminate = true;
            }
        }

        // Checkbox từng sản phẩm
        document.querySelectorAll('.item-checkbox').forEach(function (cb) {
            cb.addEventListener('change', function () {
                var row = document.querySelector(
                    'tr.cart-row[data-product-id="' + cb.dataset.productId + '"]');
                if (row) row.classList.toggle('row-selected', cb.checked);
                recalcSelectedTotal();
            });
        });

        // Checkbox "Chọn tất cả"
        document.getElementById('select-all').addEventListener('change', function () {
            var checked = this.checked;
            document.querySelectorAll('.item-checkbox:not(:disabled)').forEach(function (cb) {
                cb.checked = checked;
                var row = document.querySelector(
                    'tr.cart-row[data-product-id="' + cb.dataset.productId + '"]');
                if (row) row.classList.toggle('row-selected', checked);
            });
            recalcSelectedTotal();
        });

        // Form: gắn selectedProductIds trước khi submit
        document.getElementById('checkout-form').addEventListener('submit', function (e) {
            var selectedIds = Array.from(
                document.querySelectorAll('.item-checkbox:checked'))
                .map(function (cb) { return cb.dataset.productId; });

            if (selectedIds.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất một sản phẩm để thanh toán!');
                return;
            }
            document.getElementById('selected-ids-input').value = selectedIds.join(',');
        });



        function sendUpdate(productId, action, quantity, qtyInput, max) {
            var body = 'productId=' + productId + '&action=' + action;
            if (action === 'set') body += '&quantity=' + quantity;

            // Disable cả 3 nút trong lúc gửi
            var control = qtyInput.closest('.qty-control');
            control.querySelectorAll('button, input').forEach(function(el){ el.disabled = true; });
            qtyInput.style.opacity = '0.4';

            fetch(ctx + '/update-cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body
            })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (!data.success) {
                        if (typeof window.showGlobalToast === 'function') {
                            window.showGlobalToast('error', data.message);
                        }
                        qtyInput.value = qtyInput.dataset.original;
                        return;
                    }

                    // Cập nhật ô số lượng
                    qtyInput.value = data.newQty;
                    qtyInput.dataset.original = data.newQty;

                    // Cập nhật tổng tiền từng dòng
                    var itemTotalEl = document.querySelector('.item-total-' + productId);
                    if (itemTotalEl) itemTotalEl.textContent = formatVND(data.itemTotal) + ' VNĐ';

                    // Cập nhật tổng giỏ hàng
                    var cartTotalEl = document.getElementById('cart-total');
                    if (cartTotalEl) cartTotalEl.textContent = formatVND(data.cartTotal) + ' VNĐ';

                    // Cập nhật badge số lượng trên icon giỏ hàng (nếu có)
                    var badge = document.getElementById('cart-badge');
                    if (badge) badge.textContent = data.totalQuantity;

                    recalcSelectedTotal();

                    if (data.warning && typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('error', data.warning);
                    }
                })
                .catch(function(err) {
                    console.error('Lỗi cập nhật giỏ hàng:', err);
                    alert('Có lỗi xảy ra, vui lòng thử lại.');
                })
                .finally(function() {
                    control.querySelectorAll('button, input').forEach(function(el){ el.disabled = false; });
                    qtyInput.style.opacity = '1';
                });
        }

        document.querySelectorAll('.qty-control').forEach(function(control) {
            var productId = control.dataset.productId;
            var qtyInput  = control.querySelector('.qty-input');
            var max       = parseInt(qtyInput.getAttribute('max'));

            // Nút −
            control.querySelector('.btn-decrease').addEventListener('click', function() {
                if (parseInt(qtyInput.value) <= 1) return;
                sendUpdate(productId, 'decrease', null, qtyInput, max);
            });

            // Nút +
            control.querySelector('.btn-increase').addEventListener('click', function() {
                if (parseInt(qtyInput.value) >= max) {
                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('error', 'Chỉ còn ' + max + ' sản phẩm trong kho!');
                    }
                    return;
                }
                sendUpdate(productId, 'increase', null, qtyInput, max);
            });

            // Nhập tay — Enter hoặc blur
            qtyInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    this.blur();
                }
                if (!/[\d]/.test(e.key) && !['Backspace','Delete','ArrowLeft','ArrowRight','Tab'].includes(e.key)) {
                    e.preventDefault();
                }
            });

            qtyInput.addEventListener('blur', function() {
                var val = parseInt(this.value);
                if (isNaN(val) || val < 1) { this.value = this.dataset.original; return; }
                if (val === parseInt(this.dataset.original)) return; // không đổi thì thôi
                sendUpdate(productId, 'set', val, qtyInput, max);
            });
        });
    })();
    function removeItem(productId) {
        var row = document.querySelector('tr.cart-row[data-product-id="' + productId + '"]');

        // Confirm đẹp dùng toast thay vì alert
        if (!confirm('Bạn muốn xóa sản phẩm này khỏi giỏ hàng?')) return;

        var ctx = '${pageContext.request.contextPath}';

        fetch(ctx + '/del-item', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + productId
        })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.success) {
                    // Animation xóa dòng, không reload
                    if (row) {
                        row.style.transition = 'opacity 0.3s, transform 0.3s';
                        row.style.opacity = '0';
                        row.style.transform = 'translateX(20px)';
                        setTimeout(function() {
                            row.remove();
                            // Nếu giỏ trống thì hiện trạng thái trống
                            var tbody = document.querySelector('tbody');
                            var remaining = tbody.querySelectorAll('tr.cart-row');
                            if (remaining.length === 0) {
                                tbody.innerHTML = '<tr><td colspan="6" class="empty-cart-cell">'
                                    + '<i class="fas fa-shopping-basket fa-3x"></i>'
                                    + '<span>Giỏ hàng của bạn đang trống</span>'
                                    + '</td></tr>';
                                // Ẩn footer
                                var footer = document.querySelector('.cart-footer');
                                if (footer) footer.style.display = 'none';
                            }
                            recalcSelectedTotal();
                        }, 300);
                    }
                    // Cập nhật badge header
                    var badge = document.getElementById('cart-badge');
                    if (badge) badge.textContent = data.totalQuantity;

                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('success', 'Đã xóa sản phẩm khỏi giỏ hàng');
                    }
                } else {
                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('error', data.message);
                    }
                }
            })
            .catch(function() {
                if (typeof window.showGlobalToast === 'function') {
                    window.showGlobalToast('error', 'Có lỗi xảy ra, vui lòng thử lại.');
                }
            });
    }
    recalcSelectedTotal();
    function goToProductDetail(productId) {
        sessionStorage.setItem('selectedProductId', productId);
        window.location.href = 'product?id=' + productId;
    }
</script>
</body>

</html>