<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý danh mục</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_category.css">
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
            <h1 class="page-title"><i class="fas fa-tags"></i> Quản lý danh mục</h1>
            <button class="btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                <i class="fas fa-plus"></i> Thêm danh mục
            </button>
        </div>

        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-total"></div>
                <div class="stat-value">${totalCategories != null ? totalCategories : 0}</div>
                <div class="stat-label">Tổng danh mục</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-active"></div>
                <div class="stat-value">${activeCategories != null ? activeCategories : 0}</div>
                <div class="stat-label">Đang hoạt động</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-blocked"></div>
                <div class="stat-value">${inactiveCategories != null ? inactiveCategories : 0}</div>
                <div class="stat-label">Ngừng hoạt động</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-new"></div>
                <div class="stat-value">${totalProducts != null ? totalProducts : 0}</div>
                <div class="stat-label">Tổng sản phẩm</div>
            </div>
        </div>

        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Tìm theo tên hoặc mô tả danh mục..."
                       value="${searchKeyword}">
            </div>
            <select id="filterStatus" class="filter-select">
                <option value="-1" ${statusFilter == -1 ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="1"  ${statusFilter == 1  ? 'selected' : ''}>Đang hoạt động</option>
                <option value="0"  ${statusFilter == 0  ? 'selected' : ''}>Ngừng hoạt động</option>
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
                    Danh sách danh mục
                </div>
                <div class="page-meta">
                    <i class="fas fa-file-alt"></i>
                    Tổng <strong>&nbsp;${totalCategories != null ? totalCategories : 0}&nbsp;</strong> danh mục
                </div>
            </div>

            <div class="table-responsive">
                <table class="data-table" id="categoryTable">
                    <colgroup>
                        <col class="col-no">
                        <col class="col-thumb">
                        <col class="col-name">
                        <col class="col-products">
                        <col class="col-status">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Hình ảnh</th>
                        <th>Tên &amp; Mô tả</th>
                        <th style="text-align:center">Sản phẩm</th>
                        <th style="text-align:center">Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty categories}">
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="fas fa-folder-open"></i></div>
                                        <h4>Không tìm thấy danh mục nào</h4>
                                        <p>Thử thay đổi từ khoá hoặc thêm danh mục mới</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cat" items="${categories}" varStatus="st">
                                <tr data-status="${cat.status == 1 ? 'active' : 'inactive'}">
                                    <td><span class="row-num">${st.index + 1}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cat.thumbnail}">
                                                <img src="${fn:startsWith(cat.thumbnail,'http') ? cat.thumbnail : pageContext.request.contextPath.concat('/').concat(cat.thumbnail)}"
                                                     class="thumbnail-img" alt="${cat.name}"
                                                     onerror="this.onerror=null;this.parentNode.innerHTML='<div class=\'thumb-placeholder\'><i class=\'fas fa-image\'></i></div>'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="thumb-placeholder"><i class="fas fa-image"></i></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="category-name">${cat.name}</div>
                                        <div class="category-desc">${not empty cat.description ? cat.description : 'Không có mô tả'}</div>
                                    </td>
                                    <td style="text-align:center">
                                        <span class="product-badge">${cat.productCount != null ? cat.productCount : 0}</span>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${cat.status == 1}">
                                                <span class="status-badge status-active"><i class="fas fa-circle"></i> Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive"><i class="fas fa-circle"></i> Ngừng bán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <button class="action-btn action-btn-edit btn-edit"
                                                    data-bs-toggle="modal" data-bs-target="#editCategoryModal"
                                                    data-id="${cat.id}"
                                                    data-name="${cat.name}"
                                                    data-description="${cat.description}"
                                                    data-thumbnail="${cat.thumbnail}"
                                                    data-status="${cat.status}"
                                                    title="Chỉnh sửa">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <button class="action-btn action-btn-delete btn-delete"
                                                    data-id="${cat.id}"
                                                    data-name="${cat.name}"
                                                    data-product-count="${cat.productCount != null ? cat.productCount : 0}"
                                                    title="Xoá danh mục">
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
                        <c:when test="${not empty categories}">
                            Hiển thị <strong>${fn:length(categories)}</strong>
                            trong <strong>${totalCategories != null ? totalCategories : 0}</strong> danh mục
                        </c:when>
                        <c:otherwise>Không có dữ liệu phù hợp</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

    </main>
</div>

<!-- Modal Thêm danh mục -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle"></i> Thêm danh mục mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addCategoryForm" action="${pageContext.request.contextPath}/admin/categories?action=add"
                  method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục <span class="req">*</span></label>
                        <input type="text" class="form-control" name="name" id="add-name"
                               placeholder="VD: Bánh kem sinh nhật, Bánh mì Pháp..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả danh mục</label>
                        <textarea class="form-control" name="description" id="add-description"
                                  rows="3" placeholder="Thông tin mô tả danh mục..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Hình ảnh hiển thị</label>
                        <input type="file" class="form-control" name="thumbnail" id="add-thumbnail"
                               accept="image/*" onchange="previewImage(this, 'add-image-preview')">
                        <div id="add-image-preview" class="mt-2"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status" id="add-status">
                            <option value="1">Đang hoạt động</option>
                            <option value="0">Ngừng hoạt động</option>
                        </select>
                    </div>
                    <div class="form-hint">
                        <i class="fas fa-info-circle"></i>
                        Tên danh mục là bắt buộc. Hình ảnh sẽ hiển thị trong giao diện cửa hàng.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Lưu danh mục</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Sửa danh mục -->
<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-pen"></i> Chỉnh sửa danh mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editCategoryForm" action="${pageContext.request.contextPath}/admin/categories?action=update"
                  method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục <span class="req">*</span></label>
                        <input type="text" class="form-control" name="name" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả danh mục</label>
                        <textarea class="form-control" name="description" id="edit-description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <div id="current-image-container" style="display:none; margin-bottom:8px">
                            <p class="form-label" style="margin-bottom:4px">Ảnh hiện tại:</p>
                            <img id="current-thumbnail-preview" src="" alt="Ảnh hiện tại"
                                 style="max-height:72px; border-radius:8px; border:2px solid var(--accent-light);">
                        </div>
                        <label class="form-label">Thay đổi ảnh mới</label>
                        <input type="file" class="form-control" name="thumbnail" id="edit-thumbnail"
                               accept="image/*" onchange="previewImage(this, 'edit-image-preview')">
                        <div id="edit-image-preview" class="mt-2"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status" id="edit-status">
                            <option value="1">Đang hoạt động</option>
                            <option value="0">Ngừng hoạt động</option>
                        </select>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_category.js"></script>
</body>
</html>
