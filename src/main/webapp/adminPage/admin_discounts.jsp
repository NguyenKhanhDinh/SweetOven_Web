<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý khuyến mãi</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_discount.css">
    <script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</head>
<body>
<div class="admin-wrapper">

    <%@ include file="/components/sidebar.jsp" %>

    <main class="main-content">

        <%-- Toast thông báo --%>
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

        <%-- ── Header ─────────────────────────────────────────────────────── --%>
        <div class="page-header">
            <h1 class="page-title"><i class="fas fa-tags"></i> Quản lý khuyến mãi</h1>
            <button class="btn-primary" data-bs-toggle="modal" data-bs-target="#addDiscountModal">
                <i class="fas fa-plus"></i> Thêm khuyến mãi
            </button>
        </div>

        <%-- ── Thống kê ───────────────────────────────────────────────────── --%>
        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-discount-total"></div>
                <div class="stat-value">${totalDiscounts}</div>
                <div class="stat-label">Tổng khuyến mãi</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-discount-active"></div>
                <div class="stat-value">${activeDiscounts}</div>
                <div class="stat-label">Đang hiệu lực</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-discount-expired"></div>
                <div class="stat-value">${expiredDiscounts}</div>
                <div class="stat-label">Đã hết hạn</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-discount-percent"></div>
                <div class="stat-value">${percentDiscounts}</div>
                <div class="stat-label">Giảm theo %</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-discount-fixed"></div>
                <div class="stat-value">${fixedDiscounts}</div>
                <div class="stat-label">Giảm cố định</div>
            </div>
        </div>

        <%-- ── Bộ lọc ─────────────────────────────────────────────────────── --%>
        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Tìm theo mã hoặc mô tả..."
                       value="${keyword}">
            </div>
            <select id="filterType" class="filter-select">
                <option value="-1" ${typeFilter == -1 ? 'selected' : ''}>Tất cả loại</option>
                <option value="1"  ${typeFilter == 1  ? 'selected' : ''}>Phần trăm (%)</option>
                <option value="2"  ${typeFilter == 2  ? 'selected' : ''}>Cố định (VNĐ)</option>
            </select>
            <select id="filterStatus" class="filter-select">
                <option value="-1"        ${statusFilter == '-1'        ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="ACTIVE"    ${statusFilter == 'ACTIVE'    ? 'selected' : ''}>Đang hiệu lực</option>
                <option value="UPCOMING"  ${statusFilter == 'UPCOMING'  ? 'selected' : ''}>Chưa bắt đầu</option>
                <option value="EXPIRED"   ${statusFilter == 'EXPIRED'   ? 'selected' : ''}>Đã hết hạn</option>
            </select>
            <button class="btn-apply-filter" onclick="submitFilter();">
                <i class="fas fa-filter"></i> Áp dụng
            </button>
            <button class="btn-reset-filter" onclick="resetFilter();">
                <i class="fas fa-undo"></i> Đặt lại
            </button>
        </div>

        <%-- ── Bảng khuyến mãi ───────────────────────────────────────────── --%>
        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">
                    <i class="fas fa-list-ul"></i>
                    Danh sách khuyến mãi
                    <span class="count-badge">${totalDiscounts}</span>
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
                        <col class="col-code">
                        <col class="col-desc">
                        <col class="col-type hide-mobile">
                        <col class="col-value">
                        <col class="col-minorder hide-mobile">
                        <col class="col-period hide-xs">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Mã giảm giá</th>
                        <th>Mô tả</th>
                        <th class="hide-mobile">Loại</th>
                        <th>Giá trị</th>
                        <th class="hide-mobile">Đơn tối thiểu</th>
                        <th class="hide-xs">Thời hạn</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty discounts}">
                            <tr>
                                <td colspan="8">
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="fas fa-tags"></i></div>
                                        <h4>Không tìm thấy khuyến mãi nào</h4>
                                        <p>Thử thay đổi từ khoá hoặc điều chỉnh bộ lọc</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="d" items="${discounts}" varStatus="st">
                                <%-- Tính trạng thái hiệu lực --%>
                                <c:set var="dNow"  value="${now}" />
                                <c:set var="dCls"  value="ds-active" />
                                <c:set var="dLabel" value="Đang hiệu lực" />
                                <c:set var="dIcon"  value="fa-check-circle" />
                                <c:if test="${d.endDate != null && d.endDate.isBefore(dNow)}">
                                    <c:set var="dCls"   value="ds-expired" />
                                    <c:set var="dLabel" value="Đã hết hạn" />
                                    <c:set var="dIcon"  value="fa-times-circle" />
                                </c:if>
                                <c:if test="${d.startDate != null && d.startDate.isAfter(dNow)}">
                                    <c:set var="dCls"   value="ds-upcoming" />
                                    <c:set var="dLabel" value="Chưa bắt đầu" />
                                    <c:set var="dIcon"  value="fa-clock" />
                                </c:if>

                                <tr>
                                    <td><span class="row-num">${(currentPage-1)*pageSize + st.index + 1}</span></td>
                                    <td>
                                        <div class="code-cell">
                                            <span class="code-chip" onclick="copyCode('${d.code}')" title="Nhấn để sao chép">
                                                <i class="fas fa-copy"></i>${d.code}
                                            </span>
                                            <span class="code-id">ID: ${d.id}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="desc-cell" title="${d.description}">
                                                ${empty d.description ? '—' : d.description}
                                        </div>
                                    </td>
                                    <td class="hide-mobile">
                                        <c:choose>
                                            <c:when test="${d.discountType == 1}">
                                                <span class="type-badge type-percent">
                                                    <i class="fas fa-percent"></i> Phần trăm
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="type-badge type-fixed">
                                                    <i class="fas fa-hand-holding-usd"></i> Cố định
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="value-cell">${d.displayValue}</span>
                                    </td>
                                    <td class="hide-mobile">
                                        <span style="font-size:.84rem; font-weight:600; color:var(--text-sub)">
                                                ${d.displayMinOrder}
                                        </span>
                                    </td>
                                    <td class="hide-xs">
                                        <div class="period-cell">
                                            <span class="from"><i class="fas fa-play-circle"></i> ${d.formattedStartDate}</span>
                                            <span class="to"><i class="fas fa-stop-circle"></i> ${d.formattedEndDate}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <button class="action-btn action-btn-view-d"
                                                    title="Xem chi tiết"
                                                    onclick="openViewModal(${d.id})">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="action-btn action-btn-edit-d"
                                                    title="Chỉnh sửa"
                                                    onclick="openEditModal(${d.id})">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <button class="action-btn action-btn-delete"
                                                    title="Xoá"
                                                    onclick="confirmDelete(${d.id}, '${d.code}')">
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

            <%-- ── Phân trang ──────────────────────────────────────────────── --%>
            <div class="table-footer">
                <div class="result-info">
                    Hiển thị <strong>${discounts.size()}</strong> /
                    <strong>${totalDiscounts}</strong> khuyến mãi
                </div>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <c:set var="base" value="${pageContext.request.contextPath}/admin/discounts?page="/>
                        <c:set var="qs"   value=""/>
                        <c:if test="${not empty keyword}">    <c:set var="qs" value="${qs}&keyword=${keyword}"/></c:if>
                        <c:if test="${typeFilter >= 0}">      <c:set var="qs" value="${qs}&type=${typeFilter}"/></c:if>
                        <c:if test="${not empty statusFilter && statusFilter != '-1'}">
                            <c:set var="qs" value="${qs}&status=${statusFilter}"/>
                        </c:if>

                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${base}${currentPage - 1}${qs}"><i class="fas fa-chevron-left"></i></a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}">
                                    <li class="page-item active"><a class="page-link" href="#">${p}</a></li>
                                </c:when>
                                <c:when test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                    <li class="page-item"><a class="page-link" href="${base}${p}${qs}">${p}</a></li>
                                </c:when>
                                <c:when test="${p == currentPage - 3 || p == currentPage + 3}">
                                    <li class="page-item ellipsis"><a class="page-link">…</a></li>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${base}${currentPage + 1}${qs}"><i class="fas fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </div><%-- /table-card --%>
    </main>
