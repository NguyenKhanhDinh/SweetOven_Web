<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sweet Oven - Quản lý danh mục</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_category.css">


</head>

<body>
<div class="container-fluid">
    <div class="row">

        <!-- Sidebar -->
        <div class="sidebar p-0">
            <div class="d-flex flex-column h-100">
                <div class="sidebar-header text-center">
                    <h3 class="text-white fw-bold mb-1">🍰 Sweet Oven</h3>
                    <p class="text-white-50 small mb-0">Administrator Panel</p>
                </div>

                <ul class="nav nav-pills flex-column mb-auto">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                            <i class="fas fa-chart-line"></i> <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/products" class="nav-link">
                            <i class="fas fa-box"></i> <span>Sản phẩm</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/categories" class="nav-link active">
                            <i class="fas fa-list"></i> <span>Danh mục</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                            <i class="fas fa-users"></i> <span>Người dùng</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link">
                            <i class="fas fa-shopping-cart"></i> <span>Đơn hàng</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/promotions" class="nav-link">
                            <i class="fas fa-tag"></i> <span>Khuyến mãi</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/banners" class="nav-link">
                            <i class="fas fa-images"></i> <span>Banner</span>
                        </a>
                    </li>
                </ul>

                <div class="dropdown p-3 mt-auto">
                    <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                       id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle fa-2x me-2"></i>
                        <div>
                            <strong>Admin</strong>
                            <small class="d-block text-white-50">Quản trị viên</small>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-dark text-small shadow" aria-labelledby="dropdownUser">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">

            <!-- Header -->
            <div class="admin-header d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h1 class="h3 mb-1 text-primary fw-bold">📁 Quản lý danh mục</h1>
                    <p class="text-muted mb-0 small">Quản lý và tổ chức danh mục sản phẩm</p>
                </div>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="fas fa-plus me-2"></i>Thêm danh mục mới
                </button>
            </div>

            <!-- Stats Row -->
            <div class="row mb-4">
                <div class="col-md-3 mb-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted mb-1 small">Tổng danh mục</p>
                            <h3 class="mb-0 text-primary fw-bold">${totalCategories}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-folder"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted mb-1 small">Đang hoạt động</p>
                            <h3 class="mb-0 text-success fw-bold">${activeCategories}</h3>
                        </div>
                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--success), #218838);">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted mb-1 small">Ngừng hoạt động</p>
                            <h3 class="mb-0 text-danger fw-bold">${inactiveCategories}</h3>
                        </div>
                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--danger), #c82333);">
                            <i class="fas fa-ban"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <p class="text-muted mb-1 small">Tổng sản phẩm</p>
                            <h3 class="mb-0 text-warning fw-bold">${totalProducts}</h3>
                        </div>
                        <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning), #e0a800);">
                            <i class="fas fa-cake"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" class="form-control" name="search" value="${searchKeyword}"
                               placeholder="Tìm kiếm theo tên hoặc mô tả danh mục...">
                    </form>
                </div>
                <div class="col-md-6 text-end">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-primary-custom" onclick="filterAll()">
                            <i class="fas fa-list me-1"></i>Tất cả
                        </button>
                        <button type="button" class="btn btn-outline-primary-custom" onclick="filterActive()">
                            <i class="fas fa-check-circle me-1"></i>Hoạt động
                        </button>
                        <button type="button" class="btn btn-outline-primary-custom" onclick="filterInactive()">
                            <i class="fas fa-ban me-1"></i>Ngừng hoạt động
                        </button>
                    </div>
                </div>
            </div>

            <!-- Message display -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Categories Table -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="categoryTable">
                        <thead>
                        <tr>
                            <th width="5%">#</th>
                            <th width="15%">Hình ảnh</th>
                            <th width="25%">Tên danh mục</th>
                            <th width="15%">Số sản phẩm</th>
                            <th width="15%">Trạng thái</th>
                            <th width="15%">Ngày tạo</th>
                            <th width="10%">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${categories}" var="c" varStatus="loop">
                            <tr data-status="${c.status == 1 ? 'active' : 'inactive'}">
                                <td class="fw-bold">${loop.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.thumbnail}">
                                            <img src="${pageContext.request.contextPath}/${c.thumbnail}"
                                                 class="thumbnail-img" alt="${c.name}"
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/picture/logo.png"
                                                 class="thumbnail-img" alt="Default">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="fw-bold text-primary">${c.name}</div>
                                    <small class="text-muted">${c.description != null ? c.description : 'Không có mô tả'}</small>
                                </td>
                                <td>
                                    <span class="badge bg-secondary rounded-pill px-3">${c.productCount != null ? c.productCount : 0} sản phẩm</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status == 1}">
                                            <span class="badge badge-active">✓ Đang hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-inactive">✗ Ngừng hoạt động</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-muted">${c.createdAt}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <button class="btn btn-sm btn-outline-primary btn-edit me-1"
                                                data-bs-toggle="modal"
                                                data-bs-target="#editCategoryModal"
                                                data-id="${c.id}"
                                                data-name="${c.name}"
                                                data-description="${c.description}"
                                                data-thumbnail="${c.thumbnail}"
                                                data-status="${c.status}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger btn-delete"
                                                data-id="${c.id}"
                                                data-name="${c.name}"
                                                data-has-products="${c.hasProducts != null ? c.hasProducts : false}"
                                                data-product-count="${c.productCount != null ? c.productCount : 0}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categories}">
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <i class="fas fa-folder-open fa-3x text-muted mb-3 d-block"></i>
                                    <p class="text-muted">Chưa có danh mục nào</p>
                                    <button class="btn btn-primary-custom btn-sm" data-bs-toggle="modal"
                                            data-bs-target="#addCategoryModal">
                                        <i class="fas fa-plus me-1"></i>Thêm danh mục đầu tiên
                                    </button>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>Thêm danh mục mới</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="addCategoryForm" action="${pageContext.request.contextPath}/admin/categories" method="post"
                  enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">

                    <div class="form-section">
                        <h6 class="form-section-title">📝 Thông tin cơ bản</h6>
                        <div class="mb-3">
                            <label class="form-label required fw-bold">Tên danh mục</label>
                            <input type="text" class="form-control" name="name" id="add-name"
                                   placeholder="VD: Bánh ngọt, Bánh mặn, Bánh mì..."
                                   required>
                            <small class="text-muted">Tên danh mục sẽ hiển thị trên cửa hàng</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mô tả danh mục</label>
                            <textarea class="form-control" name="description" id="add-description" rows="3"
                                      placeholder="Mô tả về danh mục sản phẩm này..."></textarea>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">🖼️ Hình ảnh danh mục</h6>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ảnh đại diện</label>
                            <input type="file" class="form-control" name="thumbnail" id="add-thumbnail"
                                   accept="image/*" onchange="previewImage(this, 'add-image-preview')">
                            <div id="add-image-preview" class="mt-2"></div>
                            <small class="text-muted">Hỗ trợ: PNG, JPG, JPEG (tối đa 5MB)</small>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">⚙️ Trạng thái</h6>
                        <div class="mb-3">
                            <select class="form-select" name="status" id="add-status">
                                <option value="1">✓ Đang hoạt động</option>
                                <option value="0">✗ Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Hủy
                    </button>
                    <button type="submit" class="btn btn-primary-custom">
                        <i class="fas fa-save me-1"></i>Thêm danh mục
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Chỉnh sửa danh mục</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="editCategoryForm" action="${pageContext.request.contextPath}/admin/categories" method="post"
                  enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="edit-id">

                    <div class="form-section">
                        <h6 class="form-section-title">📝 Thông tin cơ bản</h6>
                        <div class="mb-3">
                            <label class="form-label required fw-bold">Tên danh mục</label>
                            <input type="text" class="form-control" name="name" id="edit-name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mô tả danh mục</label>
                            <textarea class="form-control" name="description" id="edit-description" rows="3"></textarea>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">🖼️ Hình ảnh danh mục</h6>
                        <div class="current-image" id="current-image-container">
                            <p class="mb-2 small fw-bold">Ảnh hiện tại:</p>
                            <img id="current-thumbnail-preview" src="" alt="Current Thumbnail">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Cập nhật ảnh mới</label>
                            <input type="file" class="form-control" name="thumbnail" id="edit-thumbnail"
                                   accept="image/*" onchange="previewImage(this, 'edit-image-preview')">
                            <div id="edit-image-preview" class="mt-2"></div>
                            <small class="text-muted">Để trống nếu không muốn thay đổi ảnh</small>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">⚙️ Trạng thái</h6>
                        <div class="mb-3">
                            <select class="form-select" name="status" id="edit-status">
                                <option value="1">✓ Đang hoạt động</option>
                                <option value="0">✗ Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Hủy
                    </button>
                    <button type="submit" class="btn btn-primary-custom">
                        <i class="fas fa-save me-1"></i>Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="delete-message"></p>
                <div id="delete-warning" class="alert alert-warning" style="display: none;">
                    <i class="fas fa-info-circle me-2"></i>Danh mục này có sản phẩm, bạn có muốn xóa tất cả sản phẩm không?
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i>Hủy
                </button>
                <a href="#" id="confirm-delete-btn" class="btn btn-danger">
                    <i class="fas fa-trash me-1"></i>Xóa
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_category.js"></script>

</body>

</html>