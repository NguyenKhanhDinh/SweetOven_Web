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
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_category.css">
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i> <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/products" class="nav-link ${pageContext.request.requestURI.contains('products') ? 'active' : ''}">
                        <i class="fas fa-box"></i> <span>Sản phẩm</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/categories" class="nav-link ${pageContext.request.requestURI.contains('categories') ? 'active' : ''}">
                        <i class="fas fa-list"></i> <span>Danh mục</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link ${pageContext.request.requestURI.contains('users') ? 'active' : ''}">
                        <i class="fas fa-users"></i> <span>Người dùng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link ${pageContext.request.requestURI.contains('orders') ? 'active' : ''}">
                        <i class="fas fa-shopping-cart"></i> <span>Đơn hàng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/promotions" class="nav-link ${pageContext.request.requestURI.contains('promotions') ? 'active' : ''}">
                        <i class="fas fa-tag"></i> <span>Khuyến mãi</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/banners" class="nav-link ${pageContext.request.requestURI.contains('banners') ? 'active' : ''}">
                        <i class="fas fa-images"></i> <span>Banner</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link ${pageContext.request.requestURI.contains('feedback') ? 'active' : ''}">
                        <i class="fas fa-envelope"></i> <span>Phản hồi</span>
                    </a>
                </li>
            </ul>

            <div class="dropdown mt-auto pt-3 border-top border-secondary">
                <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle fa-2x me-2"></i>
                    <strong>Quản trị viên</strong>
                </a>
                <ul class="dropdown-menu dropdown-menu-dark shadow" aria-labelledby="dropdownUser">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="main-content">
            <div class="admin-header d-flex justify-content-between align-items-end">
                <div>
                    <h1 class="h3 mb-1 text-primary fw-bold">Quản lý danh mục</h1>
                    <p class="text-muted mb-0 small">Quản lý và tổ chức danh mục sản phẩm cửa hàng</p>
                </div>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="fas fa-plus me-2"></i>Thêm danh mục mới
                </button>
            </div>
            <div class="stats-grid mb-4">
                <div class="stats-card total-card">
                    <div class="stats-icon">
                        <i class="fas fa-layer-group"></i>
                    </div>

                    <div class="stats-content">
                        <p>Tổng danh mục</p>
                        <h3>${totalCategories != null ? totalCategories : 0}</h3>
                        <span>danh mục</span>
                    </div>

                </div>

                <div class="stats-card active-card">
                    <div class="stats-icon">
                        <i class="fas fa-play"></i>
                    </div>

                    <div class="stats-content">
                        <p>Đang hoạt động</p>
                        <h3>${activeCategories != null ? activeCategories : 0}</h3>
                        <span>danh mục</span>
                    </div>

                </div>

                <div class="stats-card inactive-card">
                    <div class="stats-icon">
                        <i class="fas fa-pause"></i>
                    </div>

                    <div class="stats-content">
                        <p>Ngừng hoạt động</p>
                        <h3>${inactiveCategories != null ? inactiveCategories : 0}</h3>
                        <span>danh mục</span>
                    </div>
                </div>

                <div class="stats-card product-card-stat">
                    <div class="stats-icon">
                        <i class="fas fa-bag-shopping"></i>
                    </div>

                    <div class="stats-content">
                        <p>Tổng sản phẩm</p>
                        <h3>${totalProducts != null ? totalProducts : 0}</h3>
                        <span>sản phẩm</span>
                    </div>
                </div>
            </div>

            <div class="row mb-4 align-items-center">
                <div class="col-lg-6 mb-3 mb-lg-0">
                    <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" class="form-control" name="search" value="${searchKeyword}" placeholder="Tìm kiếm theo tên hoặc mô tả danh mục...">
                    </form>
                </div>
                <div class="col-lg-6 text-lg-end">
                    <div class="btn-group filter-group" role="group">
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

            <div class="table-container mb-4">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="categoryTable">
                        <thead>
                        <tr>
                            <th width="5%">#</th>
                            <th width="12%">Hình ảnh</th>
                            <th width="28%">Tên & Mô tả danh mục</th>
                            <th width="15%">Số sản phẩm</th>
                            <th width="15%">Trạng thái</th>
                            <th width="15%">Ngày tạo</th>
                            <th width="10%">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${categories}" var="c" varStatus="loop">
                            <tr data-status="${c.status == 1 ? 'active' : 'inactive'}">
                                <td class="fw-bold text-center">${loop.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.thumbnail}">
                                            <img src="${pageContext.request.contextPath}/${c.thumbnail}" class="thumbnail-img" alt="${c.name}" onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/picture/logo.png" class="thumbnail-img" alt="Default">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="category-name">${c.name}</div>
                                    <div class="category-desc">${not empty c.description ? c.description : 'Không có mô tả dữ liệu'}</div>
                                </td>
                                <td>
                                    <span class="product-badge">${c.productCount != null ? c.productCount : 0} sản phẩm</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status == 1}">
                                            <span class="badge-active">✓ Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-inactive">✗ Ngừng bán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="date-text">${c.createdAt}</td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-edit" data-bs-toggle="modal" data-bs-target="#editCategoryModal"
                                                data-id="${c.id}" data-name="${c.name}" data-description="${c.description}"
                                                data-thumbnail="${c.thumbnail}" data-status="${c.status}">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-delete" data-id="${c.id}" data-name="${c.name}"
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
                                    <div class="empty-state">
                                        <i class="fas fa-folder-open"></i>
                                        <h5>Không tìm thấy dữ liệu danh mục</h5>
                                        <p>Vui lòng thêm danh mục mới hoặc thay đổi từ khóa tìm kiếm</p>
                                        <button class="btn btn-primary-custom btn-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                                            <i class="fas fa-plus me-1"></i>Tạo ngay danh mục đầu tiên
                                        </button>
                                    </div>
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

