<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang cá nhân | Sweet Oven Bakery</title>
    <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body{
            background:#F9F6F0;
            font-family:'Segoe UI',sans-serif;
        }

        .profile-container{
            margin-top:100px;
            margin-bottom:50px;
            max-width:1350px;
        }

        .card-box{
            background:#fff;
            border-radius:20px;
            box-shadow:0 8px 25px rgba(0,0,0,.06);
            padding:22px;
        }

        .main-grid{
            display:grid;
            grid-template-columns:360px 1fr;
            gap:20px;
        }

        .bottom-grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:20px;
            margin-top:20px;
            min-width: 0;
        }
        .bottom-grid > .card-box {
            min-width: 0;
            overflow: hidden;
        }

        @media(max-width:992px){
            .main-grid,.bottom-grid{
                grid-template-columns:1fr;
            }
        }

        .avatar-box{
            width:140px;
            margin:auto;
            position:relative;
        }

        .avatar{
            width:140px;
            height:140px;
            border-radius:50%;
            object-fit:cover;
            border:4px solid #d9a45e;
        }

        .avatar-upload{
            position:absolute;
            right:0;
            bottom:0;
            width:38px;
            height:38px;
            border-radius:50%;
            background:#c97b21;
            color:#fff;
            display:flex;
            align-items:center;
            justify-content:center;
            cursor:pointer;
        }

        .avatar-upload:hover{
            background:#a96414;
        }

        .section-title{
            font-size:20px;
            font-weight:700;
            margin-bottom:15px;
        }

        .scroll-box{
            max-height:380px;
            overflow-y:auto;
            padding-right:4px;
        }

        .scroll-box::-webkit-scrollbar{
            width:6px;
        }

        .scroll-box::-webkit-scrollbar-thumb{
            background:#d9a45e;
            border-radius:20px;
        }

        .orders-header,.order-row{
            display:grid;
            grid-template-columns:1.2fr 1fr 1fr 1fr 60px;
            gap:10px;
            align-items:center;
            padding:12px;
        }

        .orders-header{
            background:#c97b21;
            color:#fff;
            border-radius:10px;
            font-weight:600;
        }

        .order-row{
            border-bottom:1px solid #eee;
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

        .remove-fav{
            position:absolute;
            top:5px;
            right:5px;
            width:24px;
            height:24px;
            border-radius:50%;
            background:#dc3545;
            color:#fff;
            font-size:14px;
            display:flex;
            justify-content:center;
            align-items:center;
            cursor:pointer;
        }

        .voucher-card {
            display: flex;
            align-items: center;
            gap: 0;
            border: 1.5px dashed #d9a45e;
            border-radius: 14px;
            margin-bottom: 12px;
            overflow: hidden;
            background: #fffaf3;
            transition: box-shadow .2s, transform .2s;
        }
        .voucher-card:hover:not(.voucher-disabled) {
            box-shadow: 0 6px 18px rgba(196,107,18,.18);
            transform: translateY(-2px);
        }
        .voucher-disabled { opacity: .55; filter: grayscale(.4); }
        .voucher-left {
            flex-shrink: 0; width: 58px;
            background: linear-gradient(135deg,#e89b3c,#c46b12);
            align-self: stretch; display: flex;
            align-items: center; justify-content: center;
        }
        .voucher-icon { color: #fff; font-size: 22px; writing-mode: vertical-rl; }
        .voucher-body { flex: 1; padding: 12px 14px; min-width: 0; }
        .voucher-code {
            font-size: 15px; font-weight: 700; color: #c46b12;
            letter-spacing: .5px; font-family: monospace;
            background: #fff3e0; padding: 2px 8px;
            border-radius: 6px; border: 1px solid #e89b3c;
        }
        .voucher-desc { font-size: 13px; color: #555; margin: 4px 0 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .voucher-meta { display: flex; flex-wrap: wrap; gap: 8px; font-size: 12px; color: #777; }
        .voucher-action { flex-shrink: 0; padding: 0 14px; }
        .btn-use-voucher { white-space: nowrap; font-size: 13px; padding: 7px 12px; }
        .address-item{
            border:1px solid #eee;
            border-radius:14px;
            padding:14px;
            margin-bottom:12px;
        }

        .icon-btn{
            width:34px;
            height:34px;
            border-radius:50%;
            border:1px solid #ddd;
            display:flex;
            align-items:center;
            justify-content:center;
            cursor:pointer;
        }

        .icon-btn:hover{
            background:#c97b21;
            color:#fff;
        }

        .btn-main{
            background: linear-gradient(135deg,#e89b3c,#c46b12);
            border:none;
            color:#fff;
            font-weight:600;
            border-radius:10px;
            padding:10px 18px;
            box-shadow:0 6px 14px rgba(196,107,18,.25);
            transition:0.25s;
        }

        .btn-main:hover{
            background: linear-gradient(135deg,#d98424,#a85a10);
            transform:translateY(-2px);
            color:#fff;
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
            box-shadow: 0 4px 16px rgba(0,0,0,.12);
            border-left: 4px solid #ccc;
            pointer-events: all;
            animation: slideInRight .28s cubic-bezier(.22,.68,0,1.2) forwards;
            position: relative;
            overflow: hidden;
        }

        .toast-notify.success { border-left-color: #2e9e5b; }
        .toast-notify.error   { border-left-color: #e04040; }

        .toast-notify .toast-icon {
            font-size: 15px;
            flex-shrink: 0;
        }
        .toast-notify.success .toast-icon { color: #2e9e5b; }
        .toast-notify.error   .toast-icon { color: #e04040; }

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
        .toast-notify .toast-close:hover { color: #555; }

        .toast-notify .toast-progress {
            position: absolute;
            bottom: 0; left: 0;
            height: 2px;
            border-radius: 0 0 0 10px;
            animation: toastProgress 3.5s linear forwards;
        }
        .toast-notify.success .toast-progress { background: #2e9e5b; }
        .toast-notify.error   .toast-progress { background: #e04040; }
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
                                    <img src="${pageContext.request.contextPath}/${sessionScope.user.avatar}" class="avatar">
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
            <div class="section-title">Voucher của tôi</div>
            <div class="scroll-box">
                <c:choose>
                    <c:when test="${empty vouchers}">
                        <div class="text-center p-4 text-muted">
                            <i class="fa fa-ticket fa-2x mb-2"></i>
                            <div>Bạn chưa lưu voucher nào.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="v" items="${vouchers}">
                            <c:if test="${!v.used && v.valid}">
                                <div class="voucher-card">
                                    <div class="voucher-left">
                                        <div class="voucher-icon"><i class="fa ${v.iconClass}"></i></div>
                                    </div>
                                    <div class="voucher-body">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="voucher-code">${v.code}</span>
                                            <span class="badge ${v.statusClass}">${v.statusLable}</span>
                                        </div>
                                        <div class="voucher-desc">${v.description}</div>
                                        <div class="voucher-meta">
                                            <span><i class="fa fa-tag me-1"></i>Giảm <b>${v.displayValue}</b></span>
                                            <span><i class="fa fa-receipt me-1"></i>Đơn tối thiểu <b>${v.displayMinOrder}</b></span>
                                            <span><i class="fa fa-clock me-1"></i>HSD: <b>${v.formattedEndDate}</b></span>
                                        </div>
                                    </div>
                                    <div class="voucher-action">
                                        <button class="btn btn-main btn-sm btn-use-voucher"
                                                data-code="${v.code}"
                                                onclick="useVoucher('${v.code}')">
                                            <i class="fa fa-cart-shopping me-1"></i>Sử dụng
                                        </button>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
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
                                    <div class="icon-btn" title="Sửa" onclick="openEditModal(${a.id},'${a.addressDetail}','${a.province}','${a.district}','${a.ward}')">
                                        <i class="fa fa-pen"></i>
                                    </div>
                                    <form action="address" method="post" style="margin:0;" onsubmit="return confirm('Bạn có chắc muốn xóa địa chỉ này không?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${a.id}">
                                        <button type="submit" class="icon-btn border-0 text-danger" title="Xóa"
                                                style="background:transparent;">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </form>
                                    <c:if test="${!a.isDefault}">
                                        <form action="address" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="setDefault">
                                            <input type="hidden" name="id" value="${a.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-warning" title="Đặt mặc định"
                                                    style="font-size:12px; padding:4px 10px; border-radius:20px;">
                                                Đặt mặc định
                                            </button>
                                        </form>
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
        <form action="address" method="post" class="modal-content">
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

    // 1. Load Tỉnh/Thành
    fetch("https://provinces.open-api.vn/api/p/")
        .then(res => res.json())
        .then(data => {
            provinceSelect.options.length = 0;
            provinceSelect.options.add(new Option("Chọn tỉnh / thành", ""));
            data.forEach(p => {
                let option = new Option(p.name, p.name);
                option.setAttribute("data-id", p.code);
                provinceSelect.options.add(option);
            });
        });

    // 2. Khi chọn Tỉnh -> Load Huyện
    provinceSelect.onchange = function() {
        const selectedOption = this.options[this.selectedIndex];
        const pCode = selectedOption.getAttribute("data-id");

        districtSelect.options.length = 0;
        districtSelect.options.add(new Option("Chọn quận / huyện", ""));
        wardSelect.options.length = 0;
        wardSelect.options.add(new Option("Chọn phường / xã", ""));

        if (!pCode) return;

        fetch("https://provinces.open-api.vn/api/p/" + pCode + "?depth=2")
            .then(res => res.json())
            .then(data => {
                data.districts.forEach(d => {
                    let option = new Option(d.name, d.name);
                    option.setAttribute("data-id", d.code);
                    districtSelect.options.add(option);
                });
            });
    }

    // 3. Khi chọn Huyện -> Load Xã
    districtSelect.onchange = function() {
        const selectedOption = this.options[this.selectedIndex];
        const dCode = selectedOption.getAttribute("data-id");

        wardSelect.options.length = 0;
        wardSelect.options.add(new Option("Chọn phường / xã", ""));

        if (!dCode) return;

        fetch("https://provinces.open-api.vn/api/d/" + dCode + "?depth=2")
            .then(res => res.json())
            .then(data => {
                data.wards.forEach(w => {
                    wardSelect.options.add(new Option(w.name, w.name));
                });
            });
    }

    function openAddModal() {
        document.getElementById("addressModalTitle").textContent = "Thêm địa chỉ giao hàng";
        document.getElementById("addressAction").value = "add";
        document.getElementById("addressId").value = "";
        document.getElementById("addressDetail").value = "";
        document.getElementById("addressSubmitBtn").textContent = "Lưu địa chỉ";

        // Reset dropdowns
        provinceSelect.value = "";
        districtSelect.options.length = 0;
        districtSelect.add(new Option("Chọn quận / huyện", ""));
        wardSelect.options.length = 0;
        wardSelect.add(new Option("Chọn phường / xã", ""));
    }
    function openEditModal(id, detail, province, district, ward) {
        document.getElementById("addressModalTitle").textContent = "Chỉnh sửa địa chỉ";
        document.getElementById("addressAction").value = "edit";
        document.getElementById("addressId").value = id;
        document.getElementById("addressDetail").value = detail;
        document.getElementById("addressSubmitBtn").textContent = "Cập nhật";

        // Mở modal
        new bootstrap.Modal(document.getElementById("addressModal")).show();

        // Chờ provinces load xong rồi set giá trị
        function setProvinceAndLoadDistricts() {
            // Set province
            for (let i = 0; i < provinceSelect.options.length; i++) {
                if (provinceSelect.options[i].value === province) {
                    provinceSelect.selectedIndex = i;
                    break;
                }
            }
            const pOpt = provinceSelect.options[provinceSelect.selectedIndex];
            const pCode = pOpt ? pOpt.getAttribute("data-id") : null;
            if (!pCode) {
                // Thử lại sau 500ms nếu tỉnh chưa load xong
                setTimeout(setProvinceAndLoadDistricts, 500);
                return;
            }

            // Load huyện rồi set
            fetch("https://provinces.open-api.vn/api/p/" + pCode + "?depth=2")
                .then(res => res.json())
                .then(data => {
                    districtSelect.options.length = 0;
                    districtSelect.add(new Option("Chọn quận / huyện", ""));
                    data.districts.forEach(d => {
                        let opt = new Option(d.name, d.name);
                        opt.setAttribute("data-id", d.code);
                        districtSelect.add(opt);
                    });
                    // Set district
                    for (let i = 0; i < districtSelect.options.length; i++) {
                        if (districtSelect.options[i].value === district) {
                            districtSelect.selectedIndex = i;
                            break;
                        }
                    }
                    const dOpt = districtSelect.options[districtSelect.selectedIndex];
                    const dCode = dOpt ? dOpt.getAttribute("data-id") : null;
                    if (!dCode) return;

                    // Load xã rồi set
                    fetch("https://provinces.open-api.vn/api/d/" + dCode + "?depth=2")
                        .then(res => res.json())
                        .then(data2 => {
                            wardSelect.options.length = 0;
                            wardSelect.add(new Option("Chọn phường / xã", ""));
                            data2.wards.forEach(w => wardSelect.add(new Option(w.name, w.name)));
                            // Set ward
                            for (let i = 0; i < wardSelect.options.length; i++) {
                                if (wardSelect.options[i].value === ward) {
                                    wardSelect.selectedIndex = i;
                                    break;
                                }
                            }
                        });
                });
        }

        if (provinceSelect.options.length > 1) {
            setProvinceAndLoadDistricts();
        } else {
            setTimeout(setProvinceAndLoadDistricts, 800);
        }
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
            if (el) {
                setTimeout(() => closeToast(id), 3500);
            }
        });
    });
</script>
</body>
</html>