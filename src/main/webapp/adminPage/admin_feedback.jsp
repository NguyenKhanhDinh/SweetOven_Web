<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý phản hồi</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_feedback.css">
    <script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</head>
<body>
<div class="admin-wrapper">

    <%@ include file="/components/sidebar.jsp" %>

    <main class="main-content">

        <!-- Floating Alerts -->
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

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-envelope"></i> Quản lý phản hồi
            </h1>
            <button class="btn-primary" onclick="exportToExcel();">
                <i class="fas fa-file-excel"></i> Xuất Excel
            </button>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-total"></div>
                <div class="stat-value">${totalFeedbacks}</div>
                <div class="stat-label">Tổng phản hồi</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-today"></div>
                <div class="stat-value">${todayFeedbacks}</div>
                <div class="stat-label">Hôm nay</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-week"></div>
                <div class="stat-value">${weekFeedbacks}</div>
                <div class="stat-label">7 ngày qua</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-pending"></div>
                <div class="stat-value">${monthFeedbacks}</div>
                <div class="stat-label">Tháng này</div>
            </div>
        </div>

        <!-- Filter Row -->
        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Tìm theo tên, email hoặc nội dung..."
                       value="${keyword}">
            </div>
            <input type="date" id="filterDateFrom" class="filter-select"
                   style="min-width: 140px;" value="${dateFrom}"
                   placeholder="Từ ngày">
            <input type="date" id="filterDateTo" class="filter-select"
                   style="min-width: 140px;" value="${dateTo}"
                   placeholder="Đến ngày">
            <button class="btn-apply-filter" onclick="submitFilter();">
                <i class="fas fa-filter"></i> Áp dụng
            </button>
            <button class="btn-reset-filter" onclick="resetFilter();">
                <i class="fas fa-undo"></i> Đặt lại
            </button>
        </div>

        <!-- Feedback Table -->
        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">
                    <i class="fas fa-list-ul"></i>
                    Danh sách phản hồi
                </div>
                <div class="page-meta">
                    <i class="fas fa-file-alt"></i>
                    Trang <strong>${currentPage}&nbsp;</strong> /
                    <strong>${totalPages > 0 ? totalPages : 1}&nbsp;</strong>
                </div>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <colgroup>
                        <col class="col-no">
                        <col class="col-sender">
                        <col class="col-content">
                        <col class="col-date">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Người gửi</th>
                            <th>Nội dung</th>
                            <th>Ngày gửi</th>
                            <th style="text-align:center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty feedbacks}">
                                <tr>
                                    <td colspan="5">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">
                                                <i class="fas fa-envelope-open-text"></i>
                                            </div>
                                            <h4>Không tìm thấy phản hồi nào</h4>
                                            <p>Thử thay đổi từ khóa hoặc điều chỉnh bộ lọc</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="fb" items="${feedbacks}" varStatus="st">
                                    <tr>
                                        <td>
                                            <span class="row-num">${(currentPage-1)*pageSize + st.index + 1}</span>
                                        </td>
                                        <td>
                                            <div class="sender-cell">
                                                <div class="sender-name">
                                                    <i class="fas fa-user-circle" style="color: var(--accent);"></i>
                                                    ${fn:escapeXml(fb.fullName)}
                                                </div>
                                                <div class="sender-email">
                                                    <i class="fas fa-envelope"></i>
                                                    ${fn:escapeXml(fb.email)}
                                                    <c:if test="${not empty fb.phoneNumber}">
                                                        <span class="text-muted">|</span>
                                                        <i class="fas fa-phone-alt"></i>
                                                        ${fb.phoneNumber}
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="content-preview" title="${fn:escapeXml(fb.content)}">
                                                <i class="fas fa-comment-dots" style="color: var(--accent-light); margin-right: 6px;"></i>
                                                ${fn:substring(fn:escapeXml(fb.content), 0, 80)}${fn:length(fb.content) > 80 ? '...' : ''}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="date-cell">
                                                <i class="fas fa-calendar-alt"></i>
                                                ${fb.createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))}
                                            </div>
                                        </td>
                                        <td>
                                            <div class="actions-cell">
                                                <button class="action-btn action-btn-view"
                                                        onclick="openViewModal(${fb.id})"
                                                        title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="action-btn action-btn-reply"
                                                        onclick="window.location.href='mailto:${fb.email}?subject=Phản hồi từ Sweet Oven'"
                                                        title="Trả lời qua email">
                                                    <i class="fas fa-reply"></i>
                                                </button>
                                                <button class="action-btn action-btn-delete"
                                                        onclick="confirmDelete(${fb.id}, '${fn:escapeXml(fb.fullName)}')"
                                                        title="Xóa phản hồi">
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

            <!-- Table Footer with Pagination -->
            <div class="table-footer">
                <span class="result-info">
                    <c:choose>
                        <c:when test="${totalFeedbacks > 0}">
                            Hiển thị <strong>${(currentPage-1)*pageSize + 1}</strong>–
                            <strong>${(currentPage*pageSize < totalFeedbacks) ? currentPage*pageSize : totalFeedbacks}</strong>
                            trong <strong>${totalFeedbacks}</strong> phản hồi
                        </c:when>
                        <c:otherwise>Không có dữ liệu phù hợp</c:otherwise>
                    </c:choose>
                </span>

                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&dateFrom=${dateFrom}&dateTo=${dateTo}&page=${currentPage-1}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>

                        <c:if test="${currentPage > 3}">
                            <li class="page-item">
                                <a class="page-link" href="?keyword=${keyword}&dateFrom=${dateFrom}&dateTo=${dateTo}&page=1">1</a>
                            </li>
                            <c:if test="${currentPage > 4}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:if test="${p >= currentPage-2 && p <= currentPage+2}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?keyword=${keyword}&dateFrom=${dateFrom}&dateTo=${dateTo}&page=${p}">${p}</a>
                                </li>
                            </c:if>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages-2}">
                            <c:if test="${currentPage < totalPages-3}">
                                <li class="page-item ellipsis"><span class="page-link">…</span></li>
                            </c:if>
                            <li class="page-item">
                                <a class="page-link" href="?keyword=${keyword}&dateFrom=${dateFrom}&dateTo=${dateTo}&page=${totalPages}">${totalPages}</a>
                            </li>
                        </c:if>

                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?keyword=${keyword}&dateFrom=${dateFrom}&dateTo=${dateTo}&page=${currentPage+1}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </div>

    </main>
