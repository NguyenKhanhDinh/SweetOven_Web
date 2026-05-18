<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sweet Oven - Quản lý sản phẩm</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_product.css">

</head>

<body>
    <div class="container-fluid p-0">
        <div class="row g-0">
            <!-- Sidebar -->
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

            <!-- Main Content -->
            <div class="col main-content">
                <div class="admin-header d-flex justify-content-between align-items-center flex-wrap">
                    <div>
                        <h1 class="h3 mb-0 text-primary">QUẢN LÝ SẢN PHẨM</h1>
                        <p class="text-muted mb-0 mt-1"><i class="fas fa-database me-1"></i>Quản lý toàn bộ sản phẩm của cửa hàng</p>
                    </div>
                    <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                    </button>
                </div>

                <!-- Filter Card -->
                <div class="filter-card">
                    <div class="row align-items-end">
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-semibold"><i class="fas fa-search me-1"></i>Tìm kiếm</label>
                            <input type="text" id="searchKeyword" class="form-control" placeholder="Tên hoặc mã sản phẩm..." value="${searchKeyword}">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label fw-semibold"><i class="fas fa-list me-1"></i>Danh mục</label>
                            <select id="filterCategory" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.id}" ${filterCategoryId == c.id ? 'selected' : ''}>${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label fw-semibold"><i class="fas fa-chart-line me-1"></i>Trạng thái</label>
                            <select id="filterStatus" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="1" ${filterStatus == '1' ? 'selected' : ''}>Còn hàng</option>
                                <option value="0" ${filterStatus == '0' ? 'selected' : ''}>Hết hàng</option>
                            </select>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label fw-semibold"><i class="fas fa-star me-1"></i>Nổi bật</label>
                            <select id="filterFeatured" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="true" ${filterFeatured == 'true' ? 'selected' : ''}>Nổi bật</option>
                                <option value="false" ${filterFeatured == 'false' ? 'selected' : ''}>Không nổi bật</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-semibold"><i class="fas fa-sort me-1"></i>Sắp xếp</label>
                            <select id="sortOrder" class="form-select">
                                <option value="stock_asc" ${sortOrder == 'stock_asc' ? 'selected' : ''}>📦 Tồn kho (Thấp → Cao)</option>
                                <option value="stock_desc" ${sortOrder == 'stock_desc' ? 'selected' : ''}>📦 Tồn kho (Cao → Thấp)</option>
                                <option value="price_asc" ${sortOrder == 'price_asc' ? 'selected' : ''}>💰 Giá (Thấp → Cao)</option>
                                <option value="price_desc" ${sortOrder == 'price_desc' ? 'selected' : ''}>💰 Giá (Cao → Thấp)</option>
                                <option value="name_asc" ${sortOrder == 'name_asc' ? 'selected' : ''}>🔤 Tên (A → Z)</option>
                                <option value="name_desc" ${sortOrder == 'name_desc' ? 'selected' : ''}>🔤 Tên (Z → A)</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <button class="btn btn-primary-custom btn-sm" onclick="applyFilters()">
                                <i class="fas fa-filter me-1"></i>Áp dụng bộ lọc
                            </button>
                            <button class="btn btn-secondary btn-sm ms-2" onclick="resetFilters()">
                                <i class="fas fa-undo me-1"></i>Đặt lại
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Products Table -->
                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Hình ảnh</th>
                                    <th>Mã SP</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Danh mục</th>
                                    <th>Giá gốc</th>
                                    <th>Giá KM</th>
                                    <th>Tồn kho</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="10" class="text-center py-5">
                                            <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                            <p class="text-muted mb-0">Chưa có sản phẩm nào. Hãy thêm sản phẩm mới!</p>
                                        </td>
                                    </tr>
                                </c:if>

                                <c:forEach items="${products}" var="p">
                                    <c:set var="stockClass" value="" />
                                    <c:if test="${p.stockQuantity <= 5 && p.stockQuantity > 0}">
                                        <c:set var="stockClass" value="stock-low" />
                                    </c:if>
                                    <c:if test="${p.stockQuantity == 0}">
                                        <c:set var="stockClass" value="stock-critical" />
                                    </c:if>
                                    <tr class="${stockClass}">
                                        <td class="id-col">${p.id}</td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}${p.image != null ? p.image : '/assets/images/default-product.png'}"
                                                 class="product-img"
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/default-product.png'">
                                        </td>
                                        <td><span class="fw-semibold text-primary">${p.productCode}</span></td>
                                        <td>
                                            <div class="fw-bold">${p.name}</div>
                                            <c:if test="${p.featured}">
                                                <span class="badge-featured"><i class="fas fa-star me-1"></i>Nổi bật</span>
                                            </c:if>
                                         </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.categoryId == 1}">🍰 Bánh ngọt</c:when>
                                                <c:when test="${p.categoryId == 2}">🥨 Bánh mặn</c:when>
                                                <c:when test="${p.categoryId == 3}">🔥 Đồ nướng</c:when>
                                                <c:when test="${p.categoryId == 4}">📦 Combo</c:when>
                                                <c:otherwise>📁 Khác</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${p.originalPrice}" type="number" groupingUsed="true" />đ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.discountPrice != null && p.discountPrice > 0}">
                                                    <span class="discount-price"><fmt:formatNumber value="${p.discountPrice}" type="number" groupingUsed="true" />đ</span>
                                                    <c:set var="discountPercent" value="${((p.originalPrice - p.discountPrice) / p.originalPrice) * 100}" />
                                                    <small class="text-danger d-block">-${Math.round(discountPercent)}%</small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="fw-bold ${p.stockQuantity <= 5 ? 'text-danger' : 'text-success'}">
                                            ${p.stockQuantity}
                                            <c:if test="${p.stockQuantity <= 5 && p.stockQuantity > 0}">
                                                <i class="fas fa-exclamation-triangle ms-1" title="Sắp hết hàng!"></i>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 1 && p.stockQuantity > 0}">
                                                    <span class="badge-available text-white">Còn hàng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-unavailable text-white">Hết hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1" onclick="openEditModal(${p.id})" title="Sửa">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" onclick="confirmDelete(${p.id}, '${p.name}')" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-between align-items-center p-3 border-top">
                        <div class="text-muted small">
                            <c:choose>
                                <c:when test="${totalProducts == 0}">Không có sản phẩm nào</c:when>
                                <c:otherwise>
                                    Hiển thị ${(currentPage - 1) * pageSize + 1}-${(currentPage * pageSize) > totalProducts ? totalProducts : (currentPage * pageSize)} trên ${totalProducts} sản phẩm
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${totalProducts > 0}">
                            <nav>
                                <ul class="pagination pagination-sm mb-0" id="pagination">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="#" onclick="goToPage(1)"><i class="fas fa-angle-double-left"></i></a>
                                    </li>
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="#" onclick="goToPage(${currentPage - 1})"><i class="fas fa-angle-left"></i></a>
                                    </li>
                                    <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" end="${currentPage + 2 <= totalPages ? currentPage + 2 : totalPages}">
                                        <c:if test="${i >= 1 && i <= totalPages}">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="#" onclick="goToPage(${currentPage + 1})"><i class="fas fa-angle-right"></i></a>
                                    </li>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="#" onclick="goToPage(${totalPages})"><i class="fas fa-angle-double-right"></i></a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Thêm sản phẩm mới</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="addProductForm" action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="form-section">
                            <h6 class="form-section-title"><i class="fas fa-info-circle me-2"></i>Thông tin cơ bản</h6>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Mã sản phẩm (SKU)</label>
                                    <input type="text" class="form-control" name="productCode" id="addProductCode" readonly style="background:#f5f5f5;">
                                    <small class="text-muted">Mã sẽ tự động sinh theo danh mục</small>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Tên sản phẩm</label>
                                    <input type="text" class="form-control" name="name" id="addProductName" required placeholder="VD: Bánh flan caramen">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Danh mục</label>
                                    <select class="form-select" name="categoryId" id="addCategoryId" required onchange="generateProductCode()">
                                        <option value="" selected disabled>-- Chọn danh mục --</option>
                                        <c:forEach items="${categories}" var="c">
                                            <option value="${c.id}" data-code="${c.name}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Giá gốc (VNĐ)</label>
                                    <input type="number" class="form-control" name="originalPrice" id="addOriginalPrice" min="0" step="1000" required placeholder="VD: 50000">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Giá khuyến mãi (VNĐ)</label>
                                    <input type="number" class="form-control" name="discountPrice" id="addDiscountPrice" min="0" step="1000" placeholder="Để trống nếu không có">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Tồn kho</label>
                                    <input type="number" class="form-control" name="stockQuantity" id="addStockQuantity" min="0" value="0" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Trạng thái</label>
                                    <select class="form-select" name="status" required>
                                        <option value="1">Còn hàng</option>
                                        <option value="0">Hết hàng</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3 d-flex align-items-center">
                                    <div class="form-check form-switch mt-4">
                                        <input class="form-check-input" type="checkbox" name="featured" id="addFeatured" value="true">
                                        <label class="form-check-label fw-bold" for="addFeatured">⭐ Sản phẩm nổi bật</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h6 class="form-section-title"><i class="fas fa-image me-2"></i>Hình ảnh sản phẩm</h6>
                            <div class="bg-light p-3 rounded">
                                <div class="mb-3">
                                    <label class="form-label required">Ảnh đại diện</label>
                                    <input type="file" class="form-control" name="imageFile" accept="image/*" required>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Ảnh phụ 1</label>
                                        <input type="file" class="form-control" name="imageFileSub1" accept="image/*">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Ảnh phụ 2</label>
                                        <input type="file" class="form-control" name="imageFileSub2" accept="image/*">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h6 class="form-section-title"><i class="fas fa-align-left me-2"></i>Thông tin bổ sung</h6>
                            <div class="mb-3">
                                <label class="form-label">Mô tả sản phẩm</label>
                                <textarea class="form-control" name="description" rows="3" placeholder="Mô tả chi tiết về sản phẩm..."></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thành phần</label>
                                <textarea class="form-control" name="ingredients" rows="2" placeholder="VD: Bột mì, trứng, đường, sữa..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary-custom px-4">Lưu sản phẩm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Product Modal -->
    <div class="modal fade" id="editProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Chỉnh sửa sản phẩm</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="editProductForm" action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="editId">
                    <div class="modal-body">
                        <div class="form-section">
                            <h6 class="form-section-title">Thông tin cơ bản</h6>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Mã sản phẩm</label>
                                    <input type="text" class="form-control" name="productCode" id="editProductCode" readonly style="background:#f5f5f5;">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Tên sản phẩm</label>
                                    <input type="text" class="form-control" name="name" id="editName" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Danh mục</label>
                                    <select class="form-select" name="categoryId" id="editCategoryId" required>
                                        <c:forEach items="${categories}" var="c">
                                            <option value="${c.id}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Giá gốc (VNĐ)</label>
                                    <input type="number" class="form-control" name="originalPrice" id="editOriginalPrice" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Giá khuyến mãi (VNĐ)</label>
                                    <input type="number" class="form-control" name="discountPrice" id="editDiscountPrice">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Tồn kho</label>
                                    <input type="number" class="form-control" name="stockQuantity" id="editStockQuantity" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label required">Trạng thái</label>
                                    <select class="form-select" name="status" id="editStatus">
                                        <option value="1">Còn hàng</option>
                                        <option value="0">Hết hàng</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3 d-flex align-items-center">
                                    <div class="form-check form-switch mt-4">
                                        <input class="form-check-input" type="checkbox" name="featured" id="editFeatured" value="true">
                                        <label class="form-check-label fw-bold" for="editFeatured">⭐ Sản phẩm nổi bật</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h6 class="form-section-title">Hình ảnh hiện tại</h6>
                            <div id="currentImagesContainer" class="d-flex flex-wrap gap-3 mb-3"></div>
                            <h6 class="form-section-title mt-3">Cập nhật ảnh mới</h6>
                            <div class="bg-light p-3 rounded">
                                <div class="mb-3">
                                    <label class="form-label">Ảnh đại diện mới</label>
                                    <input type="file" class="form-control" name="imageFile" accept="image/*">
                                    <small class="text-muted">Để trống nếu không muốn thay đổi</small>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Ảnh phụ 1 mới</label>
                                        <input type="file" class="form-control" name="imageFileSub1" accept="image/*">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Ảnh phụ 2 mới</label>
                                        <input type="file" class="form-control" name="imageFileSub2" accept="image/*">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <h6 class="form-section-title">Thông tin bổ sung</h6>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thành phần</label>
                                <textarea class="form-control" name="ingredients" id="editIngredients" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary-custom px-4">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin_product.js"></script>


</body>

</html>