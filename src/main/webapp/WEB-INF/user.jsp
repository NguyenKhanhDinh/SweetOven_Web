<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Profile</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body { background: #f5f6fa; font-family: 'Segoe UI'; }
        .container { margin-top: 90px; max-width: 1200px; }

        .card {
            border-radius: 18px;
            border: none;
            box-shadow: 0 8px 25px rgba(0,0,0,0.06);
        }

        .main-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 20px; }

        .scroll-box { max-height: 300px; overflow-y: auto; }
        .scroll-box::-webkit-scrollbar { width: 6px; }
        .scroll-box::-webkit-scrollbar-thumb { background: #e0b680; border-radius: 10px; }

        .orders-header, .order-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr 60px;
            padding: 10px;
            align-items: center;
        }

        .orders-header {
            background: #e0b680;
            color: white;
            border-radius: 10px 10px 0 0;
        }

        .favorite-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px,1fr));
            gap: 10px;
        }

        .favorite-item {
            background: #fff;
            padding: 10px;
            border-radius: 10px;
            position: relative;
            text-align: center;
        }

        .remove-fav {
            position: absolute;
            top: 5px;
            right: 5px;
            background: red;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .address-item {
            border: 1px solid #eee;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .address-actions {
            display: flex;
            gap: 10px;
            margin-top: 5px;
        }

        .icon-btn {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #eee;
            cursor: pointer;
        }

        .icon-btn:hover {
            background: #e0b680;
            color: white;
        }

        .avatar-box { position: relative; width: 120px; margin: auto; }
        .avatar {
            width: 120px; height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e0b680;
        }
        .avatar-upload {
            position: absolute;
            bottom: 0; right: 0;
            background: #e0b680;
            border-radius: 50%;
            padding: 6px;
            cursor: pointer;
        }

        .btn-warning { background: #e0b680; border: none; }
        .text-muted i { opacity: 0.6; }
    </style>
</head>

<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="profile"/>
</jsp:include>

<div class="container">

    <!-- TOP -->
    <div class="main-grid">

        <!-- PROFILE -->
        <div class="card p-3 text-center">
            <div class="avatar-box">
                <img src="${pageContext.request.contextPath}/${user.avatar}" class="avatar">
                <form action="upload-avatar" method="post" enctype="multipart/form-data">
                    <label class="avatar-upload">
                        <i class="fa fa-camera"></i>
                        <input type="file" name="avatar" hidden onchange="this.form.submit()">
                    </label>
                </form>
            </div>

            <h5 class="mt-3">${user.fullName}</h5>

            <div class="text-start mt-3">
                <div>Email: ${user.email}</div>
                <div>
                    Giới tính:
                    <c:choose>
                        <c:when test="${user.gender == 0}">Nam</c:when>
                        <c:when test="${user.gender == 1}">Nữ</c:when>
                        <c:otherwise>Khác</c:otherwise>
                    </c:choose>
                </div>
                <div>SĐT: ${user.phoneNumber}</div>
            </div>

            <button class="btn btn-warning mt-3" data-bs-toggle="modal" data-bs-target="#editModal">
                Chỉnh sửa
            </button>
        </div>

        <!-- ORDERS -->
        <div class="card p-3">
            <div class="card-title">Đơn hàng</div>

            <div class="orders-header">
                <div>Mã</div><div>Ngày</div><div>Tiền</div><div>Trạng thái</div><div></div>
            </div>

            <div class="scroll-box">

                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="text-center p-4 text-muted">
                            <i class="fa fa-box-open fa-2x mb-2"></i>
                            <div>Chưa có đơn hàng nào</div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="o" items="${orders}">
                            <div class="order-row">
                                <div>${o.orderCode}</div>
                                <div><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy"/></div>
                                <div><fmt:formatNumber value="${o.totalAmount}"/>đ</div>
                                <div>${o.orderStatus}</div>
                                <div><a href="order-detail?id=${o.id}"><i class="fa fa-eye"></i></a></div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

    </div>

    <!-- BOTTOM -->
    <div class="mt-4" style="display:grid;grid-template-columns:1fr 1fr;gap:20px">

        <!-- FAVORITE -->
        <div class="card p-3">
            <div class="card-title">Yêu thích</div>

            <div class="scroll-box">
                <div class="favorite-grid">

                    <c:choose>
                        <c:when test="${empty favoriteProducts}">
                            <div class="text-center p-4 text-muted">
                                <i class="fa fa-heart-broken fa-2x mb-2"></i>
                                <div>Chưa có sản phẩm yêu thích</div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="p" items="${favoriteProducts}">
                                <div class="favorite-item">
                                    <form action="remove-favorite" method="post">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <div class="remove-fav" onclick="this.closest('form').submit()">×</div>
                                    </form>
                                    <img src="${pageContext.request.contextPath}/${p.image}" style="width:100%;height:80px;object-fit:cover">
                                    <div>${p.name}</div>
                                    <b><fmt:formatNumber value="${p.price}"/>đ</b>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>

        <!-- VOUCHER -->
        <div class="card p-3">
            <div class="card-title">Voucher</div>

            <div class="scroll-box">

                <c:choose>
                    <c:when test="${empty vouchers}">
                        <div class="text-center p-4 text-muted">
                            <i class="fa fa-ticket fa-2x mb-2"></i>
                            <div>Chưa có voucher nào</div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="v" items="${vouchers}">
                            <div class="alert alert-warning">${v.code}</div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

        <!-- ADDRESS -->
        <div class="card p-3" style="grid-column: span 2;">
            <div class="card-title d-flex justify-content-between">
                <span>Địa chỉ</span>
                <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#addressModal">+ Thêm</button>
            </div>

            <div class="scroll-box">

                <c:choose>

                    <c:when test="${empty addresses}">
                        <div class="text-center p-4 text-muted">
                            <i class="fa fa-map-location-dot fa-2x mb-2"></i>
                            <div>Chưa có địa chỉ nào</div>

                            <button class="btn btn-warning btn-sm mt-2"
                                    data-bs-toggle="modal"
                                    data-bs-target="#addressModal">
                                + Thêm địa chỉ
                            </button>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="a" items="${addresses}">
                            <div class="address-item">

                                <div><b>${a.addressDetail}</b></div>

                                <div class="text-muted">
                                        ${a.ward}, ${a.district}, ${a.province}

                                    <c:if test="${a.is_default == 1}">
                                        <span class="badge bg-success ms-2">Mặc định</span>
                                    </c:if>
                                </div>

                                <div class="address-actions">
                                    <div class="icon-btn"><i class="fa fa-pen"></i></div>
                                    <div class="icon-btn"><i class="fa fa-trash"></i></div>

                                    <c:if test="${a.is_default == 0}">
                                        <div class="icon-btn"><i class="fa fa-check"></i></div>
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
    <div class="d-flex justify-content-center gap-3 mt-4">
        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#passwordModal">
            Đổi mật khẩu
        </button>
        <a href="logout" class="btn btn-danger">Đăng xuất</a>
    </div>

</div>

<!-- MODALS -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form action="profile" method="post" class="modal-content">
            <div class="modal-header"><h5>Chỉnh sửa thông tin</h5></div>
            <div class="modal-body">
                <input name="fullName" value="${user.fullName}" class="form-control mb-2">
                <select name="gender" class="form-control mb-2">
                    <option value="0" ${user.gender==0?'selected':''}>Nam</option>
                    <option value="1" ${user.gender==1?'selected':''}>Nữ</option>
                    <option value="2">Khác</option>
                </select>
                <input name="email" value="${user.email}" class="form-control mb-2">
                <input name="phoneNumber" value="${user.phoneNumber}" class="form-control">
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-warning">Lưu</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="addressModal">
    <div class="modal-dialog">
        <form action="address" method="post" class="modal-content">
            <div class="modal-header"><h5>Thêm địa chỉ</h5></div>
            <div class="modal-body">
                <input name="addressDetail" class="form-control mb-2">
                <input name="ward" class="form-control mb-2">
                <input name="district" class="form-control mb-2">
                <input name="province" class="form-control mb-2">
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-warning">Lưu</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="passwordModal">
    <div class="modal-dialog">
        <form action="change-password" method="post" class="modal-content">
            <div class="modal-header"><h5>Đổi mật khẩu</h5></div>
            <div class="modal-body">
                <input type="password" name="oldPassword" class="form-control mb-2">
                <input type="password" name="newPassword" class="form-control mb-2">
                <input type="password" name="confirmPassword" class="form-control">
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-warning">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>