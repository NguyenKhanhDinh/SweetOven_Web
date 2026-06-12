<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý tài khoản</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_user.css">
    <script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</head>
<body>
<div class="admin-wrapper">

    <%@ include file="/components/sidebar.jsp" %>

    <main class="main-content">

        <c:if test="${not empty sessionScope.successMsg}">
            <div id="alertFloating" class="alert-floating alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.successMsg}
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div id="alertFloating" class="alert-floating alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="page-header">
            <h1 class="page-title"><i class="fas fa-users"></i> Quản lý tài khoản</h1>
            <button class="btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-user-plus"></i> Thêm tài khoản
            </button>
        </div>

        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-total"></div>
                <div class="stat-value">${totalAllUsers}</div>
                <div class="stat-label">Tổng tài khoản</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-active"></div>
                <div class="stat-value">${activeUsers}</div>
                <div class="stat-label">Đang hoạt động</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-blocked"></div>
                <div class="stat-value">${blockedUsers}</div>
                <div class="stat-label">Đã khoá</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-new"></div>
                <div class="stat-value">${newUsersThisMonth}</div>
                <div class="stat-label">Mới tháng này</div>
            </div>
        </div>

        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Tìm theo tên, username, email, số điện thoại..."
                       value="${keyword}">
            </div>
            <select id="filterRole" class="filter-select">
                <option value="-1" ${roleFilter == -1 ? 'selected' : ''}>Tất cả vai trò</option>
                <option value="1"  ${roleFilter == 1  ? 'selected' : ''}>Admin</option>
                <option value="2"  ${roleFilter == 2  ? 'selected' : ''}>Khách hàng</option>
            </select>
            <select id="filterBlocked" class="filter-select">
                <option value="-1" ${blocked == -1 ? 'selected' : ''}>Tất cả</option>
                <option value="0"  ${blocked == 0  ? 'selected' : ''}>Đang hoạt động</option>
                <option value="1"  ${blocked == 1  ? 'selected' : ''}>Đã khoá</option>
            </select>
            <button class="btn-apply-filter" onclick="submitFilter();">
                <i class="fas fa-filter"></i> Áp dụng
            </button>
            <button class="btn-reset-filter" onclick="resetFilter();">
                <i class="fas fa-undo"></i> Đặt lại
            </button>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">
                    <i class="fas fa-list-ul"></i>
                    Danh sách tài khoản
                </div>
                <div class="page-meta">
                    <i class="fas fa-file-alt"></i>
                    Trang <strong>&nbsp;${currentPage}&nbsp;</strong> /
                    <strong>&nbsp;${totalPages > 0 ? totalPages : 1}&nbsp;</strong>
                </div>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <colgroup>
                        <col class="col-no">
                        <col class="col-user">
                        <col class="col-contact">
                        <col class="col-role">
                        <col class="col-date">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Người dùng</th>
                        <th class="hide-xs">Liên hệ</th>
                        <th style="text-align:center">Vai trò</th>
                        <th class="hide-mobile col-date-th">Ngày đăng ký</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="fas fa-user-slash"></i></div>
                                        <h4>Không tìm thấy tài khoản nào</h4>
                                        <p>Thử thay đổi từ khoá hoặc điều chỉnh bộ lọc</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${users}" varStatus="st">
                                <tr class="${u.blocked ? 'row-blocked' : ''}">
                                    <td><span class="row-num">${(currentPage-1)*pageSize + st.index + 1}</span></td>
                                    <td>
                                        <div class="user-cell">
                                            <c:choose>
                                                <c:when test="${not empty u.avatar}">
                                                    <img src="${u.avatar}" class="user-avatar" alt="avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="user-avatar-placeholder">
                                                        <c:choose>
                                                            <c:when test="${not empty u.fullName}">${fn:substring(u.fullName,0,1)}</c:when>
                                                            <c:otherwise>?</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <div class="user-name">
                                                        ${u.fullName}
                                                    <c:if test="${u.gender == 1}">
                                                        <span class="gender-tag gender-m"><i class="fas fa-mars"></i></span>
                                                    </c:if>
                                                    <c:if test="${u.gender == 2}">
                                                        <span class="gender-tag gender-f"><i class="fas fa-venus"></i></span>
                                                    </c:if>
                                                </div>
                                                <div class="user-meta-line">
                                                    <span>${u.email}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="hide-xs">
                                        <div class="contact-cell">
                                            <c:choose>
                                                <c:when test="${not empty u.phoneNumber}">
                                                    <i class="fas fa-phone-alt"></i>${u.phoneNumber}
                                                </c:when>
                                                <c:otherwise><span style="color:#ccc">—</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${u.roleId == 1}">
                                                <span class="role-badge role-admin">Quản trị viên</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="role-badge role-customer"></i>Khách hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="hide-mobile col-date-td">
                                        <c:choose>
                                            <c:when test="${not empty u.createdAt}">
                                                <div class="date-cell">
                                                    <c:set var="dt"  value="${u.createdAt}"/>
                                                    <c:set var="yr"  value="${fn:substring(dt,0,4)}"/>
                                                    <c:set var="mo"  value="${fn:substring(dt,5,7)}"/>
                                                    <c:set var="day" value="${fn:substring(dt,8,10)}"/>
                                                   ${day}/${mo}/${yr}
                                                </div>
                                            </c:when>
                                            <c:otherwise><span style="color:#ccc">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <button class="action-btn action-btn-view"
                                                    onclick="openViewModal(${u.id})" title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-btn action-btn-edit"
                                                    onclick="openEditModal(${u.id})" title="Chỉnh sửa">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <c:if test="${u.status == 0 && !u.blocked}">
                                                <button class="action-btn action-btn-activate"
                                                        onclick="confirmActivate(${u.id},'${u.fullName}')"
                                                        title="Kích hoạt tài khoản">
                                                    <i class="fas fa-user-check"></i>
                                                </button>
                                            </c:if>
                                            <c:choose>
                                                <c:when test="${u.blocked}">
                                                    <button class="action-btn action-btn-unblock"
                                                            onclick="confirmUnblock(${u.id},'${u.fullName}')"
                                                            title="Mở khoá">
                                                        <i class="fas fa-lock-open"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="action-btn action-btn-block"
                                                            onclick="confirmBlock(${u.id},'${u.fullName}')"
                                                            title="Khoá tài khoản">
                                                        <i class="fas fa-lock"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="table-footer">
                <span class="result-info">
                    <c:choose>
                        <c:when test="${totalUsers > 0}">
                            Hiển thị <strong>${(currentPage-1)*pageSize + 1}</strong>–<strong>${(currentPage*pageSize < totalUsers) ? currentPage*pageSize : totalUsers}</strong>
                            trong <strong>${totalUsers}</strong> tài khoản
                        </c:when>
                        <c:otherwise>Không có dữ liệu phù hợp</c:otherwise>
                    </c:choose>
                </span>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${currentPage-1}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        <c:if test="${currentPage > 3}">
                            <li class="page-item">
                                <a class="page-link" href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=1">1</a>
                            </li>
                            <c:if test="${currentPage > 4}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p >= currentPage-2 && p <= currentPage+2}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${p}">${p}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages-2}">
                            <c:if test="${currentPage < totalPages-3}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link" href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${totalPages}">${totalPages}</a>
                            </li>
                        </c:if>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&status=${status}&blocked=${blocked}&page=${currentPage+1}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </div>

    </main>
