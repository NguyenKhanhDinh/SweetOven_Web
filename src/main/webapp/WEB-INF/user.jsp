<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang cá nhân | Sweet Oven Bakery</title>
    <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery"/>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: #F9F6F0;
            font-family: 'Segoe UI', sans-serif;
        }

        .profile-container {
            margin-top: 100px;
            margin-bottom: 50px;
            max-width: 1350px;
        }

        .card-box {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, .06);
            padding: 22px;
        }

        .main-grid {
            display: grid;
            grid-template-columns:360px 1fr;
            gap: 20px;
        }

        .bottom-grid {
            display: grid;
            grid-template-columns:1fr 1fr;
            gap: 20px;
            margin-top: 20px;
            min-width: 0;
        }

        .bottom-grid > .card-box {
            min-width: 0;
            overflow: hidden;
        }

        @media (max-width: 992px) {
            .main-grid, .bottom-grid {
                grid-template-columns:1fr;
            }
        }

        .avatar-box {
            width: 140px;
            margin: auto;
            position: relative;
        }

        .avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #d9a45e;
        }

        .avatar-upload {
            position: absolute;
            right: 0;
            bottom: 0;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #c97b21;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .avatar-upload:hover {
            background: #a96414;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .scroll-box {
            max-height: 380px;
            overflow-y: auto;
            padding-right: 4px;
        }

        .scroll-box::-webkit-scrollbar {
            width: 6px;
        }

        .scroll-box::-webkit-scrollbar-thumb {
            background: #d9a45e;
            border-radius: 20px;
        }

        .orders-header, .order-row {
            display: grid;
            grid-template-columns:1.2fr 1fr 1fr 1fr 60px;
            gap: 10px;
            align-items: center;
            padding: 12px;
        }

        .orders-header {
            background: #c97b21;
            color: #fff;
            border-radius: 10px;
            font-weight: 600;
        }

        .order-row {
            border-bottom: 1px solid #eee;
        }

        .card-box .favorite-grid {
            display: grid;
            grid-template-columns:repeat(4, 1fr);
            gap: 12px;
            overflow-x: auto;
            overflow-y: hidden;
            padding-bottom: 8px;
            white-space: nowrap;
        }

        .favorite-scroll-wrapper {
            overflow-x: auto;
            overflow-y: hidden;
            padding-bottom: 8px;
            min-width: 0;
        }

        .favorite-scroll-wrapper::-webkit-scrollbar {
            height: 6px;
        }

        .card-box .favorite-grid {
            display: flex;
            flex-wrap: nowrap;
            gap: 12px;
            width: max-content;
        }

        .favorite-item {
            border: 1px solid #eee;
            border-radius: 14px;
            padding: 10px;
            text-align: center;
            position: relative;
            width: 150px;
            min-width: 150px;
            max-width: 150px;
            flex-shrink: 0;
            box-sizing: border-box;
        }

        .favorite-item img {
            width: 100%;
            height: 110px;
            object-fit: cover;
            border-radius: 10px;
            display: block;
        }

        .fav-name {
            font-size: 13px;
            line-height: 1.3;
            height: 2.6em;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            margin-top: 6px;
        }

        .fav-price {
            display: block;
            margin-top: 4px;
            color: #c0392b;
            font-size: 14px;
        }

        .remove-fav {
            position: absolute;
            top: 5px;
            right: 5px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #dc3545;
            color: #fff;
            font-size: 14px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        /* ── VOUCHER LIST: scroll ngang ── */
        .voucher-list {
            display: flex;
            flex-direction: row;
            gap: 12px;
            padding: 8px 2px 12px;
            overflow-x: auto;
            scrollbar-width: thin;
            scrollbar-color: #d9a45e transparent;
        }

        .voucher-list::-webkit-scrollbar {
            height: 4px;
        }

        .voucher-list::-webkit-scrollbar-thumb {
            background: #d9a45e;
            border-radius: 20px;
        }

        /* Card wrapper — Shopee-style, width ~2/3 (280px thay vì full) */
        .voucher-card {
            background: #ffffff;
            display: flex;
            overflow: visible;
            border: 1px solid #e9ddd0;
            transition: box-shadow .18s, border-color .18s, transform .15s;
            position: relative;
            flex-shrink: 0;
            width: 550px;
        }

        .voucher-card:hover {
            box-shadow: 0 4px 22px rgba(139, 69, 19, .13);
            border-color: #ffffff;
            transform: translateY(-2px);
        }

        /* Shopee notch */
        .voucher-card::before,
        .voucher-card::after {
            content: '';
            position: absolute;
            left: 92px;
            width: 16px;
            height: 16px;
            background: #F9F6F0;
            border: 1px solid #e9ddd0;
            border-radius: 50%;
            z-index: 3;
        }

        .voucher-card::before {
            top: -8px;
        }

        .voucher-card::after {
            bottom: -8px;
        }

        /* LEFT: Logo panel */
        .vc-logo-panel {
            width: 100px;
            flex-shrink: 0;
            background: #3C2F27;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 12px 8px;
            gap: 4px;
            position: relative;
        }

        .vc-logo-panel::after {
            content: '';
            position: absolute;
            right: 0;
            top: 10px;
            bottom: 10px;
            border-right: 2px dashed rgba(255, 255, 255, .22);
        }

        .vc-logo-panel .logo-img {
            width: 38px;
            height: 38px;
            object-fit: contain;
            display: block;
        }

        .vc-logo-panel .logo-fallback-icon {
            font-size: 22px;
            color: #fff;
            opacity: .85;
            display: none;
        }

        .vc-logo-panel .logo-label {
            color: #fff;
            font-size: 9px;
            font-weight: 700;
            text-align: center;
            line-height: 1.3;
            opacity: .88;
        }

        /* Divider không cần nữa */
        .vc-divider {
            display: none;
        }

        /* Body */
        .vc-body {
            flex: 1;
            padding: 10px 12px 10px;
            min-width: 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .vc-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 6px;
            margin-bottom: 3px;
        }

        .vc-code-tag {
            font-size: 12px;
            font-weight: 700;
            color: #3C2F27;
            background: #FFF3E0;
            border: 1px dashed #D4A76A;
            padding: 1px 7px;
            font-family: monospace;
            letter-spacing: .5px;
            white-space: nowrap;
        }

        .vc-status-badge {
            font-size: 9px;
            font-weight: 700;
            padding: 2px 7px;
            white-space: nowrap;
        }

        .badge-valid {
            background: #dcfce7;
            color: #15803d;
        }

        .badge-expiring {
            background: #fef3c7;
            color: #b45309;
        }

        .vc-desc {
            font-size: 13px;
            font-weight: 700;
            color: #3C2F27;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin: 1px 0 4px;
            line-height: 1.3;
        }

        .vc-meta {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            font-size: 10.5px;
            color: #9ca3af;
        }

        .vc-meta span {
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .vc-meta b {
            color: #8B4513;
            font-weight: 600;
        }

        /* Footer: expire + action */
        .vc-footer-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 7px;
            padding-top: 6px;
            border-top: 1px dashed #e9ddd0;
        }

        .vc-expire {
            font-size: 10px;
            color: #aaa;
            display: flex;
            align-items: center;
            gap: 3px;
        }

        /* Action */
        .vc-action {
            display: none;
        }

        /* hidden, replaced by footer row */
        .btn-use-now {
            background: #fff;
            color: #16a34a;
            border: 1px solid #16a34a;
            padding: 4px 12px;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: background .15s;
            font-family: 'Quicksand', sans-serif;
        }

        .btn-use-now:hover {
            background: #f0fdf4;
            color: #16a34a;
        }

        /* Empty state */
        .vc-empty-state {
            text-align: center;
            padding: 30px 16px;
            color: #bbb;
        }

        .vc-empty-state i {
            font-size: 38px;
            margin-bottom: 10px;
            display: block;
        }

        .vc-empty-state p {
            font-size: 13px;
            margin: 0 0 10px;
        }

        .vc-empty-state a {
            font-size: 13px;
            color: #8B4513;
            font-weight: 600;
        }

        .address-item {
            border: 1px solid #eee;
            border-radius: 14px;
            padding: 14px;
            margin-bottom: 12px;
        }

        .icon-btn {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            border: 1px solid #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .icon-btn:hover {
            background: #c97b21;
            color: #fff;
        }

        .btn-main {
            background: linear-gradient(135deg, #e89b3c, #c46b12);
            border: none;
            color: #fff;
            font-weight: 600;
            border-radius: 10px;
            padding: 10px 18px;
            box-shadow: 0 6px 14px rgba(196, 107, 18, .25);
            transition: 0.25s;
        }

        .btn-main:hover {
            background: linear-gradient(135deg, #d98424, #a85a10);
            transform: translateY(-2px);
            color: #fff;
        }

        #addressModal select,
        #addressModal select option {
            color: #333 !important;
            background-color: #fff !important;
        }

        #addressModal .form-control {
            color: #333 !important;
        }

        #toast-container {
            position: fixed;
            top: 76px;
            right: 16px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 8px;
            pointer-events: none;
        }

        .toast-notify {
            width: 300px;
            padding: 10px 12px 10px 14px;
            border-radius: 10px;
            background: #fff;
            display: flex;
            align-items: center;
            gap: 9px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, .12);
            border-left: 4px solid #ccc;
            pointer-events: all;
            animation: slideInRight .28s cubic-bezier(.22, .68, 0, 1.2) forwards;
            position: relative;
            overflow: hidden;
        }

        .toast-notify.success {
            border-left-color: #2e9e5b;
        }

        .toast-notify.error {
            border-left-color: #e04040;
        }

        .toast-notify .toast-icon {
            font-size: 15px;
            flex-shrink: 0;
        }

        .toast-notify.success .toast-icon {
            color: #2e9e5b;
        }

        .toast-notify.error .toast-icon {
            color: #e04040;
        }

        .toast-notify .toast-msg {
            flex: 1;
            font-size: 13px;
            color: #333;
            line-height: 1.4;
            font-weight: 500;
        }

        .toast-notify .toast-close {
            background: none;
            border: none;
            color: #bbb;
            font-size: 14px;
            line-height: 1;
            cursor: pointer;
            flex-shrink: 0;
            padding: 2px 4px;
            border-radius: 4px;
            transition: color .15s;
        }

        .toast-notify .toast-close:hover {
            color: #555;
        }

        .toast-notify .toast-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 2px;
            border-radius: 0 0 0 10px;
            animation: toastProgress 3.5s linear forwards;
        }

        .toast-notify.success .toast-progress {
            background: #2e9e5b;
        }

        .toast-notify.error .toast-progress {
            background: #e04040;
        }
    </style>
