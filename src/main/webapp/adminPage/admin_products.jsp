<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý sản phẩm</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_product.css">
    <script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</head>
<body>
<div class="admin-wrapper">

    <%@ include file="/components/sidebar.jsp" %>

    <main class="main-content">

        <c:if test="${not empty success}">
            <div id="alertFloating" class="alert-floating alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div id="alertFloating" class="alert-floating alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <div class="page-header">
            <h1 class="page-title"><i class="fas fa-box-open"></i> Quản lý sản phẩm</h1>
            <button class="btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                <i class="fas fa-plus"></i> Thêm sản phẩm
            </button>
        </div>

        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-total"></div>
                <div class="stat-value">${statTotalProducts}</div>
                <div class="stat-label">Tổng sản phẩm</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-active"></div>
                <div class="stat-value">${availableProducts}</div>
                <div class="stat-label">Còn hàng</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-blocked"></div>
                <div class="stat-value">${outOfStockProducts}</div>
                <div class="stat-label">Hết hàng</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-featured"></div>
                <div class="stat-value">${featuredProducts}</div>
                <div class="stat-label">Nổi bật</div>
            </div>
        </div>

        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchKeyword"
                       placeholder="Tên hoặc mã sản phẩm..."
                       value="${searchKeyword}">
            </div>
            <select id="filterCategory" class="filter-select">
                <option value="">Tất cả danh mục</option>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.id}" ${filterCategoryId == c.id ? 'selected' : ''}>${c.name}</option>
                </c:forEach>
            </select>
            <select id="filterStatus" class="filter-select">
                <option value="">Tất cả trạng thái</option>
                <option value="1" ${filterStatus == '1' ? 'selected' : ''}>Còn hàng</option>
                <option value="0" ${filterStatus == '0' ? 'selected' : ''}>Hết hàng</option>
            </select>
            <select id="filterFeatured" class="filter-select">
                <option value="">Tất cả sản phẩm</option>
                <option value="true" ${filterFeatured == 'true' ? 'selected' : ''}>Sản phẩm nổi bật</option>
                <option value="false" ${filterFeatured == 'false' ? 'selected' : ''}>Không nổi bật</option>
            </select>
            <select id="sortOrder" class="filter-select">
                <option value="">Sắp xếp mặc định</option>
                <option value="stock_asc"  ${sortOrder == 'stock_asc'  ? 'selected' : ''}>Tồn kho: thấp → cao</option>
                <option value="stock_desc" ${sortOrder == 'stock_desc' ? 'selected' : ''}>Tồn kho: cao → thấp</option>
                <option value="price_asc"  ${sortOrder == 'price_asc'  ? 'selected' : ''}>Giá: thấp → cao</option>
                <option value="price_desc" ${sortOrder == 'price_desc' ? 'selected' : ''}>Giá: cao → thấp</option>
                <option value="name_asc"   ${sortOrder == 'name_asc'   ? 'selected' : ''}>Tên: A → Z</option>
                <option value="name_desc"  ${sortOrder == 'name_desc'  ? 'selected' : ''}>Tên: Z → A</option>
            </select>
            <button class="btn-apply-filter" onclick="applyFilters()">
                <i class="fas fa-filter"></i> Áp dụng
            </button>
            <button class="btn-reset-filter" onclick="resetFilters()">
                <i class="fas fa-undo"></i> Đặt lại
            </button>
        </div>

        <div class="active-filters-bar" id="activeFiltersBar">
            <span class="active-filters-label"><i class="fas fa-filter"></i> Đang lọc:</span>
            <div class="active-filters" id="activeFiltersList"></div>
            <button class="btn-clear-all-filters" id="clearAllFilters" onclick="resetFilters()">
                <i class="fas fa-xmark"></i> Xoá tất cả
            </button>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">
                    <i class="fas fa-list-ul"></i>
                    Danh sách sản phẩm
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
                        <col class="col-img">
                        <col class="col-code">
                        <col class="col-name">
                        <col class="col-cat">
                        <col class="col-price">
                        <col class="col-discount">
                        <col class="col-stock">
                        <col class="col-status">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>Ảnh</th>
                        <th class="hide-desktop">Mã SP</th>
                        <th>Tên sản phẩm</th>
                        <th class="hide-desktop">Danh mục</th>
                        <th class="hide-mobile">Giá gốc</th>
                        <th class="hide-mobile">Giá KM</th>
                        <th>Tồn kho</th>
                        <th style="text-align:center">Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty products}">
                            <tr>
                                <td colspan="9">
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="fas fa-box-open"></i></div>
                                        <h4>Chưa có sản phẩm nào</h4>
                                        <p>Hãy thêm sản phẩm đầu tiên cho cửa hàng</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${products}" var="p">
                                <c:set var="rowClass" value=""/>
                                <c:if test="${p.stockQuantity <= 5 && p.stockQuantity > 0}">
                                    <c:set var="rowClass" value="row-low-stock"/>
                                </c:if>
                                <c:if test="${p.stockQuantity == 0}">
                                    <c:set var="rowClass" value="row-out-of-stock"/>
                                </c:if>
                                <tr class="${rowClass}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.image && (p.image.startsWith('http://') || p.image.startsWith('https://'))}">
                                                <img src="${p.image}" class="product-img"
                                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                                <div class="product-img-placeholder" style="display:none"><i class="fas fa-cookie-bite"></i></div>
                                            </c:when>
                                            <c:when test="${not empty p.image}">
                                                <img src="${pageContext.request.contextPath}${p.image}" class="product-img"
                                                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                                <div class="product-img-placeholder" style="display:none"><i class="fas fa-cookie-bite"></i></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="product-img-placeholder"><i class="fas fa-cookie-bite"></i></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="hide-desktop"><span class="product-code">${p.productCode}</span></td>
                                    <td>
                                        <div class="product-name">${p.name}</div>
                                        <c:if test="${p.featured}">
                                            <span class="badge-featured"><i class="fas fa-star"></i> Nổi bật</span>
                                        </c:if>
                                    </td>
                                    <td class="hide-desktop">
                                        <c:forEach items="${categories}" var="cat">
                                            <c:if test="${cat.id == p.categoryId}">
                                                <span class="category-tag">${cat.name}</span>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td class="hide-mobile">
                                        <span class="price-original">
                                            <fmt:formatNumber value="${p.originalPrice}" type="number" groupingUsed="true"/>đ
                                        </span>
                                    </td>
                                    <td class="hide-mobile">
                                        <c:choose>
                                            <c:when test="${p.discountPrice != null && p.discountPrice > 0}">
                                                <span class="price-discount">
                                                    <fmt:formatNumber value="${p.discountPrice}" type="number" groupingUsed="true"/>đ
                                                </span>
                                                <c:set var="pct" value="${((p.originalPrice - p.discountPrice) / p.originalPrice) * 100}"/>
                                                <small class="discount-pct">-<fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%</small>
                                            </c:when>
                                            <c:otherwise><span style="color:#ccc">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="stock-value ${p.stockQuantity == 0 ? 'stock-zero' : p.stockQuantity <= 5 ? 'stock-low' : 'stock-ok'}">
                                            ${p.stockQuantity}
                                            <c:if test="${p.stockQuantity <= 5 && p.stockQuantity > 0}">
                                                <i class="fas fa-exclamation-triangle" title="Sắp hết hàng!"></i>
                                            </c:if>
                                        </span>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${p.status == 1 && p.stockQuantity > 0}">
                                                <span class="status-badge status-available">Còn hàng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-out">Hết hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <button class="action-btn action-btn-edit"
                                                    onclick="openEditModal(${p.id})" title="Chỉnh sửa">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <button class="action-btn action-btn-delete"
                                                    onclick="confirmDelete(${p.id}, '${p.name}')" title="Xoá">
                                                <i class="fas fa-trash"></i>
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

            <div class="table-footer">
                <span class="result-info">
                    <c:choose>
                        <c:when test="${totalProducts > 0}">
                            Hiển thị <strong>${(currentPage-1)*pageSize + 1}</strong>–<strong>${(currentPage*pageSize < totalProducts) ? currentPage*pageSize : totalProducts}</strong>
                            trong <strong>${totalProducts}</strong> sản phẩm
                        </c:when>
                        <c:otherwise>Không có dữ liệu phù hợp</c:otherwise>
                    </c:choose>
                </span>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="#" onclick="goToPage(${currentPage - 1})">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        <c:if test="${currentPage > 3}">
                            <li class="page-item"><a class="page-link" href="#" onclick="goToPage(1)">1</a></li>
                            <c:if test="${currentPage > 4}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="pg">
                            <c:if test="${pg >= currentPage-2 && pg <= currentPage+2}">
                                <li class="page-item ${pg == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="#" onclick="goToPage(${pg})">${pg}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages-2}">
                            <c:if test="${currentPage < totalPages-3}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                            <li class="page-item"><a class="page-link" href="#" onclick="goToPage(${totalPages})">${totalPages}</a></li>
                        </c:if>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="#" onclick="goToPage(${currentPage + 1})">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </div>

    </main>
