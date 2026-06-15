<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven — Dashboard</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_dashboard.css">
    <script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</head>
<body>
<div class="admin-wrapper">

    <%@ include file="/components/sidebar.jsp" %>

    <main class="main-content">

        <div class="page-header">
            <div class="page-header-left">
                <div class="page-header-icon"><i class="fas fa-chart-pie"></i></div>
                <div>
                    <h1 class="page-title">Dashboard thống kê</h1>
                    <div class="page-subtitle">Phân tích doanh thu, đơn hàng và sản phẩm · Sweet Oven</div>
                </div>
            </div>
            <div class="header-actions">

                <div class="current-time" id="currentTime">
                    <i class="fas fa-clock"></i>
                    <span id="clockText"></span>
                </div>
                <a href="${pageContext.request.contextPath}/admin/dashboard?action=print&year=${selectedYear}&month=${selectedMonth}"
                   class="btn-print" target="_blank">
                    <i class="fas fa-print"></i> In báo cáo
                </a>
            </div>
        </div>

        <div class="filter-card">
            <div class="filter-label"><i class="fas fa-sliders-h"></i> Bộ lọc thời gian</div>
            <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" class="filter-form">
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-calendar-alt"></i> Năm</label>
                    <select name="year" class="form-select">
                        <c:forEach var="y" items="${years}">
                            <option value="${y}" ${y == selectedYear ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="fas fa-calendar-week"></i> Tháng</label>
                    <select name="month" class="form-select">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn-apply-filter">
                    <i class="fas fa-search"></i> Xem thống kê
                </button>
            </form>
        </div>

        <div class="kpi-grid">

            <div class="kpi-card kpi-month">
                <div class="kpi-header">
                    <div class="kpi-icon-wrap"><i class="fas fa-calendar-check"></i></div>
                    <span class="kpi-badge ${dashboard.currentMonthRevenue >= dashboard.previousMonthRevenue ? 'badge-up' : 'badge-down'}">
                        <i class="fas ${dashboard.currentMonthRevenue >= dashboard.previousMonthRevenue ? 'fa-arrow-trend-up' : 'fa-arrow-trend-down'}"></i>
                        ${dashboard.monthlyGrowthRate}
                    </span>
                </div>
                <div class="kpi-value" data-count="${dashboard.currentMonthRevenue}">
                    <fmt:formatNumber value="${dashboard.currentMonthRevenue}" type="number" maxFractionDigits="0"/>
                    <span class="kpi-unit">VNĐ</span>
                </div>
                <div class="kpi-label">Doanh thu tháng ${selectedMonth}/${selectedYear}</div>
                <div class="kpi-divider"></div>
                <div class="kpi-compare">
                    <span class="kpi-compare-label">Tháng trước</span>
                    <span class="kpi-compare-val">
                        <fmt:formatNumber value="${dashboard.previousMonthRevenue}" type="number" maxFractionDigits="0"/> VNĐ
                    </span>
                </div>
            </div>

            <div class="kpi-card kpi-year">
                <div class="kpi-header">
                    <div class="kpi-icon-wrap"><i class="fas fa-calendar-alt"></i></div>
                    <span class="kpi-badge ${dashboard.currentYearRevenue >= dashboard.previousYearRevenue ? 'badge-up' : 'badge-down'}">
                        <i class="fas ${dashboard.currentYearRevenue >= dashboard.previousYearRevenue ? 'fa-arrow-trend-up' : 'fa-arrow-trend-down'}"></i>
                        vs ${selectedYear-1}
                    </span>
                </div>
                <div class="kpi-value">
                    <fmt:formatNumber value="${dashboard.currentYearRevenue}" type="number" maxFractionDigits="0"/>
                    <span class="kpi-unit">VNĐ</span>
                </div>
                <div class="kpi-label">Doanh thu năm ${selectedYear}</div>
                <div class="kpi-divider"></div>
                <div class="kpi-compare">
                    <span class="kpi-compare-label">Năm ${selectedYear-1}</span>
                    <span class="kpi-compare-val">
                        <fmt:formatNumber value="${dashboard.previousYearRevenue}" type="number" maxFractionDigits="0"/> VNĐ
                    </span>
                </div>
            </div>

            <div class="kpi-card kpi-total-rev">
                <div class="kpi-header">
                    <div class="kpi-icon-wrap"><i class="fas fa-coins"></i></div>
                </div>
                <div class="kpi-value">
                    <fmt:formatNumber value="${dashboard.totalRevenue}" type="number" maxFractionDigits="0"/>
                    <span class="kpi-unit">VNĐ</span>
                </div>
                <div class="kpi-label">Tổng doanh thu</div>
                <div class="kpi-divider"></div>
                <div class="kpi-compare">
                    <span class="kpi-compare-label">Toàn bộ lịch sử</span>
                    <span class="kpi-compare-val kpi-all-time">Tất cả đơn hoàn thành</span>
                </div>
            </div>

            <div class="kpi-card kpi-orders">
                <div class="kpi-header">
                    <div class="kpi-icon-wrap"><i class="fas fa-shopping-bag"></i></div>
                </div>
                <div class="kpi-value">${dashboard.totalOrders}</div>
                <div class="kpi-label">Tổng đơn hàng</div>
                <div class="kpi-divider"></div>
                <div class="kpi-compare">
                    <span class="kpi-compare-label">Tất cả thời gian</span>
                    <span class="kpi-compare-val kpi-all-time">Mọi trạng thái</span>
                </div>
            </div>

            <div class="kpi-card kpi-products">
                <div class="kpi-header">
                    <div class="kpi-icon-wrap"><i class="fas fa-box-open"></i></div>
                </div>
                <div class="kpi-value">${dashboard.totalProducts}</div>
                <div class="kpi-label">Tổng sản phẩm</div>
                <div class="kpi-divider"></div>
                <div class="kpi-compare">
                    <span class="kpi-compare-label">Đang kinh doanh</span>
                    <span class="kpi-compare-val kpi-all-time">Trong hệ thống</span>
                </div>
            </div>

            <div class="kpi-card kpi-users">
                <div class="kpi-header">
                    <div class="kpi-icon-wrap"><i class="fas fa-users"></i></div>
                </div>
                <div class="kpi-value">${dashboard.totalUsers}</div>
                <div class="kpi-label">Khách hàng</div>
                <div class="kpi-divider"></div>
                <div class="kpi-compare">
                    <span class="kpi-compare-label">Đã đăng ký</span>
                    <span class="kpi-compare-val kpi-all-time">Tài khoản hoạt động</span>
                </div>
            </div>

        </div>


        <div class="chart-card">
            <div class="chart-card-header">
                <div class="chart-title-group">
                    <h2 class="chart-card-title">
                        <i class="fas fa-chart-line"></i> Biểu đồ doanh thu
                    </h2>
                    <div class="chart-subtitle" id="chartSubtitle">Tổng quan theo từng năm</div>
                </div>

                <div class="chart-tabs">
                    <button class="chart-tab active" data-tab="yearly">
                        <i class="fas fa-calendar-alt"></i> Theo năm
                    </button>
                    <button class="chart-tab" data-tab="monthly">
                        <i class="fas fa-calendar"></i> Theo tháng
                    </button>
                    <button class="chart-tab" data-tab="weekly">
                        <i class="fas fa-calendar-week"></i> Theo tuần
                    </button>
                </div>
            </div>
            <div class="chart-card-body">
                <div class="chart-summary" id="chartSummary"></div>
                <div class="chart-wrap">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>

        <div class="tables-row">


            <div class="table-card">
                <div class="table-card-header">
                    <h2 class="table-card-title"><i class="fas fa-fire"></i> Top sản phẩm bán chạy</h2>
                    <span class="table-badge">Top 10</span>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th style="width:44px">#</th>
                            <th style="width:52px">Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th style="width:90px">Mã SP</th>
                            <th style="width:90px">Đã bán</th>
                            <th>Doanh thu</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:set var="maxSold" value="${dashboard.topSellingProducts[0].totalSold}"/>
                        <c:forEach items="${dashboard.topSellingProducts}" var="p" varStatus="loop">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${loop.index == 0}"><span class="rank-medal">🥇</span></c:when>
                                        <c:when test="${loop.index == 1}"><span class="rank-medal">🥈</span></c:when>
                                        <c:when test="${loop.index == 2}"><span class="rank-medal">🥉</span></c:when>
                                        <c:otherwise><span class="rank-num">${loop.index + 1}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <img src="${p.image}" class="prod-thumb"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                                </td>
                                <td>
                                    <span class="prod-name">${p.name}</span>
                                    <div class="sold-bar">
                                        <div class="sold-bar-fill sold-bar-hot"
                                             style="width: ${maxSold > 0 ? (p.totalSold * 100 / maxSold) : 0}%"></div>
                                    </div>
                                </td>
                                <td><span class="prod-code">${p.productCode}</span></td>
                                <td><span class="text-sold">${p.totalSold}</span></td>
                                <td>
                                    <span class="text-revenue">
                                        <fmt:formatNumber value="${p.totalRevenue}" type="number" maxFractionDigits="0"/>
                                        <small>VNĐ</small>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty dashboard.topSellingProducts}">
                            <tr><td colspan="6"><div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-box-open"></i></div>
                                <p>Chưa có dữ liệu</p>
                            </div></td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="table-card">
                <div class="table-card-header">
                    <h2 class="table-card-title"><i class="fas fa-arrow-trend-down"></i> Sản phẩm cần đẩy mạnh</h2>
                    <span class="table-badge table-badge-warn">Chú ý</span>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th style="width:44px">#</th>
                            <th style="width:52px">Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th style="width:90px">Mã SP</th>
                            <th style="width:90px">Đã bán</th>
                            <th>Gợi ý</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${dashboard.slowMovingProducts}" var="p" varStatus="loop">
                            <tr>
                                <td><span class="rank-num rank-slow">${loop.index + 1}</span></td>
                                <td>
                                    <img src="${p.image}" class="prod-thumb"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                                </td>
                                <td>
                                    <span class="prod-name">${p.name}</span>
                                    <div class="sold-bar">
                                        <div class="sold-bar-fill sold-bar-slow" style="width:${p.totalSold > 0 ? 20 : 4}%"></div>
                                    </div>
                                </td>
                                <td><span class="prod-code">${p.productCode}</span></td>
                                <td><span class="text-sold-low">${p.totalSold}</span></td>
                                <td><span class="tag-suggest"><i class="fas fa-bolt"></i> Cần đẩy mạnh</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty dashboard.slowMovingProducts}">
                            <tr><td colspan="6"><div class="empty-state">
                                <div class="empty-icon"><i class="fas fa-box-open"></i></div>
                                <p>Chưa có dữ liệu</p>
                            </div></td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

    </main>
</div>

<script>
    const monthlyData = [
        <c:forEach items="${dashboard.monthlyRevenue}" var="m" varStatus="loop">
        ${m.revenue}${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    const yearlyLabels = [
        <c:forEach items="${dashboard.yearlyRevenue}" var="y" varStatus="loop">
        '${y.period}'${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    const yearlyValues = [
        <c:forEach items="${dashboard.yearlyRevenue}" var="y" varStatus="loop">
        ${y.revenue}${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    const weeklyData = [
        <c:forEach items="${dashboard.weeklyRevenue}" var="w" varStatus="loop">
        ${w.revenue}${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    const selectedMonth = ${selectedMonth};
    const selectedYear  = ${selectedYear};
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/components/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin_dashboard.js"></script>
</body>
</html>