</head>

<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="profile"/>
</jsp:include>

<div id="toast-container">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast-notify success" id="toast-success">
            <span class="toast-icon"><i class="fa fa-circle-check"></i></span>
            <span class="toast-msg">${sessionScope.successMsg}</span>
            <button class="toast-close" onclick="closeToast('toast-success')">&#x2715;</button>
            <div class="toast-progress"></div>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast-notify error" id="toast-error">
            <span class="toast-icon"><i class="fa fa-circle-xmark"></i></span>
            <span class="toast-msg">${sessionScope.errorMsg}</span>
            <button class="toast-close" onclick="closeToast('toast-error')">&#x2715;</button>
            <div class="toast-progress"></div>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>
</div>

<!-- TOP -->
<div class="main-grid">

    <!-- PROFILE -->
    <div class="card-box text-center">

        <div class="avatar-box">

            <form action="${pageContext.request.contextPath}/upload-avatar" method="post" enctype="multipart/form-data">
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <c:choose>
                            <c:when test="${user.avatar.startsWith('http')}">
                                <img src="${sessionScope.user.avatar}" class="avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}"
                                     class="avatar">
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>

                        <c:choose>
                            <c:when test="${user.gender == 0}">
                                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7imMwm5oKZ8t3qnhAptR3ZzpD-i2AuSiHoQ&s"
                                     class="avatar">
                            </c:when>
                            <c:when test="${user.gender == 1}">
                                <img src="https://anhdephd.vn/wp-content/uploads/2022/04/avatar-trang-1.jpg"
                                     class="avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s"
                                     class="avatar">
                            </c:otherwise>
                        </c:choose>

                    </c:otherwise>
                </c:choose>

                <label class="avatar-upload">
                    <i class="fa fa-camera"></i>
                    <input type="file" hidden name="avatar" onchange="this.form.submit()">
                </label>

            </form>
        </div>

        <h4 class="mt-3">${user.fullName}</h4>

        <div class="text-start mt-4">
            <p><b>Email:</b> ${user.email}</p>
            <p><b>SĐT:</b> ${user.phoneNumber}</p>

            <p>
                <b>Giới tính:</b>
                <c:choose>
                    <c:when test="${user.gender == 0}">Nam</c:when>
                    <c:when test="${user.gender == 1}">Nữ</c:when>
                    <c:otherwise>Khác</c:otherwise>
                </c:choose>
            </p>
        </div>

        <button class="btn btn-main w-100"
                data-bs-toggle="modal"
                data-bs-target="#editModal">
            Chỉnh sửa thông tin
        </button>

    </div>

    <!-- ORDER -->
    <div class="card-box">

        <div class="section-title">Đơn hàng của tôi</div>

        <div class="orders-header">
            <div>Mã đơn</div>
            <div>Ngày</div>
            <div>Tổng tiền</div>
            <div>Trạng thái</div>
            <div></div>
        </div>

        <div class="scroll-box">

            <c:choose>

                <c:when test="${empty orders}">
                    <div class="text-center text-muted p-4">
                        <i class="fa fa-box-open fa-2x mb-2"></i>
                        <div>Chưa có đơn hàng</div>
                    </div>
                </c:when>

                <c:otherwise>
                    <c:forEach var="o" items="${orders}">
                        <div class="order-row">

                            <div>${o.orderCode}</div>

                            <div>${o.orderDateFormatted}</div>
                            <div>${o.totalAmountFormatted}</div>

                            <div>
                                <c:choose>
                                    <c:when test="${o.orderStatus == 1}">
                                        <span class="badge bg-warning">Chờ xác nhận</span>
                                    </c:when>

                                    <c:when test="${o.orderStatus == 2}">
                                        <span class="badge bg-info">Đang giao</span>
                                    </c:when>

                                    <c:when test="${o.orderStatus == 3}">
                                        <span class="badge bg-success">Hoàn thành</span>
                                    </c:when>

                                    <c:when test="${o.orderStatus == 4}">
                                        <span class="badge bg-danger">Đã hủy</span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge bg-secondary">Khác</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div>
                                <a href="order-detail?id=${o.id}">
                                    <i class="fa fa-eye"></i>
                                </a>
                            </div>

                        </div>
                    </c:forEach>
                </c:otherwise>

            </c:choose>

        </div>
    </div>