</div>

<div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus"></i> Thêm sản phẩm mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addProductForm" action="${pageContext.request.contextPath}/admin/products"
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="form-section">
                        <h6 class="form-section-title"><i class="fas fa-info-circle me-2"></i>Thông tin cơ bản</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Mã sản phẩm</label>
                                <input type="text" class="form-control" name="productCode"
                                       readonly style="background:#f5f5f5;" value="(tự động sinh khi lưu)">
                                <small class="text-muted">Mã sẽ tự động sinh khi lưu</small>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên sản phẩm <span class="req">*</span></label>
                                <input type="text" class="form-control" name="name" required
                                       placeholder="VD: Bánh flan caramen">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Danh mục <span class="req">*</span></label>
                                <select class="form-select" name="categoryId" required>
                                    <option value="" selected disabled>-- Chọn danh mục --</option>
                                    <c:forEach items="${categories}" var="c">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giá gốc (VNĐ) <span class="req">*</span></label>
                                <input type="number" class="form-control" name="originalPrice"
                                       min="0" step="1000" required placeholder="VD: 50000">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giá khuyến mãi (VNĐ)</label>
                                <input type="number" class="form-control" name="discountPrice"
                                       min="0" step="1000" placeholder="Để trống nếu không có">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tồn kho <span class="req">*</span></label>
                                <input type="number" class="form-control" name="stockQuantity"
                                       min="0" value="0" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Trạng thái <span class="req">*</span></label>
                                <select class="form-select" name="status" required>
                                    <option value="1">Còn hàng</option>
                                    <option value="0">Hết hàng</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox"
                                           name="featured" id="addFeatured" value="true">
                                    <label class="form-check-label fw-bold" for="addFeatured">Sản phẩm nổi bật</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title"><i class="fas fa-image me-2"></i>Hình ảnh sản phẩm</h6>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Ảnh đại diện <span class="req">*</span></label>
                                <input type="file" class="form-control" name="imageFile" accept="image/*" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ảnh phụ 1</label>
                                <input type="file" class="form-control" name="imageFileSub1" accept="image/*">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ảnh phụ 2</label>
                                <input type="file" class="form-control" name="imageFileSub2" accept="image/*">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title"><i class="fas fa-align-left me-2"></i>Thông tin bổ sung</h6>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Mô tả sản phẩm</label>
                                <textarea class="form-control" name="description" rows="3"
                                          placeholder="Mô tả chi tiết về sản phẩm..."></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Thành phần</label>
                                <textarea class="form-control" name="ingredients" rows="2"
                                          placeholder="VD: Bột mì, trứng, đường, sữa..."></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Lưu sản phẩm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-pen"></i> Chỉnh sửa sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editProductForm" action="${pageContext.request.contextPath}/admin/products"
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div class="form-section">
                        <h6 class="form-section-title">Thông tin cơ bản</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Mã sản phẩm</label>
                                <input type="text" class="form-control" name="productCode"
                                       id="editProductCode" readonly style="background:#f5f5f5;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tên sản phẩm <span class="req">*</span></label>
                                <input type="text" class="form-control" name="name" id="editName" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Danh mục <span class="req">*</span></label>
                                <select class="form-select" name="categoryId" id="editCategoryId" required>
                                    <c:forEach items="${categories}" var="c">
                                        <option value="${c.id}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giá gốc (VNĐ) <span class="req">*</span></label>
                                <input type="number" class="form-control" name="originalPrice"
                                       id="editOriginalPrice" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giá khuyến mãi (VNĐ)</label>
                                <input type="number" class="form-control" name="discountPrice" id="editDiscountPrice">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tồn kho <span class="req">*</span></label>
                                <input type="number" class="form-control" name="stockQuantity"
                                       id="editStockQuantity" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Trạng thái <span class="req">*</span></label>
                                <select class="form-select" name="status" id="editStatus">
                                    <option value="1">Còn hàng</option>
                                    <option value="0">Hết hàng</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox"
                                           name="featured" id="editFeatured" value="true">
                                    <label class="form-check-label fw-bold" for="editFeatured">Sản phẩm nổi bật</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">Hình ảnh hiện tại</h6>
                        <div id="currentImagesContainer" class="d-flex flex-wrap gap-3 mb-3"></div>
                        <h6 class="form-section-title mt-3">Cập nhật ảnh mới</h6>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Ảnh đại diện mới</label>
                                <input type="file" class="form-control" name="imageFile" accept="image/*">
                                <small class="text-muted">Để trống nếu không muốn thay đổi</small>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ảnh phụ 1 mới</label>
                                <input type="file" class="form-control" name="imageFileSub1" accept="image/*">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ảnh phụ 2 mới</label>
                                <input type="file" class="form-control" name="imageFileSub2" accept="image/*">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">Thông tin bổ sung</h6>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Thành phần</label>
                                <textarea class="form-control" name="ingredients" id="editIngredients" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_product.js"></script>

<script>
    const af = document.getElementById('alertFloating');
    if (af) setTimeout(() => af.classList.add('hide'), 3500);
</script>
</body>
</html>
