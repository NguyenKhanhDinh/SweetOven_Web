<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary:   #8B4513;
            --secondary: #D4A76A;
            --muted:     #85756b;
            --border:    #f2e7de;
            --bg:        #fffdfb;
            --radius:    14px;
            --brand:     #3c2f27;
        }
        * { box-sizing: border-box; }
        body {
            padding-top: 100px;
            font-family: 'Quicksand', sans-serif;
            background: var(--bg);
            color: var(--brand);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }
        main { flex: 1 0 auto; padding: 28px 0 60px; }

        /* ── Page title ── */
        .page-title {
            font-size: 28px; font-weight: 700;
            text-align: center; margin-bottom: 32px;
            color: var(--brand); letter-spacing: .4px;
        }
        .page-title small {
            display: block; font-size: 14px;
            font-weight: 400; color: var(--muted); margin-top: 4px;
        }

        /* ── Cards ── */
        .card-section {
            background: #fff;
            border-radius: var(--radius);
            box-shadow: 0 4px 18px rgba(92,44,22,.06);
            padding: 24px 28px;
            margin-bottom: 20px;
        }
        .card-section h2 {
            font-size: 15px; font-weight: 700;
            color: var(--brand); margin: 0 0 18px;
            display: flex; align-items: center; gap: 8px;
        }
        .card-section h2 i { color: var(--primary); font-size: 16px; }

        /* ── Address selector (logged-in) ── */
        .addr-select-wrap {
            background: #fdf5ee;
            border: 1px solid #f0dece;
            border-radius: 10px;
            padding: 14px 16px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .addr-select-wrap label {
            font-size: 13px; font-weight: 600;
            color: var(--primary); white-space: nowrap;
            margin: 0;
        }
        .addr-select-wrap select {
            flex: 1;
            border: 1.5px solid #e0d5cc;
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 13px;
            font-family: 'Quicksand', sans-serif;
            color: var(--brand);
            background: #fff;
            cursor: pointer;
            outline: none;
        }
        .addr-select-wrap select:focus { border-color: var(--primary); }

        /* ── Form fields ── */
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        @media(max-width:576px) { .form-row { grid-template-columns: 1fr; } }

        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 14px; }
        .form-group label { font-size: 13px; font-weight: 600; color: var(--muted); }
        .form-group label span.req { color: #e05c5c; margin-left: 2px; }
        .form-control-custom {
            border: 1.5px solid #e0d5cc;
            border-radius: 9px;
            padding: 10px 14px;
            font-size: 14px;
            font-family: 'Quicksand', sans-serif;
            color: var(--brand);
            background: #fff;
            outline: none;
            transition: border-color .2s;
            width: 100%;
        }
        .form-control-custom:focus { border-color: var(--primary); }
        .form-control-custom::placeholder { color: #bfb0a6; }
        textarea.form-control-custom { resize: vertical; min-height: 80px; }

        /* ── Guest notice ── */
        .guest-notice {
            background: #f0f7ff;
            border: 1px solid #c8dff5;
            border-radius: 10px;
            padding: 11px 16px;
            font-size: 13px;
            color: #3b6b9a;
            margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }

        /* ── Order summary (right column) ── */
        .order-item {
            display: flex; align-items: center;
            gap: 12px; padding: 10px 0;
            border-bottom: 1px solid var(--border);
        }
        .order-item:last-child { border-bottom: none; }
        .order-item img {
            width: 60px; height: 60px;
            border-radius: 8px; object-fit: cover;
            border: 1px solid #eee; flex-shrink: 0;
        }
        .order-item-info { flex: 1; min-width: 0; }
        .order-item-info .name {
            font-size: 14px; font-weight: 600;
            color: var(--brand); white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
        }
        .order-item-info .qty {
            font-size: 12px; color: var(--muted); margin-top: 2px;
        }
        .order-item-price {
            font-size: 14px; font-weight: 700;
            color: var(--primary); white-space: nowrap;
            flex-shrink: 0;
        }

        /* Summary totals */
        .summary-row {
            display: flex; justify-content: space-between;
            font-size: 14px; padding: 7px 0;
            border-bottom: 1px dashed var(--border);
        }
        .summary-row:last-child { border-bottom: none; }
        .summary-row .lbl { color: var(--muted); }
        .summary-row .val { font-weight: 600; color: var(--brand); }
        .summary-row.total-row {
            padding-top: 12px;
            border-top: 2px solid var(--border) !important;
            border-bottom: none;
        }
        .summary-row.total-row .lbl { font-size: 15px; font-weight: 700; color: var(--brand); }
        .summary-row.total-row .val { font-size: 20px; font-weight: 800; color: var(--primary); }

        /* ── Sticky right column on desktop ── */
        .right-col-sticky {
            position: sticky;
            top: 110px;
        }

        /* ── Submit button ── */
        .btn-place-order {
            width: 100%;
            height: 50px;
            margin-top: 16px;
            background: linear-gradient(135deg, var(--primary), #A0522D);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: .8px;
            cursor: pointer;
            text-transform: uppercase;
            transition: all .25s;
        }
        .btn-place-order:hover {
            background: linear-gradient(135deg, #A0522D, var(--secondary));
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(139,69,19,.25);
        }

        /* ── Back to cart link ── */
        .back-link {
            font-size: 13px; color: var(--muted);
            text-decoration: none;
            display: inline-flex; align-items: center; gap: 6px;
            margin-bottom: 20px;
            transition: color .2s;
        }
        .back-link:hover { color: var(--primary); }

        /* ── Empty checkout guard ── */
        .empty-checkout {
            text-align: center; padding: 60px 20px;
            color: var(--muted); font-size: 16px;
        }
        .empty-checkout i { font-size: 48px; color: #ddd; margin-bottom: 16px; }

        /* ── Error alert ── */
        .alert-cart-error {
            background: #fef2f2; border: 1px solid #fca5a5;
            border-radius: 10px; padding: 12px 16px;
            font-size: 13px; color: #b91c1c; margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }

        /* ── Payment options ── */
        .payment-option {
            display: flex;
            align-items: center;
            gap: 12px;
            border: 2px solid #e0d5cc;
            border-radius: 10px;
            padding: 12px 16px;
            cursor: pointer;
            transition: border-color .2s, background .2s;
            background: #fff;
            user-select: none;
        }
        .payment-option:hover { border-color: var(--secondary); background: #fffaf6; }
        .payment-option.selected {
            border-color: var(--primary);
            background: #fdf5ee;
        }
        .pm-radio {
            width: 18px; height: 18px; flex-shrink: 0;
            border-radius: 50%;
            border: 2px solid #ccc;
            display: flex; align-items: center; justify-content: center;
            transition: border-color .2s;
        }
        .payment-option.selected .pm-radio {
            border-color: var(--primary);
            background: var(--primary);
            box-shadow: inset 0 0 0 3px #fff;
        }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp" />

<main>
    <div class="container">

        <!-- Back to cart -->
        <a href="${pageContext.request.contextPath}/my-cart" class="back-link">
            <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
        </a>

        <h1 class="page-title">
            THANH TOÁN
            <small>Kiểm tra lại đơn hàng và điền thông tin giao hàng</small>
        </h1>

        <!-- Error message if any -->
        <c:if test="${not empty errorMsg}">
            <div class="alert-cart-error">
                <i class="fas fa-exclamation-circle"></i> ${errorMsg}
            </div>
        </c:if>

        <!-- Guard: no checkout items -->
        <c:if test="${empty checkoutItems}">
            <div class="empty-checkout">
                <i class="fas fa-shopping-basket d-block"></i>
                Không có sản phẩm nào được chọn.<br>
                <a href="${pageContext.request.contextPath}/my-cart"
                   style="color:var(--primary); font-weight:600; margin-top:12px; display:inline-block;">
                    Quay lại giỏ hàng
                </a>
            </div>
        </c:if>

        <c:if test="${not empty checkoutItems}">
            <!-- Embed address list as JSON for JS -->
            <c:if test="${not empty userAddresses}">
                <script>
                    var USER_ADDRESSES = [
                        <c:forEach var="addr" items="${userAddresses}" varStatus="s">
                        {
                            id:            ${addr.id},
                            addressDetail: "${addr.addressDetail}",
                            ward:          "${addr.ward}",
                            district:      "${addr.district}",
                            province:      "${addr.province}",
                            isDefault:     ${addr.isDefault}
                        }<c:if test="${!s.last}">,</c:if>
                        </c:forEach>
                    ];
                </script>
            </c:if>
            <c:if test="${empty userAddresses}">
                <script>var USER_ADDRESSES = [];</script>
            </c:if>

            <div class="row g-4">

                <!-- ═══════════════ LEFT: Delivery form ═══════════════ -->
                <div class="col-lg-7">

                    <form id="checkout-form"
                          action="${pageContext.request.contextPath}/place-order"
                          method="POST">

                        <!-- Hidden: pass selected product IDs to order controller -->
                        <input type="hidden" name="selectedProductIds" value="${selectedProductIds}">
                        <!-- Hidden: ID địa chỉ đã lưu được chọn (rỗng nếu nhập mới) -->
                        <input type="hidden" id="selected-address-id" name="selectedAddressId" value="">

                        <!-- ── Address picker (logged-in only) ── -->
                        <c:if test="${not empty sessionScope.user}">
                            <div class="card-section">
                                <h2><i class="fas fa-map-marker-alt"></i> Địa chỉ đã lưu</h2>

                                <c:choose>
                                    <c:when test="${not empty userAddresses}">
                                        <div class="addr-select-wrap">
                                            <label for="addr-select">
                                                <i class="fas fa-location-dot me-1"></i>Chọn địa chỉ:
                                            </label>
                                            <select id="addr-select" onchange="fillAddress(this.value)">
                                                <c:forEach var="addr" items="${userAddresses}">
                                                    <option value="${addr.id}"
                                                        ${addr.isDefault ? 'selected' : ''}>
                                                            ${addr.addressDetail},
                                                            ${not empty addr.ward ? addr.ward.concat(', ') : ''}
                                                            ${not empty addr.district ? addr.district.concat(', ') : ''}
                                                            ${addr.province}
                                                            ${addr.isDefault ? '(Mặc định)' : ''}
                                                    </option>
                                                </c:forEach>
                                                <option value="">-- Nhập địa chỉ mới --</option>
                                            </select>
                                        </div>
                                        <!-- Badge trạng thái địa chỉ -->
                                        <div id="addr-mode-badge" style="font-size:12px; color:var(--primary); margin-bottom:8px; display:flex; align-items:center; gap:6px;">
                                            <i class="fas fa-lock"></i>
                                            <span>Đang dùng địa chỉ đã lưu — chọn <strong>"Nhập địa chỉ mới"</strong> để nhập thủ công</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="font-size:13px; color:var(--muted); margin:0 0 4px;">
                                            Bạn chưa có địa chỉ đã lưu.
                                            <a href="${pageContext.request.contextPath}/profile"
                                               style="color:var(--primary); font-weight:600;">
                                                Thêm địa chỉ
                                            </a>
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <!-- ── Guest notice ── -->
                        <c:if test="${empty sessionScope.user}">
                            <div class="guest-notice">
                                <i class="fas fa-info-circle"></i>
                                Bạn đang đặt hàng với tư cách khách.
                                <a href="${pageContext.request.contextPath}/login?redirect=checkout"
                                   style="font-weight:700; margin-left:4px; color:#1e6ca8;">
                                    Đăng nhập
                                </a>
                                để tự động điền địa chỉ đã lưu.
                            </div>
                        </c:if>

                        <!-- ── Contact & delivery info ── -->
                        <div class="card-section">
                            <h2><i class="fas fa-user"></i> Thông tin nhận hàng</h2>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Họ và tên <span class="req">*</span></label>
                                    <input type="text" id="field-fullname" name="fullName"
                                           class="form-control-custom"
                                           placeholder="Nguyễn Văn A"
                                           value="${not empty sessionScope.user ? sessionScope.user.fullName : ''}"
                                           required>
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại <span class="req">*</span></label>
                                    <input type="tel" id="field-phone" name="phoneNumber"
                                           class="form-control-custom"
                                           placeholder="0901 234 567"
                                           value="${not empty sessionScope.user ? sessionScope.user.phoneNumber : ''}"
                                           required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Địa chỉ chi tiết <span class="req">*</span></label>
                                <input type="text" id="field-address" name="addressDetail"
                                       class="form-control-custom"
                                       placeholder="Số nhà, tên đường..."
                                       required>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Phường / Xã</label>
                                    <input type="text" id="field-ward" name="ward"
                                           class="form-control-custom"
                                           placeholder="Phường / Xã">
                                </div>
                                <div class="form-group">
                                    <label>Quận / Huyện</label>
                                    <input type="text" id="field-district" name="district"
                                           class="form-control-custom"
                                           placeholder="Quận / Huyện">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Tỉnh / Thành phố <span class="req">*</span></label>
                                <input type="text" id="field-province" name="province"
                                       class="form-control-custom"
                                       placeholder="TP. Hồ Chí Minh"
                                       required>
                            </div>

                            <div class="form-group" style="margin-bottom:0;">
                                <label>Ghi chú đơn hàng</label>
                                <textarea name="note" class="form-control-custom"
                                          placeholder="Giao giờ hành chính, để lại trước cửa..."></textarea>
                            </div>
                        </div>

                        <!-- ── Mã giảm giá ── -->
                        <div class="card-section">
                            <h2><i class="fas fa-tag"></i> Mã giảm giá</h2>
                            <div style="display:flex; gap:10px; align-items:center;">
                                <input type="text" id="discount-code-input"
                                       class="form-control-custom" style="flex:1; text-transform:uppercase;"
                                       placeholder="Nhập mã giảm giá..."
                                       oninput="this.value=this.value.toUpperCase()">
                                <button type="button" onclick="applyDiscount()"
                                        style="background:var(--primary); color:#fff; border:none; border-radius:9px;
                                               padding:10px 18px; font-size:13px; font-weight:700; cursor:pointer;
                                               white-space:nowrap; transition:background .2s;"
                                        onmouseover="this.style.background='#A0522D'"
                                        onmouseout="this.style.background='var(--primary)'">
                                    Áp dụng
                                </button>
                            </div>
                            <!-- Thông báo kết quả -->
                            <div id="discount-msg" style="display:none; margin-top:10px; font-size:13px;
                                 border-radius:8px; padding:9px 13px;"></div>
                            <!-- Nút xoá mã (hiện khi đã áp dụng) -->
                            <div id="discount-applied-row" style="display:none; margin-top:10px;
                                 font-size:13px; display:none; align-items:center; gap:8px;">
                                <i class="fas fa-check-circle" style="color:#16a34a;"></i>
                                <span id="discount-applied-label" style="color:#16a34a; font-weight:600;"></span>
                                <button type="button" onclick="removeDiscount()"
                                        style="margin-left:auto; background:none; border:none; color:#e05c5c;
                                               font-size:12px; cursor:pointer; font-weight:700;">
                                    ✕ Xoá
                                </button>
                            </div>
                            <!-- Hidden fields gửi kèm form -->
                            <input type="hidden" id="applied-discount-id" name="discountId" value="0">
                            <input type="hidden" id="applied-discount-amount" name="discountAmount" value="0">
                        </div>

                        <!-- ── Phương thức thanh toán ── -->
                        <div class="card-section">
                            <h2><i class="fas fa-credit-card"></i> Phương thức thanh toán</h2>
                            <input type="hidden" id="payment-method-val" name="paymentMethod" value="1">

                            <div style="display:flex; flex-direction:column; gap:10px;">

                                <!-- COD -->
                                <label class="payment-option selected" id="pm-cod" onclick="selectPayment('cod', this)">
                                    <div class="pm-radio"></div>
                                    <img src="${pageContext.request.contextPath}/assets/picture/cod-icon.png"
                                         onerror="this.style.display='none'"
                                         style="width:32px; height:32px; object-fit:contain;">
                                    <div>
                                        <div style="font-weight:700; font-size:14px;">Thanh toán khi nhận hàng (COD)</div>
                                        <div style="font-size:12px; color:var(--muted);">Trả tiền mặt khi shipper giao hàng</div>
                                    </div>
                                </label>

                                <!-- MoMo -->
                                <label class="payment-option" id="pm-momo" onclick="selectPayment('momo', this)">
                                    <div class="pm-radio"></div>
                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-MoMo-Square-300x300.png"
                                         style="width:32px; height:32px; object-fit:contain; border-radius:6px;">
                                    <div>
                                        <div style="font-weight:700; font-size:14px;">Ví MoMo</div>
                                        <div style="font-size:12px; color:var(--muted);">Thanh toán qua ví điện tử MoMo</div>
                                    </div>
                                </label>

                                <!-- VNPay -->
                                <label class="payment-option" id="pm-vnpay" onclick="selectPayment('vnpay', this)">
                                    <div class="pm-radio"></div>
                                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLeYoMVenMbgWL1FxDJPKuQvJD6R0KdnXE7A&s"
                                         onerror="this.style.display='none'"
                                         style="width:32px; height:32px; object-fit:contain;">
                                    <div>
                                        <div style="font-weight:700; font-size:14px;">VNPay</div>
                                        <div style="font-size:12px; color:var(--muted);">ATM / Thẻ tín dụng / QR Code</div>
                                    </div>
                                </label>

                            </div>
                        </div>

                    </form><!-- #checkout-form -->
                </div>

                <!-- ═══════════════ RIGHT: Order summary ═══════════════ -->
                <div class="col-lg-5">
                    <div class="right-col-sticky">

                        <!-- Product list -->
                        <div class="card-section">
                            <h2><i class="fas fa-receipt"></i> Đơn hàng của bạn</h2>

                            <c:forEach var="item" items="${checkoutItems}">
                                <div class="order-item">
                                    <img src="${item.imageUrl}" alt="${item.product.name}">
                                    <div class="order-item-info">
                                        <div class="name">${item.product.name}</div>
                                        <div class="qty">
                                            <fmt:formatNumber value="${item.product.displayPrice}" type="number"/> VNĐ
                                            &times; ${item.quantity}
                                        </div>
                                    </div>
                                    <div class="order-item-price">
                                        <fmt:formatNumber value="${item.product.displayPrice * item.quantity}" type="number"/> VNĐ
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Totals -->
                        <div class="card-section">
                            <div class="summary-row">
                                <span class="lbl">Tiền hàng</span>
                                <span class="val">
                                    <fmt:formatNumber value="${checkoutTotal}" type="number"/> VNĐ
                                </span>
                            </div>
                            <!-- Dòng giảm giá (JS ẩn/hiện) -->
                            <div class="summary-row" id="discount-summary-row" style="display:none;">
                                <span class="lbl" style="color:#16a34a;"><i class="fas fa-tag me-1"></i>Giảm giá</span>
                                <span class="val" id="discount-summary-val" style="color:#16a34a;">-0 VNĐ</span>
                            </div>
                            <div class="summary-row">
                                <span class="lbl">Phí giao hàng</span>
                                <span class="val">
                                    <fmt:formatNumber value="${shippingFee}" type="number"/> VNĐ
                                </span>
                            </div>
                            <div class="summary-row total-row">
                                <span class="lbl">Tổng cộng</span>
                                <span class="val" id="final-total-display">
                                    <fmt:formatNumber value="${finalTotal}" type="number"/> VNĐ
                                </span>
                            </div>

                            <button type="submit" form="checkout-form" class="btn-place-order" id="btn-place-order">
                                <i class="fas fa-check-circle me-2"></i>
                                <span id="btn-place-order-text">Đặt hàng (COD)</span>
                            </button>

                            <p style="font-size:12px; color:var(--muted); text-align:center; margin-top:10px; margin-bottom:0;">
                                <i class="fas fa-lock me-1"></i>
                                Đơn hàng của bạn được bảo mật
                            </p>
                        </div>

                    </div><!-- .right-col-sticky -->
                </div>

            </div><!-- .row -->
        </c:if>

    </div><!-- .container -->
</main>

<jsp:include page="/components/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var SUBTOTAL    = ${checkoutTotal};   // từ server (số nguyên VNĐ)
    var SHIPPING    = ${shippingFee};
    var FINAL_TOTAL = ${finalTotal};      // ban đầu = SUBTOTAL + SHIPPING

    var currentDiscountAmount = 0;
    var currentDiscountId     = 0;
    var currentPaymentMethod  = 'cod';   // cod | momo | vnpay

    // ─── Format tiền VNĐ ──────────────────────────────────────────────────
    function formatMoney(n) {
        return n.toLocaleString('vi-VN') + ' VNĐ';
    }

    // ─── Cập nhật ô tổng tiền ─────────────────────────────────────────────
    function updateTotalDisplay() {
        var finalVal = SUBTOTAL - currentDiscountAmount + SHIPPING;
        if (finalVal < 0) finalVal = 0;
        document.getElementById('final-total-display').textContent = formatMoney(finalVal);

        // Dòng giảm giá trong summary
        var row = document.getElementById('discount-summary-row');
        var val = document.getElementById('discount-summary-val');
        if (currentDiscountAmount > 0) {
            row.style.display = 'flex';
            val.textContent   = '-' + formatMoney(currentDiscountAmount);
        } else {
            row.style.display = 'none';
        }
    }

    // ─── Phương thức thanh toán ───────────────────────────────────────────
    var PM_LABELS = { cod: 'Đặt hàng (COD)', momo: 'Thanh toán qua MoMo', vnpay: 'Thanh toán qua VNPay' };
    var PM_VALUES = { cod: '1', momo: '2', vnpay: '3' };

    function selectPayment(method, el) {
        currentPaymentMethod = method;
        document.querySelectorAll('.payment-option').forEach(function(e) {
            e.classList.remove('selected');
        });
        el.classList.add('selected');
        document.getElementById('payment-method-val').value = PM_VALUES[method];
        document.getElementById('btn-place-order-text').textContent = PM_LABELS[method];
    }

    // ─── Mã giảm giá ──────────────────────────────────────────────────────
    function applyDiscount() {
        var code = document.getElementById('discount-code-input').value.trim();
        if (!code) { showDiscountMsg('Vui lòng nhập mã giảm giá.', false); return; }

        fetch('${pageContext.request.contextPath}/apply-discount', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=apply&code=' + encodeURIComponent(code)
        })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.success) {
                    currentDiscountAmount = data.discountAmount;
                    currentDiscountId     = data.discountId;
                    document.getElementById('applied-discount-id').value     = data.discountId;
                    document.getElementById('applied-discount-amount').value = data.discountAmount;
                    updateTotalDisplay();
                    showDiscountMsg(data.message, true);
                    // Hiện row "đã áp dụng"
                    var row = document.getElementById('discount-applied-row');
                    row.style.display = 'flex';
                    document.getElementById('discount-applied-label').textContent =
                        'Đã áp mã: ' + code + ' (-' + formatMoney(data.discountAmount) + ')';
                } else {
                    showDiscountMsg(data.message, false);
                }
            })
            .catch(function() { showDiscountMsg('Lỗi kết nối. Vui lòng thử lại.', false); });
    }

    function removeDiscount() {
        fetch('${pageContext.request.contextPath}/apply-discount', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=remove'
        })
            .then(function(r) { return r.json(); })
            .then(function() {
                currentDiscountAmount = 0;
                currentDiscountId     = 0;
                document.getElementById('applied-discount-id').value     = '0';
                document.getElementById('applied-discount-amount').value = '0';
                document.getElementById('discount-code-input').value     = '';
                document.getElementById('discount-applied-row').style.display = 'none';
                document.getElementById('discount-msg').style.display = 'none';
                updateTotalDisplay();
            });
    }

    function showDiscountMsg(msg, success) {
        var el = document.getElementById('discount-msg');
        el.style.display     = 'block';
        el.style.background  = success ? '#f0fdf4' : '#fef2f2';
        el.style.border      = '1px solid ' + (success ? '#86efac' : '#fca5a5');
        el.style.color       = success ? '#15803d' : '#b91c1c';
        el.innerHTML = (success ? '✓ ' : '✗ ') + msg;
    }

    // ─── Địa chỉ đã lưu ───────────────────────────────────────────────────
    var ADDRESS_FIELDS = ['field-address', 'field-ward', 'field-district', 'field-province'];

    function setAddressFieldsLocked(locked) {
        ADDRESS_FIELDS.forEach(function(id) {
            var el = document.getElementById(id);
            if (!el) return;
            el.readOnly       = locked;
            el.style.background  = locked ? '#f5f0eb' : '#fff';
            el.style.color       = locked ? 'var(--muted)' : 'var(--brand)';
            el.style.cursor      = locked ? 'not-allowed' : '';
            el.style.borderColor = locked ? '#ddd' : '';
        });
        var badge = document.getElementById('addr-mode-badge');
        if (badge) badge.style.display = locked ? 'flex' : 'none';
    }

    function fillAddress(addrId) {
        var hiddenId = document.getElementById('selected-address-id');
        if (!addrId || !window.USER_ADDRESSES) {
            ADDRESS_FIELDS.forEach(function(id) {
                var el = document.getElementById(id); if (el) el.value = '';
            });
            if (hiddenId) hiddenId.value = '';
            setAddressFieldsLocked(false);
            return;
        }
        var id   = parseInt(addrId, 10);
        var addr = (window.USER_ADDRESSES || []).find(function(a) { return a.id === id; });
        if (!addr) return;
        setValue('field-address',  addr.addressDetail);
        setValue('field-ward',     addr.ward);
        setValue('field-district', addr.district);
        setValue('field-province', addr.province);
        if (hiddenId) hiddenId.value = id;
        setAddressFieldsLocked(true);
    }

    function setValue(fieldId, val) {
        var el = document.getElementById(fieldId); if (el) el.value = val || '';
    }

    // Auto-fill địa chỉ mặc định khi trang load
    (function () {
        var sel = document.getElementById('addr-select');
        if (sel && sel.value) { fillAddress(sel.value); }
        else { setAddressFieldsLocked(false); }
    })();

    // ─── Validation trước submit ───────────────────────────────────────────
    document.getElementById('checkout-form') &&
    document.getElementById('checkout-form').addEventListener('submit', function (e) {
        var fullname = document.getElementById('field-fullname');
        var phone    = document.getElementById('field-phone');
        var address  = document.getElementById('field-address');
        var province = document.getElementById('field-province');

        if (!fullname.value.trim() || !phone.value.trim()
            || !address.value.trim() || !province.value.trim()) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ các trường bắt buộc (*).');
            return;
        }
        var phoneVal = phone.value.trim().replace(/\s/g, '');
        if (!/^(0[3|5|7|8|9])[0-9]{8}$/.test(phoneVal)) {
            e.preventDefault();
            alert('Số điện thoại không hợp lệ. Vui lòng nhập số điện thoại Việt Nam 10 chữ số.');
        }
    });
</script>
</body>
</html>