</div>

<!-- BOTTOM -->
<div class="bottom-grid">

    <!-- FAVORITE -->
    <div class="card-box">
        <div class="section-title">Yêu thích</div>

        <div class="favorite-scroll-wrapper">
            <div class="favorite-grid">
                <c:forEach var="p" items="${favoriteProducts}">
                    <div class="favorite-item">
                        <form action="remove-favorite" method="post">
                            <input type="hidden" name="id" value="${p.id}">
                            <div class="remove-fav" onclick="this.closest('form').submit()">×</div>
                        </form>
                        <a href="${pageContext.request.contextPath}/product?id=${p.id}"
                           style="text-decoration:none;color:inherit;">
                            <img src="${p.image}" alt="${p.name}"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/img/no-image.png'">
                            <div class="fav-name">${p.name}</div>
                            <b class="fav-price">
                                <fmt:formatNumber value="${p.displayPrice}" type="number" groupingUsed="true"/> VNĐ
                            </b>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="card-box">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div class="section-title m-0">
                <i class="fa fa-ticket-alt me-2" style="color:#e67a2a;"></i>Voucher của tôi
            </div>
            <a href="${pageContext.request.contextPath}/vouchers"
               style="font-size:13px;color:#8B4513;font-weight:600;text-decoration:none;">
                Thêm voucher <i class="fa fa-arrow-right ms-1" style="font-size:11px;"></i>
            </a>
        </div>
        <div style="overflow:visible;">
            <c:choose>
                <c:when test="${empty vouchers}">
                    <div class="vc-empty-state">
                        <i class="fa fa-ticket-alt"></i>
                        <p>Bạn chưa lưu voucher nào.</p>
                        <a href="${pageContext.request.contextPath}/vouchers">Xem kho voucher →</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="voucher-list">
                        <c:forEach var="v" items="${vouchers}">
                            <c:if test="${!v.used && v.valid}">
                                <div class="voucher-card">
                                        <%-- LEFT: Logo panel (đồng nhất với trang /vouchers) --%>
                                    <div class="vc-logo-panel">
                                        <img src="${pageContext.request.contextPath}/assets/picture/logo-voucher.png"
                                             alt="Sweet Oven" class="logo-img"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                        <i class="fas fa-bread-slice logo-fallback-icon"></i>
                                        <div class="logo-label">Sweet Oven<br>Bakery</div>
                                    </div>
                                    <div class="vc-divider"></div>
                                        <%-- Body --%>
                                    <div class="vc-body">
                                        <div>
                                            <div class="vc-header">
                                                <span class="vc-code-tag">${v.code}</span>
                                                <span class="vc-status-badge badge-valid">
                                                    <i class="fa fa-check me-1"></i>Còn hạn
                                                </span>
                                            </div>
                                            <div class="vc-desc">${v.description}</div>
                                            <div class="vc-meta">
                                                <span><i class="fa fa-receipt"></i>Từ <b>${v.displayMinOrder}</b></span>
                                                <span><i
                                                        class="fa fa-clock"></i>HSD: <b>${v.formattedEndDate}</b></span>
                                            </div>
                                        </div>
                                        <div class="vc-footer-row">
                                            <span class="vc-expire"><i class="fa fa-clock"></i>&nbsp;HSD: <b
                                                    style="color:#8B4513;">${v.formattedEndDate}</b></span>
                                            <button class="btn-use-now" onclick="useVoucher('${v.code}')">
                                                <i class="fa fa-cart-shopping"></i>Dùng ngay
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- ADDRESS -->
    <div class="card-box" style="grid-column:span 2;">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="section-title m-0">Địa chỉ giao hàng</div>
            <button class="btn btn-main btn-sm"
                    data-bs-toggle="modal"
                    data-bs-target="#addressModal"
                    onclick="openAddModal()">
                + Thêm địa chỉ
            </button>
        </div>

        <div class="scroll-box">
            <c:choose>
                <c:when test="${empty addresses}">
                    <div class="text-center p-4 text-muted">
                        <i class="fa fa-map-location-dot fa-2x mb-2"></i>
                        <div>Bạn chưa có địa chỉ giao hàng nào.</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="a" items="${addresses}">
                        <div class="address-item ${a.isDefault ? 'is-default' : ''}">
                            <div class="d-flex justify-content-between align-items-center">
                                <b>${a.addressDetail}</b>
                                <c:if test="${a.isDefault}">
                                    <span class="badge bg-success">Mặc định</span>
                                </c:if>
                            </div>
                            <div class="text-muted">
                                    ${a.ward}, ${a.district}, ${a.province}
                            </div>
                            <div class="d-flex gap-2 mt-2 align-items-center">
                                <div class="icon-btn" title="Sửa"
                                     onclick="openEditModal(${a.id},'${a.addressDetail}','${a.province}','${a.district}','${a.ward}')">
                                    <i class="fa fa-pen"></i>
                                </div>
                                <div class="icon-btn text-danger" title="Xóa" style="cursor:pointer;"
                                     onclick="deleteAddress(${a.id})">
                                    <i class="fa fa-trash"></i>
                                </div>
                                <c:if test="${!a.isDefault}">
                                    <button class="btn btn-sm btn-outline-warning" title="Đặt mặc định"
                                            style="font-size:12px; padding:4px 10px; border-radius:20px;"
                                            onclick="setDefaultAddress(${a.id})">
                                        Đặt mặc định
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<!-- ACTION -->
<div class="text-center mt-4">

    <button class="btn btn-main"
            data-bs-toggle="modal"
            data-bs-target="#passwordModal">
        Đổi mật khẩu
    </button>

    <form action="logout" method="post" style="display:inline;">
        <button type="submit" class="btn btn-danger ms-2">
            Đăng xuất
        </button>
    </form>

