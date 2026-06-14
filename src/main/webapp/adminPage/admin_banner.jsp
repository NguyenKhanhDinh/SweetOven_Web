<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý Banner</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_banner.css">
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
            <h1 class="page-title"><i class="fas fa-images"></i> Quản lý Banner</h1>
            <button class="btn-primary" data-bs-toggle="modal" data-bs-target="#addBannerModal">
                <i class="fas fa-plus"></i> Thêm banner
            </button>
        </div>

        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-total"></div>
                <div class="stat-value">${totalBanners}</div>
                <div class="stat-label">Tổng banner</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-active"></div>
                <div class="stat-value">${activeBanners}</div>
                <div class="stat-label">Đang hoạt động</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-inactive"></div>
                <div class="stat-value">${inactiveBanners}</div>
                <div class="stat-label">Ngừng hoạt động</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-new"></div>
                <div class="stat-value">${newBannersThisMonth}</div>
                <div class="stat-label">Mới tháng này</div>
            </div>
        </div>

        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Tìm theo tiêu đề, mô tả..."
                       value="${keyword}">
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
                    Danh sách banner
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
                        <col class="col-image">
                        <col class="col-title">
                        <col class="col-desc">
                        <col class="col-status">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Hình ảnh</th>
                            <th>Tiêu đề</th>
                            <th class="hide-mobile">Mô tả</th>
                            <th style="text-align:center">Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty banners}">
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="fas fa-images"></i></div>
                                        <h4>Không tìm thấy banner nào</h4>
                                        <p>Thử thay đổi từ khoá hoặc điều chỉnh bộ lọc</p>
                                    </div>
                                  </td>
                              </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${banners}" varStatus="st">
                                <tr class="${!b.active ? 'row-inactive' : ''}">
                                    <td><span class="row-num">${(currentPage-1)*pageSize + st.index + 1}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty b.imageUrl}">
                                                <img src="${b.imageUrl}" class="banner-thumb" alt="banner"
                                                     onerror="this.src='${pageContext.request.contextPath}/assets/picture/placeholder.png'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="banner-thumb-placeholder">
                                                    <i class="fas fa-image"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="title-cell">
                                            <div class="banner-title">${b.title}</div>
                                        </div>
                                    </td>
                                    <td class="hide-mobile">
                                        <div class="desc-cell">
                                            <c:choose>
                                                <c:when test="${not empty b.description}">
                                                    ${fn:substring(b.description, 0, 60)}${fn:length(b.description) > 60 ? '...' : ''}
                                                </c:when>
                                                <c:otherwise><span style="color:#ccc">—</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td style="text-align:center">
                                        <c:choose>
                                            <c:when test="${b.active}">
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i> Đang hoạt động
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-pause-circle"></i> Ngừng hoạt động
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <button class="action-btn action-btn-view"
                                                    onclick="openViewModal(${b.id})" title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-btn action-btn-edit"
                                                    onclick="openEditModal(${b.id})" title="Chỉnh sửa">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${b.active}">
                                                    <button class="action-btn action-btn-deactivate"
                                                            onclick="updateStatusAjax(${b.id}, true)"
                                                            title="Ngừng hoạt động">
                                                        <i class="fas fa-pause"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="action-btn action-btn-activate"
                                                            onclick="updateStatusAjax(${b.id}, false)"
                                                            title="Kích hoạt">
                                                        <i class="fas fa-play"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <button class="action-btn action-btn-delete"
                                                    onclick="confirmDelete(${b.id},'${b.title}')"
                                                    title="Xóa banner">
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
                        <c:when test="${totalBannersCount > 0}">
                            Hiển thị <strong>${(currentPage-1)*pageSize + 1}</strong>–<strong>${(currentPage*pageSize < totalBannersCount) ? currentPage*pageSize : totalBannersCount}</strong>
                            trong <strong>${totalBannersCount}</strong> banner
                        </c:when>
                        <c:otherwise>Không có dữ liệu phù hợp</c:otherwise>
                    </c:choose>
                </span>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&status=${statusFilter}&page=${currentPage-1}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        <c:if test="${currentPage > 3}">
                            <li class="page-item">
                                <a class="page-link" href="?keyword=${keyword}&status=${statusFilter}&page=1">1</a>
                            </li>
                            <c:if test="${currentPage > 4}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p >= currentPage-2 && p <= currentPage+2}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?keyword=${keyword}&status=${statusFilter}&page=${p}">${p}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages-2}">
                            <c:if test="${currentPage < totalPages-3}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link" href="?keyword=${keyword}&status=${statusFilter}&page=${totalPages}">${totalPages}</a>
                            </li>
                        </c:if>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&status=${statusFilter}&page=${currentPage+1}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </div>

    </main>