</div>

<%-- ════════════════════════════════════════════════════════════════════════════
     Form xoá (hidden)
════════════════════════════════════════════════════════════════════════════ --%>
<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/discounts" style="display:none">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id"     id="deleteId">
</form>

<%-- ════════════════════════════════════════════════════════════════════════════
     Modal xem chi tiết
════════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="viewDiscountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-tag"></i> Chi tiết khuyến mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="discount-modal-header">
                    <div class="discount-modal-icon"><i class="fas fa-tags"></i></div>
                    <div>
                        <div class="discount-modal-code" id="viewCode"></div>
                        <div class="discount-modal-desc" id="viewDesc"></div>
                    </div>
                </div>

                <div class="dinfo-grid">
                    <div class="dinfo-row">
                        <span class="dinfo-lbl"><i class="fas fa-tag"></i> Loại giảm</span>
                        <span class="dinfo-val" id="viewType"></span>
                    </div>
                    <div class="dinfo-row">
                        <span class="dinfo-lbl"><i class="fas fa-percent"></i> Giá trị</span>
                        <span class="dinfo-val" id="viewValue"></span>
                    </div>
                    <div class="dinfo-row">
                        <span class="dinfo-lbl"><i class="fas fa-shopping-cart"></i> Đơn tối thiểu</span>
                        <span class="dinfo-val" id="viewMinOrder"></span>
                    </div>
                    <div class="dinfo-row">
                        <span class="dinfo-lbl"><i class="fas fa-circle"></i> Trạng thái</span>
                        <span class="dinfo-val" id="viewStatusBadge"></span>
                    </div>
                    <div class="dinfo-row">
                        <span class="dinfo-lbl"><i class="fas fa-play-circle"></i> Bắt đầu</span>
                        <span class="dinfo-val" id="viewStartDate"></span>
                    </div>
                    <div class="dinfo-row">
                        <span class="dinfo-lbl"><i class="fas fa-stop-circle"></i> Kết thúc</span>
                        <span class="dinfo-val" id="viewEndDate"></span>
                    </div>
                    <div class="dinfo-row full-row">
                        <span class="dinfo-lbl"><i class="fas fa-calendar-plus"></i> Ngày tạo</span>
                        <span class="dinfo-val" id="viewCreatedAt"></span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<%-- ════════════════════════════════════════════════════════════════════════════
     Modal thêm khuyến mãi