</div>

</div>

<!-- EDIT PROFILE -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form action="profile" method="post" class="modal-content">

            <div class="modal-header">
                <h5>Chỉnh sửa thông tin</h5>
            </div>

            <div class="modal-body">

                <input class="form-control mb-2" name="fullName" value="${user.fullName}">
                <input class="form-control mb-2" name="email" value="${user.email}">
                <input class="form-control mb-2" name="phoneNumber" value="${user.phoneNumber}">

                <select class="form-control" name="gender">
                    <option value="0" ${user.gender == 0 ? "selected" : ""}>Nam</option>
                    <option value="1" ${user.gender == 1 ? "selected" : ""}>Nữ</option>
                    <option value="2" ${user.gender == 2 ? "selected" : ""}>Khác</option>
                </select>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-main">Lưu</button>
            </div>

        </form>
    </div>
</div>

</div>
<div class="modal fade" id="addressModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="address" method="post" class="modal-content" onsubmit="handleAddressSubmit(event)">
            <input type="hidden" name="action" id="addressAction" value="add">
            <input type="hidden" name="id" id="addressId" value="">

            <div class="modal-header">
                <h5 id="addressModalTitle">Thêm địa chỉ giao hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input class="form-control mb-2" name="addressDetail" id="addressDetail"
                       placeholder="Số nhà, tên đường" required>
                <select class="form-control mb-2" id="province" name="province" required>
                    <option value="">Chọn Tỉnh/Thành phố</option>
                </select>
                <select class="form-control mb-2" id="district" name="district" required>
                    <option value="">Chọn Quận/Huyện</option>
                </select>
                <select class="form-control" id="ward" name="ward" required>
                    <option value="">Chọn Phường/Xã</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-main" id="addressSubmitBtn">Lưu địa chỉ</button>
            </div>
        </form>
    </div>
