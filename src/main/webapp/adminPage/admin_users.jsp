<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven - Quản lý người dùng</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_user.css">
    <script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</head>

<body>
<div class="admin-wrapper">

    <div class="sidebar">
        <div class="d-flex flex-column h-100 p-3">
            <div class="sidebar-header text-center mb-4 mt-3">
                <h3 class="text-white fw-bold mb-0">SWEET OVEN</h3>
                <p class="text-white-50 small mt-2">Quản trị hệ thống</p>
            </div>

            <ul class="nav nav-pills flex-column mb-auto">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="nav-link ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i> <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/products"
                       class="nav-link ${pageContext.request.requestURI.contains('products') ? 'active' : ''}">
                        <i class="fas fa-box"></i> <span>Sản phẩm</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/categories"
                       class="nav-link ${pageContext.request.requestURI.contains('categories') ? 'active' : ''}">
                        <i class="fas fa-list"></i> <span>Danh mục</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="nav-link ${pageContext.request.requestURI.contains('users') ? 'active' : ''}">
                        <i class="fas fa-users"></i> <span>Người dùng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/orders"
                       class="nav-link ${pageContext.request.requestURI.contains('orders') ? 'active' : ''}">
                        <i class="fas fa-shopping-cart"></i> <span>Đơn hàng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/banners"
                       class="nav-link ${pageContext.request.requestURI.contains('banners') ? 'active' : ''}">
                        <i class="fas fa-images"></i> <span>Banner</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/feedback"
                       class="nav-link ${pageContext.request.requestURI.contains('feedback') ? 'active' : ''}">
                        <i class="fas fa-envelope"></i> <span>Phản hồi</span>
                    </a>
                </li>
            </ul>

            <div class="dropdown mt-auto pt-3 border-top border-secondary">
                <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                   id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle fa-2x me-2"></i>
                    <strong>${sessionScope.user.fullName}</strong>
                </a>
                <ul class="dropdown-menu dropdown-menu-dark shadow" aria-labelledby="dropdownUser">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="main-content">

        <c:if test="${not empty sessionScope.successMsg}">
            <div id="alertFloating" class="alert alert-success alert-floating d-flex align-items-center gap-2">
                <i class="fas fa-check-circle"></i> ${sessionScope.successMsg}
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div id="alertFloating" class="alert alert-danger alert-floating d-flex align-items-center gap-2">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="admin-header d-flex justify-content-between align-items-center">
            <div>
                <h1 class="h3 mb-1 text-primary fw-bold">
                    <i class="fas fa-users me-2"></i>Quản lý người dùng
                </h1>
                <p class="text-muted mb-0 small">Quản lý tài khoản và quyền truy cập của khách hàng</p>
            </div>
            <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-user-plus me-2"></i>Thêm tài khoản
            </button>
        </div>

        <div class="stats-grid">
            <div class="stats-card total-card">
                <div class="stats-icon"><i class="fas fa-users"></i></div>
                <div>
                    <div class="stats-number">${totalUsers}</div>
                    <div class="stats-label">Tổng người dùng</div>
                </div>
            </div>
            <div class="stats-card active-card">
                <div class="stats-icon"><i class="fas fa-user-check"></i></div>
                <div>
                    <div class="stats-number">${activeUsers}</div>
                    <div class="stats-label">Đang hoạt động</div>
                </div>
            </div>
            <div class="stats-card blocked-card">
                <div class="stats-icon"><i class="fas fa-user-lock"></i></div>
                <div>
                    <div class="stats-number">${blockedUsers}</div>
                    <div class="stats-label">Đã khoá</div>
                </div>
            </div>
            <div class="stats-card new-card">
                <div class="stats-icon"><i class="fas fa-user-plus"></i></div>
                <div>
                    <div class="stats-number">${newUsersThisMonth}</div>
                    <div class="stats-label">Mới tháng này</div>
                </div>
            </div>
        </div>

        <div class="filter-card">
            <div class="filter-title"><i class="fas fa-filter me-2"></i>Tìm kiếm & Lọc</div>
            <div class="row g-3 align-items-end">
                <div class="col-md-5">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" class="form-control"
                               placeholder="Tìm theo tên, username, email, SĐT..."
                               value="${keyword}">
                    </div>
                </div>
                <div class="col-md-3">
                    <select id="filterStatus" class="form-select filter-select">
                        <option value="-1" ${status == -1 ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="1"  ${status == 1  ? 'selected' : ''}>Đã xác thực</option>
                        <option value="0"  ${status == 0  ? 'selected' : ''}>Chưa xác thực</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select id="filterBlocked" class="form-select filter-select">
                        <option value="-1" ${blocked == -1 ? 'selected' : ''}>Tất cả</option>
                        <option value="0"  ${blocked == 0  ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="1"  ${blocked == 1  ? 'selected' : ''}>Đã khoá</option>
                    </select>
                </div>
                <div class="col-md-1">
                    <button class="btn btn-outline-secondary btn-filter w-100"
                            onclick="document.getElementById('searchInput').value='';submitFilter();"
                            title="Xoá bộ lọc">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="table-card">
            <div class="table-header">
                <h5 class="table-title">
                    Danh sách người dùng
                    <span class="badge bg-secondary ms-2">${totalUsers} người</span>
                </h5>
                <span class="page-info">
                    Trang ${currentPage} / ${totalPages > 0 ? totalPages : 1}
                </span>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th style="width:44px">#</th>
                        <th>Người dùng</th>
                        <th>Số điện thoại</th>
                        <th>Giới tính</th>
                        <th>Trạng thái</th>
                        <th>Khoá</th>
                        <th>Ngày đăng ký</th>
                        <th style="width:160px">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="8">
                                    <div class="empty-state">
                                        <i class="fas fa-users"></i>
                                        <p>Không tìm thấy người dùng nào</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${users}" varStatus="st">
                                <tr>
                                    <td class="text-muted small">
                                            ${(currentPage - 1) * pageSize + st.index + 1}
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <c:choose>
                                                <c:when test="${not empty u.avatar}">
                                                    <img src="${u.avatar}" class="user-avatar" alt="avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="user-avatar-placeholder"
                                                         data-initial="${u.fullName}">?</div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="user-info">
                                                <div class="user-name">${u.fullName}</div>
                                                <div class="user-email">@${u.userName} · ${u.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${not empty u.phoneNumber ? u.phoneNumber : '—'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.gender == 1}">Nam</c:when>
                                            <c:when test="${u.gender == 2}">Nữ</c:when>
                                            <c:otherwise>Khác</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span class="badge-status badge-active">
                                                    <i class="fas fa-circle" style="font-size:7px"></i> Đã xác thực
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-inactive">
                                                    <i class="fas fa-circle" style="font-size:7px"></i> Chưa xác thực
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.blocked}">
                                                <span class="badge-status badge-blocked">
                                                    <i class="fas fa-lock"></i> Đã khoá
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-active">
                                                    <i class="fas fa-unlock"></i> Bình thường
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">
                                        <c:if test="${not empty u.createdAt}">
                                            <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"
                                                            type="date" var="fmtDate"/>
                                            ${not empty fmtDate ? fmtDate : u.createdAt}
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="btn-action btn-view"
                                                    onclick="openViewModal(${u.id})"
                                                    title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn-action btn-edit"
                                                    onclick="openEditModal(${u.id})"
                                                    title="Chỉnh sửa">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${u.blocked}">
                                                    <button class="btn-action btn-unblock"
                                                            onclick="confirmUnblock(${u.id}, '${u.fullName}')"
                                                            title="Mở khoá">
                                                        <i class="fas fa-lock-open"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action btn-block"
                                                            onclick="confirmBlock(${u.id}, '${u.fullName}')"
                                                            title="Khoá tài khoản">
                                                        <i class="fas fa-lock"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <button class="btn-action btn-reset"
                                                    onclick="confirmResetPassword(${u.id}, '${u.fullName}')"
                                                    title="Đặt lại mật khẩu">
                                                <i class="fas fa-key"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pagination-wrapper d-flex justify-content-between align-items-center">
                    <span class="page-info">
                        Hiển thị ${(currentPage - 1) * pageSize + 1}–${(currentPage * pageSize < totalUsers) ? currentPage * pageSize : totalUsers}
                        trong tổng ${totalUsers} người dùng
                    </span>
                    <nav>
                        <ul class="pagination mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${currentPage - 1}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${p}">
                                                ${p}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${currentPage + 1}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</div>


<div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i>Thêm tài khoản mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" class="form-control"
                                   placeholder="Nguyễn Văn A" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                            <input type="text" name="username" class="form-control"
                                   placeholder="nguyenvana" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control"
                                   placeholder="email@example.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" name="phone" class="form-control"
                                   placeholder="0901234567" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" name="password" class="form-control"
                                   placeholder="Tối thiểu 8 ký tự, chữ hoa, số, ký tự đặc biệt"
                                   required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giới tính</label>
                            <select name="gender" class="form-select">
                                <option value="0">Khác</option>
                                <option value="1">Nam</option>
                                <option value="2">Nữ</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Vai trò</label>
                            <select name="roleId" class="form-select">
                                <option value="2">Khách hàng</option>
                                <option value="1">Admin</option>
                            </select>
                        </div>
                    </div>
                    <p class="text-muted small mt-3 mb-0">
                        <i class="fas fa-info-circle me-1"></i>
                        Mật khẩu phải gồm ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn btn-primary-custom">
                        <i class="fas fa-save me-2"></i>Tạo tài khoản
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="viewUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-id-card me-2"></i>Chi tiết tài khoản</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="user-detail-header">
                    <div id="viewAvatarWrap"></div>
                    <h5 class="fw-bold mb-1" id="viewFullName"></h5>
                    <span class="text-muted small" id="viewUsername"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-envelope me-2"></i>Email</span>
                    <span class="detail-value" id="viewEmail"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-phone me-2"></i>Điện thoại</span>
                    <span class="detail-value" id="viewPhone"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-venus-mars me-2"></i>Giới tính</span>
                    <span class="detail-value" id="viewGender"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-check-circle me-2"></i>Trạng thái</span>
                    <span class="detail-value" id="viewStatus"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-lock me-2"></i>Khoá</span>
                    <span class="detail-value" id="viewBlocked"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-user-tag me-2"></i>Vai trò</span>
                    <span class="detail-value" id="viewRole"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-calendar me-2"></i>Ngày đăng ký</span>
                    <span class="detail-value" id="viewCreatedAt"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label"><i class="fas fa-shopping-bag me-2"></i>Số đơn hàng</span>
                    <span class="detail-value" id="viewOrderCount"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-edit me-2"></i>Chỉnh sửa thông tin</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" name="fullName" id="editFullName" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" name="email" id="editEmail" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" name="phone" id="editPhone" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giới tính</label>
                            <select name="gender" id="editGender" class="form-select">
                                <option value="0">Khác</option>
                                <option value="1">Nam</option>
                                <option value="2">Nữ</option>
                            </select>
                        </div>
                    </div>
                    <p class="text-muted small mt-3 mb-0">
                        <i class="fas fa-info-circle me-1"></i>
                        Tên đăng nhập (username) không thể thay đổi sau khi tạo.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn btn-primary-custom">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_user.js"></script>
<script>
    document.querySelectorAll('[data-initial]').forEach(el => {
        const name = el.getAttribute('data-initial') || '?';
        el.textContent = name.charAt(0).toUpperCase();
    });
</script>

</body>
</html>