════════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="addDiscountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle"></i> Thêm khuyến mãi mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">

                    <div class="form-section-title"><i class="fas fa-info-circle"></i> Thông tin cơ bản</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã khuyến mãi <span class="req">*</span></label>
                            <input type="text" name="code" class="form-control"
                                   placeholder="VD: SUMMER20" required
                                   style="text-transform:uppercase; font-family:'Courier New',monospace; font-weight:700; letter-spacing:1px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mô tả</label>
                            <input type="text" name="description" class="form-control"
                                   placeholder="VD: Giảm 20% cho đơn từ 200.000đ">
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-sliders-h"></i> Cấu hình giảm giá</div>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Loại giảm giá <span class="req">*</span></label>
                            <div class="type-radio-group">
                                <label class="type-radio-item">
                                    <input type="radio" name="discountType" value="1" checked onchange="updateValueUnit()">
                                    <i class="fas fa-percent" style="color:#6d28d9"></i> Giảm theo phần trăm (%)
                                </label>
                                <label class="type-radio-item">
                                    <input type="radio" name="discountType" value="0" onchange="updateValueUnit()">
                                    <i class="fas fa-hand-holding-usd" style="color:var(--info)"></i> Giảm số tiền cố định
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Giá trị giảm <span class="req">*</span></label>
                            <div class="input-group">
                                <input type="number" name="value" class="form-control"
                                       placeholder="VD: 20" min="0" step="any" required>
                                <span class="input-group-text" id="addValueUnit">%</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Giá trị đơn tối thiểu</label>
                            <div class="input-group">
                                <input type="number" name="minOrderValue" class="form-control"
                                       placeholder="VD: 200000" min="0" step="1000">
                                <span class="input-group-text">VNĐ</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-calendar-alt"></i> Thời gian hiệu lực</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Ngày bắt đầu</label>
                            <input type="datetime-local" name="startDate" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày kết thúc</label>
                            <input type="datetime-local" name="endDate" class="form-control">
                        </div>
                    </div>

                    <div class="form-hint" style="margin-top:14px">
                        <i class="fas fa-info-circle"></i>
                        Để trống ngày bắt đầu/kết thúc nếu khuyến mãi không giới hạn thời gian.
                        Mã khuyến mãi sẽ tự động chuyển thành chữ in hoa.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Tạo khuyến mãi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- ════════════════════════════════════════════════════════════════════════════
     Modal sửa khuyến mãi
════════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="editDiscountModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-pen"></i> Chỉnh sửa khuyến mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/discounts">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id"     id="editId">
                <div class="modal-body">

                    <div class="form-section-title"><i class="fas fa-info-circle"></i> Thông tin cơ bản</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã khuyến mãi <span class="req">*</span></label>
                            <input type="text" name="code" id="editCode" class="form-control" required
                                   style="text-transform:uppercase; font-family:'Courier New',monospace; font-weight:700; letter-spacing:1px;">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mô tả</label>
                            <input type="text" name="description" id="editDescription" class="form-control">
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-sliders-h"></i> Cấu hình giảm giá</div>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Loại giảm giá <span class="req">*</span></label>
                            <div class="type-radio-group">
                                <label class="type-radio-item">
                                    <input type="radio" name="discountType" value="1" onchange="updateValueUnit()">
                                    <i class="fas fa-percent" style="color:#6d28d9"></i> Giảm theo phần trăm (%)
                                </label>
                                <label class="type-radio-item">
                                    <input type="radio" name="discountType" value="0" onchange="updateValueUnit()">
                                    <i class="fas fa-hand-holding-usd" style="color:var(--info)"></i> Giảm số tiền cố định
                                </label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Giá trị giảm <span class="req">*</span></label>
                            <div class="input-group">
                                <input type="number" name="value" id="editValue" class="form-control"
                                       min="0" step="any" required>
                                <span class="input-group-text" id="editValueUnit">%</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Giá trị đơn tối thiểu</label>
                            <div class="input-group">
                                <input type="number" name="minOrderValue" id="editMinOrder" class="form-control"
                                       min="0" step="1000">
                                <span class="input-group-text">VNĐ</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-section-title"><i class="fas fa-calendar-alt"></i> Thời gian hiệu lực</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Ngày bắt đầu</label>
                            <input type="datetime-local" name="startDate" id="editStartDate" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày kết thúc</label>
                            <input type="datetime-local" name="endDate" id="editEndDate" class="form-control">
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

<input type="hidden" id="autoOpenModal" value="${autoOpenModal}">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_discount.js"></script>
</body>
</html>