</div>


<!-- PASSWORD -->
<div class="modal fade" id="passwordModal">
    <div class="modal-dialog">
        <form action="change-password" method="post" class="modal-content">

            <div class="modal-header">
                <h5>Đổi mật khẩu</h5>
            </div>

            <div class="modal-body">

                <input type="password" class="form-control mb-2" name="oldPassword" placeholder="Mật khẩu cũ">
                <input type="password" class="form-control mb-2" name="newPassword" placeholder="Mật khẩu mới">
                <input type="password" class="form-control" name="confirmPassword" placeholder="Nhập lại mật khẩu">

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-main">Xác nhận</button>
            </div>

        </form>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");

    const CTX = '${pageContext.request.contextPath}';

    // ── 1. Load Tỉnh/Thành từ GHN qua backend proxy ──────────────────────────────
    function loadProvinces() {
        fetch(CTX + '/ghn-location?type=province')
            .then(r => {
                if (!r.ok) throw new Error('HTTP ' + r.status);
                return r.json();
            })
            .then(data => {
                if (!Array.isArray(data)) throw new Error('Dữ liệu không hợp lệ');
                provinceSelect.options.length = 0;
                provinceSelect.options.add(new Option("Chọn tỉnh / thành", ""));
                data.forEach(p => {
                    let opt = new Option(p.ProvinceName, p.ProvinceName);
                    opt.setAttribute("data-id", p.ProvinceID);
                    provinceSelect.options.add(opt);
                });
            })
            .catch(err => {
                console.error('[GHN] Không load được danh sách tỉnh:', err);
                provinceSelect.options.length = 0;
                provinceSelect.options.add(new Option("⚠ Không tải được, thử lại", ""));
            });
    }
    loadProvinces();
    document.getElementById('addressModal').addEventListener('show.bs.modal', function () {
        if (provinceSelect.options.length <= 1) {
            loadProvinces();
        }
    });

    // ── 2. Khi chọn Tỉnh → Load Huyện ────────────────────────────────────────────
    provinceSelect.onchange = function () {
        const opt = this.options[this.selectedIndex];
        const pId = opt ? opt.getAttribute("data-id") : null;
        districtSelect.options.length = 0;
        districtSelect.options.add(new Option("Chọn quận / huyện", ""));
        wardSelect.options.length = 0;
        wardSelect.options.add(new Option("Chọn phường / xã", ""));
        if (!pId) return;
        fetch(CTX + '/ghn-location?type=district&province_id=' + pId)
            .then(r => r.json())
            .then(data => {
                data.forEach(d => {
                    let opt = new Option(d.DistrictName, d.DistrictName);
                    opt.setAttribute("data-id", d.DistrictID);
                    districtSelect.options.add(opt);
                });
            })
            .catch(() => console.error('[GHN] Không load được danh sách huyện'));
    };

    // ── 3. Khi chọn Huyện → Load Xã ──────────────────────────────────────────────
    districtSelect.onchange = function () {
        const opt = this.options[this.selectedIndex];
        const dId = opt ? opt.getAttribute("data-id") : null;
        wardSelect.options.length = 0;
        wardSelect.options.add(new Option("Chọn phường / xã", ""));
        if (!dId) return;
        fetch(CTX + '/ghn-location?type=ward&district_id=' + dId)
            .then(r => r.json())
            .then(data => {
                data.forEach(w => {
                    wardSelect.options.add(new Option(w.WardName, w.WardName));
                });
            })
            .catch(() => console.error('[GHN] Không load được danh sách xã'));
    };

    // ── 4. Mở modal Thêm địa chỉ ─────────────────────────────────────────────────
    function openAddModal() {
        document.getElementById("addressModalTitle").textContent = "Thêm địa chỉ giao hàng";
        document.getElementById("addressAction").value = "add";
        document.getElementById("addressId").value = "";
        document.getElementById("addressDetail").value = "";
        document.getElementById("addressSubmitBtn").textContent = "Lưu địa chỉ";
        provinceSelect.value = "";
        districtSelect.options.length = 0;
        districtSelect.add(new Option("Chọn quận / huyện", ""));
        wardSelect.options.length = 0;
        wardSelect.add(new Option("Chọn phường / xã", ""));
    }

    // ── 5. Mở modal Sửa địa chỉ ─────────────────────────────────────────────────
    function openEditModal(id, detail, province, district, ward) {
        document.getElementById("addressModalTitle").textContent = "Chỉnh sửa địa chỉ";
        document.getElementById("addressAction").value = "edit";
        document.getElementById("addressId").value = id;
        document.getElementById("addressDetail").value = detail;
        document.getElementById("addressSubmitBtn").textContent = "Cập nhật";
        new bootstrap.Modal(document.getElementById("addressModal")).show();

        function trySetProvince() {
            for (let i = 0; i < provinceSelect.options.length; i++) {
                if (provinceSelect.options[i].value === province) {
                    provinceSelect.selectedIndex = i;
                    break;
                }
            }
            const pOpt = provinceSelect.options[provinceSelect.selectedIndex];
            const pId = pOpt ? pOpt.getAttribute("data-id") : null;
            if (!pId) {
                setTimeout(trySetProvince, 400);
                return;
            }

            fetch(CTX + '/ghn-location?type=district&province_id=' + pId)
                .then(r => r.json())
                .then(data => {
                    districtSelect.options.length = 0;
                    districtSelect.add(new Option("Chọn quận / huyện", ""));
                    data.forEach(d => {
                        let opt = new Option(d.DistrictName, d.DistrictName);
                        opt.setAttribute("data-id", d.DistrictID);
                        districtSelect.add(opt);
                    });
                    for (let i = 0; i < districtSelect.options.length; i++) {
                        if (districtSelect.options[i].value === district) {
                            districtSelect.selectedIndex = i;
                            break;
                        }
                    }
                    const dOpt = districtSelect.options[districtSelect.selectedIndex];
                    const dId = dOpt ? dOpt.getAttribute("data-id") : null;
                    if (!dId) return;

                    fetch(CTX + '/ghn-location?type=ward&district_id=' + dId)
                        .then(r => r.json())
                        .then(data2 => {
                            wardSelect.options.length = 0;
                            wardSelect.add(new Option("Chọn phường / xã", ""));
                            data2.forEach(w => wardSelect.add(new Option(w.WardName, w.WardName)));
                            for (let i = 0; i < wardSelect.options.length; i++) {
                                if (wardSelect.options[i].value === ward) {
                                    wardSelect.selectedIndex = i;
                                    break;
                                }
                            }
                        });
                });
        }

        if (provinceSelect.options.length > 1) trySetProvince();
        else setTimeout(trySetProvince, 600);
    }

    function useVoucher(code) {
        sessionStorage.setItem('pendingVoucherCode', code);
        window.location.href = '${pageContext.request.contextPath}/my-cart';
    }

    function closeToast(id) {
        const el = document.getElementById(id);
        if (!el) return;
        el.style.animation = 'slideOutRight .3s ease forwards';
        setTimeout(() => el.remove(), 300);
    }

    document.addEventListener('DOMContentLoaded', function () {
        ['toast-success', 'toast-error'].forEach(function (id) {
            const el = document.getElementById(id);
            if (el) setTimeout(() => closeToast(id), 3500);
        });
    });

    // ── Hiển thị toast — dùng textContent tránh conflict JSP EL ──────────────
    function showToast(message, type) {
        const container = document.getElementById('toast-container');
        if (!container) return;

        const id = 'toast-dyn-' + Date.now();
        const wrap = document.createElement('div');
        wrap.className = 'toast-notify ' + type;
        wrap.id = id;

        const icon = document.createElement('span');
        icon.className = 'toast-icon';
        const i = document.createElement('i');
        i.className = 'fa ' + (type === 'success' ? 'fa-circle-check' : 'fa-circle-xmark');
        icon.appendChild(i);

        const msg = document.createElement('span');
        msg.className = 'toast-msg';
        msg.textContent = message; // textContent tránh bị parse sai

        const closeBtn = document.createElement('button');
        closeBtn.className = 'toast-close';
        closeBtn.innerHTML = '&#x2715;';
        closeBtn.onclick = function () {
            closeToast(id);
        };

        const progress = document.createElement('div');
        progress.className = 'toast-progress';

        wrap.appendChild(icon);
        wrap.appendChild(msg);
        wrap.appendChild(closeBtn);
        wrap.appendChild(progress);
        container.appendChild(wrap);

        setTimeout(() => closeToast(id), 3500);
    }

    // ── AJAX submit form địa chỉ (add / edit) — không reload trang ───────────
    function handleAddressSubmit(e) {
        e.preventDefault();
        const form = e.target;
        const btn = document.getElementById('addressSubmitBtn');
        const origTxt = btn.textContent;
        btn.disabled = true;
        btn.textContent = 'Đang lưu...';

        fetch('${pageContext.request.contextPath}/address', {
            method: 'POST',
            body: new URLSearchParams(new FormData(form))
        })
            .then(r => r.json())
            .then(res => {
                bootstrap.Modal.getInstance(document.getElementById('addressModal')).hide();
                showToast(res.message, res.success ? 'success' : 'error');
                if (res.success) setTimeout(() => location.reload(), 900);
            })
            .catch(() => showToast('Lỗi kết nối, vui lòng thử lại!', 'error'))
            .finally(() => {
                btn.disabled = false;
                btn.textContent = origTxt;
            });
    }

    // ── AJAX xóa địa chỉ ──────────────────────────────────────────────────────
    function deleteAddress(id) {
        if (!confirm('Bạn có chắc muốn xóa địa chỉ này không?')) return;
        fetch('${pageContext.request.contextPath}/address', {
            method: 'POST',
            body: new URLSearchParams({action: 'delete', id: id})
        })
            .then(r => r.json())
            .then(res => {
                showToast(res.message, res.success ? 'success' : 'error');
                if (res.success) setTimeout(() => location.reload(), 700);
            })
            .catch(() => showToast('Lỗi kết nối!', 'error'));
    }

    // ── AJAX đặt mặc định ─────────────────────────────────────────────────────
    function setDefaultAddress(id) {
        fetch('${pageContext.request.contextPath}/address', {
            method: 'POST',
            body: new URLSearchParams({action: 'setDefault', id: id})
        })
            .then(r => r.json())
            .then(res => {
                showToast(res.message, res.success ? 'success' : 'error');
                if (res.success) setTimeout(() => location.reload(), 700);
            })
            .catch(() => showToast('Lỗi kết nối!', 'error'));
    }
</script>

</body>
</html>