</div>

<!-- View Feedback Modal -->
<div class="modal fade" id="viewFeedbackModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-envelope-open-text"></i> Chi tiết phản hồi
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="detail-header">
                    <div class="detail-name" id="modalFullName"></div>
                    <div class="detail-email" id="modalEmail"></div>
                </div>

                <div class="detail-row">
                    <span class="detail-lbl">
                        <i class="fas fa-phone-alt"></i> Số điện thoại
                    </span>
                    <span class="detail-val" id="modalPhone"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-lbl">
                        <i class="fas fa-clock"></i> Thời gian gửi
                    </span>
                    <span class="detail-val" id="modalTime"></span>
                </div>

                <div style="margin-top: 16px;">
                    <div class="detail-lbl" style="margin-bottom: 8px;">
                        <i class="fas fa-comment-dots"></i> Nội dung tin nhắn
                    </div>
                    <div class="content-box" id="modalContent"></div>
                </div>
            </div>
            <div class="modal-footer">
                <a id="btnReplyEmail" href="#" class="btn-primary" target="_blank">
                    <i class="fas fa-reply"></i> Trả lời qua Email
                </a>
                <button type="button" class="btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Hidden field for auto open modal -->
<input type="hidden" id="autoOpenModal" value="${autoOpenModal}">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_feedback.js"></script>
</body>
</html>