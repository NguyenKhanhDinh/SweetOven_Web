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
        :root {
            --primary: #8B4513;
            --secondary: #D4A76A;
            --accent: #8A4B24;
            --muted: #85756b;
            --border: #f2e7de;
            --bg: #fffdfb;
            --radius: 14px;
            --brand: #3c2f27;
        }

        /* --- SỬA LỖI LAYOUT BẰNG FLEXBOX --- */
        body {
            padding-top: 100px;
            font-family: 'Quicksand', sans-serif;
            background: var(--bg);
            color: var(--brand);
            margin: 0;
            /* Cấu trúc Flexbox giúp đẩy footer xuống đáy */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        main {
            padding: 20px 0 60px 0;
            /* Bắt buộc main giãn ra để lấp đầy khoảng trống */
            flex: 1 0 auto;
        }
        /* ------------------------------------ */

        /* Đổi h1 thành class để tránh ảnh hưởng đến h1 của Header/Footer */
        .cart-title {
            text-align: center;
            margin-bottom: 40px;
            font-size: 32px;
            color: var(--brand);
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .content {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            background: white;
            border-radius: var(--radius);
            box-shadow: 0 6px 18px rgba(92, 44, 22, 0.05);
            overflow: hidden;
        }

        .content th {
            background: #faf7f4;
            color: var(--brand);
            text-align: left;
            padding: 16px 20px;
            font-size: 15px;
            font-weight: 600;
        }

        .content td {
            padding: 20px;
            border-top: 1px solid var(--border);
            vertical-align: middle;
        }
        .th-check, .td-check {
            width: 52px; text-align: center !important;
            padding-left: 16px !important; padding-right: 8px !important;
        }
        .cart-checkbox {
            width: 20px; height: 20px;
            cursor: pointer; accent-color: var(--primary);
        }
        tr.row-selected > td { background: #fdf5ee; }
        tr.row-out-of-stock .cart-checkbox { opacity: 0.35; cursor: not-allowed; }

        .san-pham {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .san-pham img {
            width: 100px;
            height: 100px;
            border-radius: 10px;
            border: 1px solid #eee;
            object-fit: cover;
        }

        .img-container {
            position: relative;
            width: 100px;
            height: 100px;
        }

        .out-of-stock-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            text-transform: uppercase;
            border-radius: 10px;
            z-index: 2;
        }

        .stock-warning {
            color: #d9534f;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .product-info h2 {
            font-size: 16px;
            color: var(--brand);
            margin: 0;
            font-weight: 600;
        }

        .product-info p {
            font-size: 13px;
            color: var(--muted);
            margin: 4px 0;
        }

        .qty-control {
            display: inline-flex;
            align-items: center;
            gap: 0;
            border: 1.5px solid #e0d5cc;
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            transition: border-color 0.2s;
        }

        .qty-control:focus-within {
            border-color: var(--primary);
        }

        .qty-control button {
            background: transparent;
            color: var(--primary);
            border: none;
            width: 34px;
            height: 34px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 400;
            line-height: 1;
            transition: background 0.15s, color 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .qty-control button:hover:not(:disabled) {
            background: var(--primary);
            color: #fff;
        }

        .qty-control button:disabled {
            color: #ccc;
            cursor: not-allowed;
        }

        .qty-control input.qty-input {
            width: 44px;
            height: 34px;
            border: none;
            border-left: 1px solid #eee;
            border-right: 1px solid #eee;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            color: var(--brand);
            background: #fafafa;
            outline: none;
            -moz-appearance: textfield;
        }

        .qty-control input.qty-input::-webkit-inner-spin-button,
        .qty-control input.qty-input::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .qty-control input.qty-input:focus {
            background: #fff;
        }
        .cart-footer {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 24px;
            margin-top: 24px;
            padding: 20px 28px;
            background: #fff;
            border-radius: 14px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 16px rgba(92, 44, 22, 0.06);
        }

        .cart-summary {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 2px;
        }

        .cart-summary .label {
            font-size: 12px;
            font-weight: 500;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .cart-summary .amount {
            font-size: 26px;
            font-weight: 800;
            color: var(--primary);
            letter-spacing: -0.5px;
        }

        .divider-v {
            width: 1px;
            height: 44px;
            background: var(--border);
            flex-shrink: 0;
        }

        .btn-checkout {
            height: 48px;
            padding: 0 32px;
            background: linear-gradient(135deg, var(--primary), #A0522D);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 0.8px;
            cursor: pointer;
            transition: all 0.25s;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .btn-checkout:hover:not(:disabled) {
            background: linear-gradient(135deg, #A0522D, var(--secondary));
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(139, 69, 19, 0.25);
        }

        .btn-checkout:disabled {
            background: #e0d5cc;
            color: #a89080;
            cursor: not-allowed;
        }

        .stock-warning-footer {
            font-size: 12px;
            color: #c0392b;
            text-align: right;
            margin-top: 8px;
        }

        @media (max-width: 576px) {
            .cart-footer {
                flex-direction: column;
                align-items: stretch;
                gap: 16px;
                padding: 16px;
            }
            .cart-summary {
                align-items: flex-start;
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
            }
            .divider-v { display: none; }
            .btn-checkout { width: 100%; }
        }


            .content th,
            .content td {
                padding: 12px 15px;
            }

            .san-pham {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .san-pham img {
                width: 80px;
                height: 80px;
            }

            .btn-checkout {
                width: 100%;
            }

    </style>
</head>

<body>
<!-- Import component Header -->
<jsp:include page="components/header.jsp" />

<main>
    <div class="container">
        <!-- Đã sửa thành class .cart-title -->
        <h1 class="cart-title">GIỎ HÀNG</h1>

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
                    <td colspan="5" style="text-align:center; padding: 40px; color: #888;">
                        <i class="fas fa-shopping-basket fa-3x mb-3" style="color: #ddd;"></i><br>
                        Giỏ hàng của bạn đang trống
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

                    <td>
                        <fmt:formatNumber value="${item.product.displayPrice}" type="number" /> VNĐ
                    </td>

                    <td>
                        <div class="qty-control" data-product-id="${item.product.id}">
                            <button type="button" class="btn-decrease" title="Giảm">
                                <i class="fas fa-minus" style="font-size:11px;"></i>
                            </button>
                            <input type="number"
                                   class="qty-input"
                                   value="${item.quantity}"
                                   min="1"
                                   max="${item.product.stockQuantity}"
                                   data-original="${item.quantity}">
                            <button type="button" class="btn-increase" title="Tăng">
                                <i class="fas fa-plus" style="font-size:11px;"></i>
                            </button>
                        </div>
                    </td>

                    <td class="item-total-${item.product.id}">
                        <fmt:formatNumber value="${item.product.displayPrice * item.quantity}" type="number" /> VNĐ
                    </td>

                    <td style="text-align:center">
                        <button class="btn btn-link text-danger" title="Xóa sản phẩm"
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
                            Thanh toán <i class="fas fa-arrow-right ms-2" style="font-size:13px;"></i>
                        </button>
                    </form>
                </div>
            </div>
            <c:if test="${anyOutOfStock}">
                <p class="stock-warning-footer">
                    <i class="fas fa-exclamation-circle me-1"></i>
                    Sản phẩm <strong>Hết hàng</strong> không thể chọn để thanh toán.
                </p>
            </c:if>
        </c:if>

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

            fetch(ctx + '/update-cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body
            })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (!data.success) {
                        alert(data.message);
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

                    if (data.warning) alert(data.warning);
                })
                .catch(function(err) {
                    console.error('Lỗi cập nhật giỏ hàng:', err);
                    alert('Có lỗi xảy ra, vui lòng thử lại.');
                })
                .finally(function() {
                    control.querySelectorAll('button, input').forEach(function(el){ el.disabled = false; });
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
                    alert('Chỉ còn ' + max + ' sản phẩm trong kho!');
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
        if (!confirm('Xóa sản phẩm này?')) return;

        fetch('${pageContext.request.contextPath}/del-item', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + productId
    })
        .then(res => res.json())
        .then(data => {
        if (data.success) {
        location.reload();
    } else {
        alert(data.message);
    }
    })
        .catch(err => console.error('Lỗi xóa sản phẩm:', err));
    }
    recalcSelectedTotal();
    function goToProductDetail(productId) {
        sessionStorage.setItem('selectedProductId', productId);
        window.location.href = 'product?id=' + productId;
    }
</script>
</body>

</html>