<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle me-2"></i>Thêm danh mục mới</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="addCategoryForm" action="${pageContext.request.contextPath}/admin/categories?action=add" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="name" id="add-name" placeholder="VD: Bánh kem sinh nhật, Bánh mì Pháp..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mô tả danh mục</label>
                        <textarea class="form-control" name="description" id="add-description" rows="3" placeholder="Thông tin mô tả danh mục..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Hình ảnh hiển thị</label>
                        <input type="file" class="form-control" name="thumbnail" id="add-thumbnail" accept="image/*" onchange="previewImage(this, 'add-image-preview')">
                        <div id="add-image-preview" class="mt-2"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Trạng thái phát hành</label>
                        <select class="form-select" name="status" id="add-status">
                            <option value="1">✓ Đang hoạt động</option>
                            <option value="0">✗ Ngừng hoạt động</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Hủy</button>
                    <button type="submit" class="btn btn-primary-custom"><i class="fas fa-save me-1"></i>Lưu danh mục</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Chỉnh sửa thông tin danh mục</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="editCategoryForm" action="${pageContext.request.contextPath}/admin/categories?action=update" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="id" id="edit-id">

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="name" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mô tả danh mục</label>
                        <textarea class="form-control" name="description" id="edit-description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <div class="current-image" id="current-image-container">
                            <p class="mb-1 small fw-bold">Ảnh hiện tại trên hệ thống:</p>
                            <img id="current-thumbnail-preview" src="" alt="Current Thumbnail" style="max-height:80px; border-radius:8px;">
                        </div>
                        <label class="form-label fw-bold mt-2">Thay đổi ảnh mới</label>
                        <input type="file" class="form-control" name="thumbnail" id="edit-thumbnail" accept="image/*" onchange="previewImage(this, 'edit-image-preview')">
                        <div id="edit-image-preview" class="mt-2"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Trạng thái hoạt động</label>
                        <select class="form-select" name="status" id="edit-status">
                            <option value="1">✓ Đang hoạt động</option>
                            <option value="0">✗ Ngừng hoạt động</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Đóng</button>
                    <button type="submit" class="btn btn-primary-custom"><i class="fas fa-save me-1"></i>Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_category.js"></script>
</body>
</html>