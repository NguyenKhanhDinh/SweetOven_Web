<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Quản lý đơn hàng</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_order.css">
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
            <h1 class="page-title"><i class="fas fa-receipt"></i> Quản lý đơn hàng</h1>
        </div>

        <%-- ── Thống kê ───────────────────────────────────────────────────── --%>
        <div class="stats-row">
            <div class="stat-item">
                <div class="stat-bar sb-today"></div>
                <div class="stat-value">${todayOrders}</div>
                <div class="stat-label">Hôm nay</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-pending"></div>
                <div class="stat-value">${pendingOrders}</div>
                <div class="stat-label">Chờ xác nhận</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-processing"></div>
                <div class="stat-value">${processingOrders}</div>
                <div class="stat-label">Đang xử lý</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-shipping"></div>
                <div class="stat-value">${shippingOrders}</div>
                <div class="stat-label">Đang giao</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-delivered"></div>
                <div class="stat-value">${deliveredOrders}</div>
                <div class="stat-label">Đã giao</div>
            </div>
            <div class="stat-item">
                <div class="stat-bar sb-cancelled"></div>
                <div class="stat-value">${cancelledOrders}</div>
                <div class="stat-label">Đã huỷ</div>
            </div>
        </div>

        <%-- ── Bộ lọc ─────────────────────────────────────────────────────── --%>
        <div class="filter-row">
            <div class="search-wrap">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Tìm theo mã đơn, tên, số điện thoại..."
                       value="${keyword}">
            </div>
            <select id="filterStatus" class="filter-select">
                <option value="-1" ${statusFilter == -1 ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="1"  ${statusFilter == 1  ? 'selected' : ''}>Chờ xác nhận</option>
                <option value="2"  ${statusFilter == 2  ? 'selected' : ''}>Đang xử lý</option>
                <option value="3"  ${statusFilter == 3  ? 'selected' : ''}>Đang giao</option>
                <option value="4"  ${statusFilter == 4  ? 'selected' : ''}>Đã giao</option>
                <option value="5"  ${statusFilter == 5  ? 'selected' : ''}>Đã huỷ</option>
            </select>
            <select id="filterMethod" class="filter-select">
                <option value="-1" ${methodFilter == -1 ? 'selected' : ''}>Tất cả thanh toán</option>
                <option value="1"  ${methodFilter == 1  ? 'selected' : ''}>COD</option>
                <option value="2"  ${methodFilter == 2  ? 'selected' : ''}>MoMo</option>
                <option value="3"  ${methodFilter == 3  ? 'selected' : ''}>VNPay</option>
            </select>
            <button class="btn-apply-filter" onclick="submitFilter();">
                <i class="fas fa-filter"></i> Áp dụng
            </button>
            <button class="btn-reset-filter" onclick="resetFilter();">
                <i class="fas fa-undo"></i> Đặt lại
            </button>
        </div>

        <%-- ── Bảng đơn hàng ──────────────────────────────────────────────── --%>
        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">
                    <i class="fas fa-list-ul"></i>
                    Danh sách đơn hàng
                    <span class="count-badge">${totalOrders}</span>
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
                        <col class="col-order">
                        <col class="col-customer">
                        <col class="col-amount hide-mobile">
                        <col class="col-method hide-mobile">
                        <col class="col-status">
                        <col class="col-date hide-xs">
                        <col class="col-action">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Đơn hàng</th>
                        <th>Khách hàng</th>
                        <th class="hide-mobile">Tổng tiền</th>
                        <th class="hide-mobile">Thanh toán</th>
                        <th>Trạng thái</th>
                        <th class="hide-xs">Ngày đặt</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty orders}">
                            <tr>
                                <td colspan="8">
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="fas fa-inbox"></i></div>
                                        <h4>Không tìm thấy đơn hàng nào</h4>
                                        <p>Thử thay đổi từ khoá hoặc điều chỉnh bộ lọc</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="o" items="${orders}" varStatus="st">
                                <%-- Xác định class trạng thái --%>
                                <c:set var="sCls" value=""/>
                                <c:choose>
                                    <c:when test="${o.orderStatus == 1}"><c:set var="sCls" value="os-pending"/></c:when>
                                    <c:when test="${o.orderStatus == 2}"><c:set var="sCls" value="os-processing"/></c:when>
                                    <c:when test="${o.orderStatus == 3}"><c:set var="sCls" value="os-shipping"/></c:when>
                                    <c:when test="${o.orderStatus == 4}"><c:set var="sCls" value="os-delivered"/></c:when>
                                    <c:when test="${o.orderStatus == 5}"><c:set var="sCls" value="os-cancelled"/></c:when>
                                </c:choose>
                                <c:set var="sLabel" value=""/>
                                <c:choose>
                                    <c:when test="${o.orderStatus == 1}"><c:set var="sLabel" value="Chờ xác nhận"/></c:when>
                                    <c:when test="${o.orderStatus == 2}"><c:set var="sLabel" value="Đang xử lý"/></c:when>
                                    <c:when test="${o.orderStatus == 3}"><c:set var="sLabel" value="Đang giao"/></c:when>
                                    <c:when test="${o.orderStatus == 4}"><c:set var="sLabel" value="Đã giao"/></c:when>
                                    <c:when test="${o.orderStatus == 5}"><c:set var="sLabel" value="Đã huỷ"/></c:when>
                                </c:choose>
                                <%-- Thanh toán --%>
                                <c:set var="pCls"   value="pay-cod"/>
                                <c:set var="pLabel" value="COD"/>
                                <c:if test="${o.paymentMethod == 2}"><c:set var="pCls" value="pay-momo"/><c:set var="pLabel" value="MoMo"/></c:if>
                                <c:if test="${o.paymentMethod == 3}"><c:set var="pCls" value="pay-vnpay"/><c:set var="pLabel" value="VNPay"/></c:if>

                                <tr>
                                    <td><span class="row-num">${(currentPage-1)*pageSize + st.index + 1}</span></td>
                                    <td>
                                        <div class="order-cell">
                                            <span class="order-code">#${o.orderCode}</span>
                                            <span class="order-meta">ID: ${o.id}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="customer-cell">
                                            <span class="customer-name">${o.fullName}</span>
                                            <span class="customer-phone"><i class="fas fa-phone" style="font-size:.7rem"></i> ${o.phoneNumber}</span>
                                        </div>
                                    </td>
                                    <td class="hide-mobile">
                                        <span class="amount-cell">${o.totalAmountFormatted}</span>
                                    </td>
                                    <td class="hide-mobile">
                                        <span class="pay-badge ${pCls}">${pLabel}</span>
                                    </td>
                                    <td>
                                        <span class="order-status-badge ${sCls}">${sLabel}</span>
                                    </td>
                                    <td class="hide-xs">
                                        <span class="date-cell">
                                            <i class="fas fa-calendar-alt"></i> ${o.orderDateFormatted}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <button class="action-btn action-btn-detail"
                                                    title="Xem chi tiết"
                                                    onclick="openOrderDetail(${o.id})">
                                                <i class="fas fa-eye"></i>
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
                    Hiển thị <strong>${orders.size()}</strong> /
                    <strong>${totalOrders}</strong> đơn hàng
                </div>
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <c:set var="base" value="${pageContext.request.contextPath}/admin/orders?page="/>
                        <c:set var="qs"   value=""/>
                        <c:if test="${not empty keyword}"><c:set var="qs" value="${qs}&keyword=${keyword}"/></c:if>
                        <c:if test="${statusFilter >= 0}"><c:set var="qs" value="${qs}&status=${statusFilter}"/></c:if>
                        <c:if test="${methodFilter >= 0}"><c:set var="qs" value="${qs}&paymentMethod=${methodFilter}"/></c:if>

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
     Modal chi tiết đơn hàng