</div>

<!-- Modal Thêm Banner - ĐÃ SỬA DÙNG RADIO BUTTON -->
<div class="modal fade" id="addBannerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle"></i> Thêm banner mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addBannerForm" method="post" action="${pageContext.request.contextPath}/admin/banners" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Tiêu đề banner <span class="req">*</span></label>
                            <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề banner" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" class="form-control" rows="3" placeholder="Mô tả ngắn về banner"></textarea>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Hình ảnh banner <span class="req">*</span></label>
                            <input type="file" name="imageFile" id="addImageFile" class="form-control" accept="image/*" required onchange="previewImage(this, 'addPreview', 'addPreviewBox')">
                            <div id="addPreviewBox" class="preview-box" style="display: none;">
                                <img id="addPreview" src="" alt="Preview">
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-info-circle"></i>
                                Hỗ trợ định dạng: JPG, PNG, GIF. Kích thước tối đa 5MB.
                            </div>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Trạng thái</label>
                            <div class="mt-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="isActive" id="addActive" value="on" checked>
                                    <label class="form-check-label" for="addActive">
                                        <i class="fas fa-check-circle text-success"></i> Kích hoạt
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="isActive" id="addInactive" value="off">
                                    <label class="form-check-label" for="addInactive">
                                        <i class="fas fa-pause-circle text-danger"></i> Không kích hoạt
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Thêm banner</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Sửa Banner - ĐÃ SỬA DÙNG RADIO BUTTON -->
<div class="modal fade" id="editBannerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-edit"></i> Chỉnh sửa banner</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editBannerForm" method="post" action="${pageContext.request.contextPath}/admin/banners" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">
                <input type="hidden" name="existingImageUrl" id="editExistingImageUrl">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Tiêu đề banner <span class="req">*</span></label>
                            <input type="text" name="title" id="editTitle" class="form-control" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" id="editDescription" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Hình ảnh banner</label>
                            <input type="file" name="imageFile" id="editImageFile" class="form-control" accept="image/*" onchange="previewImage(this, 'editPreview', 'editPreviewBox')">
                            <div id="editPreviewBox" class="preview-box" style="display: none;">
                                <img id="editPreview" src="" alt="Preview">
                            </div>
                            <div class="form-hint">
                                <i class="fas fa-info-circle"></i>
                                Để trống nếu không muốn thay đổi ảnh.
                            </div>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">Trạng thái</label>
                            <div class="mt-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="isActive" id="editActive" value="on">
                                    <label class="form-check-label" for="editActive">
                                        <i class="fas fa-check-circle text-success"></i> Kích hoạt
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="isActive" id="editInactive" value="off">
                                    <label class="form-check-label" for="editInactive">
                                        <i class="fas fa-pause-circle text-danger"></i> Không kích hoạt
                                    </label>
                                </div>
                            </div>
                        </div>
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

<!-- Modal Xem Chi Tiết Banner -->
<div class="modal fade" id="viewBannerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-info-circle"></i> Chi tiết banner</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="detail-header">
                    <div id="viewImageWrap"></div>
                    <div class="detail-fullname" id="viewTitle"></div>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-align-left"></i> Mô tả</span>
                    <span class="detail-val" id="viewDescription"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-toggle-on"></i> Trạng thái</span>
                    <span class="detail-val" id="viewStatus"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-calendar-alt"></i> Ngày tạo</span>
                    <span class="detail-val" id="viewCreatedAt"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl"><i class="fas fa-calendar-edit"></i> Cập nhật lần cuối</span>
                    <span class="detail-val" id="viewUpdatedAt"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="autoOpenModal" value="${autoOpenModal}">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_banner.js"></script>
</body>
</html>