</div>

<div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-plus"></i> Thêm tài khoản mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ và tên <span class="req">*</span></label>
                            <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên đăng nhập <span class="req">*</span></label>
                            <input type="text" name="username" class="form-control" placeholder="nguyenvana" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email <span class="req">*</span></label>
                            <input type="email" name="email" class="form-control" placeholder="email@example.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại <span class="req">*</span></label>
                            <input type="text" name="phone" class="form-control" placeholder="0901234567" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu <span class="req">*</span></label>
                            <input type="password" name="password" class="form-control"
                                   placeholder="Tối thiểu 8 ký tự" required>
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
                    <div class="form-hint">
                        <i class="fas fa-info-circle"></i>
                        Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Tạo tài khoản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="viewUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-id-card"></i> Chi tiết tài khoản</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="detail-header">
                    <div id="viewAvatarWrap"></div>
                    <div class="detail-fullname" id="viewFullName"></div>
                    <div class="detail-username" id="viewUsername"></div>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-envelope"></i> Email</span>
                    <span class="detail-val" id="viewEmail"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-phone-alt"></i> Điện thoại</span>
                    <span class="detail-val" id="viewPhone"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-venus-mars"></i> Giới tính</span>
                    <span class="detail-val" id="viewGender"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-user-tag"></i> Vai trò</span>
                    <span class="detail-val" id="viewRole"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-shield-alt"></i> Trạng thái</span>
                    <span class="detail-val" id="viewStatus"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-lock"></i> Khoá</span>
                    <span class="detail-val" id="viewBlocked"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-calendar-alt"></i> Ngày đăng ký</span>
                    <span class="detail-val" id="viewCreatedAt"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-shopping-bag"></i> Số đơn hàng</span>
                    <span class="detail-val" id="viewOrderCount"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-user-edit"></i> Chỉnh sửa thông tin</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Họ và tên <span class="req">*</span></label>
                            <input type="text" name="fullName" id="editFullName" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email <span class="req">*</span></label>
                            <input type="email" name="email" id="editEmail" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại <span class="req">*</span></label>
                            <input type="text" name="phone" id="editPhone" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Giới tính</label>
                            <select name="gender" id="editGender" class="form-select">
                                <option value="0">Khác</option>
                                <option value="1">Nam</option>
                                <option value="2">Nữ</option>
                            </select>
                        </div>
                    </div>
                    <div style="margin-top:18px;border-top:1px solid #f0e8e0;padding-top:14px">
                        <div class="d-flex align-items-center gap-2" style="margin-bottom:10px">
                            <span style="font-weight:600;font-size:0.92rem;color:#3C2F27">
                                <i class="fas fa-key me-1" style="color:#b08060"></i>Đổi mật khẩu
                            </span>
                            <span class="badge bg-secondary" style="font-size:0.72rem;font-weight:500">Tuỳ chọn</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Mật khẩu mới</label>
                                <div class="input-group">
                                    <input type="password" name="newPassword" id="editNewPassword"
                                           class="form-control" placeholder="Để trống nếu không đổi"
                                           autocomplete="new-password">
                                    <button type="button" class="btn btn-outline-secondary"
                                            onclick="togglePwd('editNewPassword', this)" tabindex="-1">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Xác nhận mật khẩu mới</label>
                                <div class="input-group">
                                    <input type="password" id="editConfirmPassword"
                                           class="form-control" placeholder="Nhập lại mật khẩu mới"
                                           autocomplete="new-password" oninput="checkPwdMatch()">
                                    <button type="button" class="btn btn-outline-secondary"
                                            onclick="togglePwd('editConfirmPassword', this)" tabindex="-1">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div id="pwdMatchMsg" style="font-size:0.8rem;margin-top:4px"></div>
                            </div>
                        </div>
                    </div>
                    <div class="form-hint" style="margin-top:14px">
                        <i class="fas fa-info-circle"></i>
                        Tên đăng nhập không thể thay đổi sau khi tạo.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<input type="hidden" id="autoOpenModal" value="${autoOpenModal}">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_user.js"></script>
</body>
</html>