════════════════════════════════════════════════════════════════════════════ --%>
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-receipt"></i> Chi tiết đơn hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="orderDetailBody">
                <%-- nội dung load bằng JS --%>
            </div>
            <div class="modal-footer" id="orderDetailFooter" style="flex-wrap:wrap; gap:8px;">

                <%-- Form chuyển trạng thái --%>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="formNextStatus" style="display:none">
                    <input type="hidden" name="action"    value="updateStatus">
                    <input type="hidden" name="id"        id="nextOrderId">
                    <input type="hidden" name="newStatus" id="nextStatusVal">
                    <%-- giữ lại filter khi redirect --%>
                    <c:if test="${not empty keyword}">       <input type="hidden" name="keyword"       value="${keyword}"></c:if>
                    <c:if test="${statusFilter >= 0}">       <input type="hidden" name="status"        value="${statusFilter}"></c:if>
                    <c:if test="${methodFilter >= 0}">       <input type="hidden" name="paymentMethod" value="${methodFilter}"></c:if>
                    <input type="hidden" name="page" value="${currentPage}">
                </form>

                <%-- Form huỷ đơn (ẩn, hiện bằng JS) --%>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="cancelOrderForm" style="display:none; width:100%">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id"     id="cancelOrderId">
                    <c:if test="${not empty keyword}">       <input type="hidden" name="keyword"       value="${keyword}"></c:if>
                    <c:if test="${statusFilter >= 0}">       <input type="hidden" name="status"        value="${statusFilter}"></c:if>
                    <c:if test="${methodFilter >= 0}">       <input type="hidden" name="paymentMethod" value="${methodFilter}"></c:if>
                    <input type="hidden" name="page" value="${currentPage}">
                    <div class="cancel-section">
                        <label for="cancelReason"><i class="fas fa-comment-alt" style="color:var(--danger)"></i> Lý do huỷ đơn</label>
                        <textarea name="reason" id="cancelReason" placeholder="Nhập lý do huỷ đơn..."></textarea>
                    </div>
                    <div style="display:flex; gap:8px; margin-top:8px">
                        <button type="submit" class="btn-cancel-order" style="flex:1">
                            <i class="fas fa-times-circle"></i> Xác nhận huỷ
                        </button>
                        <button type="button" class="btn-secondary" onclick="document.getElementById('cancelOrderForm').style.display='none'" style="flex:1">
                            Bỏ qua
                        </button>
                    </div>
                </form>

                <%-- Form tạo đơn GHN --%>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="formCreateGhn" style="display:none">
                    <input type="hidden" name="action" value="createGhn">
                    <input type="hidden" name="id"     id="ghnOrderId">
                    <c:if test="${not empty keyword}">       <input type="hidden" name="keyword"       value="${keyword}"></c:if>
                    <c:if test="${statusFilter >= 0}">       <input type="hidden" name="status"        value="${statusFilter}"></c:if>
                    <c:if test="${methodFilter >= 0}">       <input type="hidden" name="paymentMethod" value="${methodFilter}"></c:if>
                    <input type="hidden" name="page" value="${currentPage}">
                </form>

                <%-- Form đồng bộ trạng thái GHN --%>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="formSyncGhn" style="display:none">
                    <input type="hidden" name="action" value="syncGhn">
                    <input type="hidden" name="id"     id="syncGhnOrderId">
                    <c:if test="${not empty keyword}">       <input type="hidden" name="keyword"       value="${keyword}"></c:if>
                    <c:if test="${statusFilter >= 0}">       <input type="hidden" name="status"        value="${statusFilter}"></c:if>
                    <c:if test="${methodFilter >= 0}">       <input type="hidden" name="paymentMethod" value="${methodFilter}"></c:if>
                    <input type="hidden" name="page" value="${currentPage}">
                </form>

                <button type="button" class="btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> Đóng
                </button>
                <button type="button" class="btn-cancel-order" id="btnCancelOrder" disabled>
                    <i class="fas fa-ban"></i> Huỷ đơn
                </button>
                <%-- Nút tạo đơn GHN: JS sẽ show/hide tuỳ trạng thái --%>
                <button type="button" class="btn-next-status" id="btnCreateGhn" style="display:none;background:#0d6efd"
                        onclick="document.getElementById('formCreateGhn').submit()">
                    <i class="fas fa-truck"></i> Tạo đơn GHN
                </button>
                <%-- Nút đồng bộ trạng thái GHN: JS sẽ show/hide khi đã có mã GHN --%>
                <button type="button" class="btn-secondary" id="btnSyncGhn" style="display:none"
                        onclick="document.getElementById('syncGhnOrderId').value=document.getElementById('ghnOrderId').value;document.getElementById('formSyncGhn').submit()">
                    <i class="fas fa-sync-alt"></i> Đồng bộ GHN
                </button>
                <button type="button" class="btn-next-status" id="btnNextStatus" disabled>
                    <i class="fas fa-arrow-right"></i> Cập nhật trạng thái
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_order.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script>
</script>
</body>
</html>
