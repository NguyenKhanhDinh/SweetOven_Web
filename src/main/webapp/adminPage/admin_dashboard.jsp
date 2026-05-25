<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sweet Oven - Dashboard</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/admin_dashboard.css">
</head>

<body>

<div class="admin-wrapper">

    <!-- SIDEBAR -->
    <div class="sidebar">

        <div class="d-flex flex-column h-100 p-3">

            <div class="sidebar-header text-center mb-4 mt-3">
                <h3 class="text-white fw-bold mb-0">SWEET OVEN</h3>
                <p class="text-white-50 small mt-2">
                    Quản trị hệ thống
                </p>
            </div>

            <ul class="nav nav-pills flex-column mb-auto">

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="nav-link active">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/products"
                       class="nav-link">
                        <i class="fas fa-box"></i>
                        <span>Sản phẩm</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/categories"
                       class="nav-link">
                        <i class="fas fa-list"></i>
                        <span>Danh mục</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Người dùng</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/orders"
                       class="nav-link">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Đơn hàng</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/promotions"
                       class="nav-link">
                        <i class="fas fa-tag"></i>
                        <span>Khuyến mãi</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/banners"
                       class="nav-link">
                        <i class="fas fa-images"></i>
                        <span>Banner</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/feedback"
                       class="nav-link">
                        <i class="fas fa-envelope"></i>
                        <span>Phản hồi</span>
                    </a>
                </li>

            </ul>

            <div class="dropdown mt-auto pt-3 border-top border-secondary">
                <a href="#"
                   class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                   data-bs-toggle="dropdown">

                    <i class="fas fa-user-circle fa-2x me-2"></i>
                    <strong>Quản trị viên</strong>
                </a>

                <ul class="dropdown-menu dropdown-menu-dark shadow">
                    <li>
                        <a class="dropdown-item"
                           href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>
                            Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>

        </div>

    </div>

    <!-- MAIN -->
    <div class="main-content">

        <div class="admin-header d-flex justify-content-between align-items-end">

            <div>
                <h1 class="h3 mb-1">
                    Dashboard Thống kê
                </h1>

                <p class="mb-0">
                    Phân tích doanh thu và sản phẩm
                </p>
            </div>

            <button class="btn btn-dark" onclick="printReport()">
                <i class="fas fa-print me-2"></i>
                In báo cáo
            </button>

        </div>
        <!-- FILTER -->

        <div class="filter-bar">
            <form method="get"
                  action="${pageContext.request.contextPath}/admin/dashboard"
                  class="row g-3 align-items-end">

                <div class="col-md-4">
                    <label class="form-label fw-bold">
                        <i class="fas fa-calendar me-1"></i>
                        Năm
                    </label>

                    <select name="year" class="form-select">
                        <c:forEach var="y" items="${years}">
                            <option value="${y}"
                                ${y == selectedYear ? 'selected' : ''}>
                                Năm ${y}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-4">
                    <label class="form-label fw-bold">
                        <i class="fas fa-calendar-week me-1"></i>
                        Tháng
                    </label>

                    <select name="month" class="form-select">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}"
                                ${m == selectedMonth ? 'selected' : ''}>
                                Tháng ${m}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-4">
                    <button type="submit" class="btn btn-dark w-100">
                        <i class="fas fa-chart-line me-2"></i>
                        Xem thống kê
                    </button>
                </div>

            </form>
        </div>
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card text-white text-center" style="background: linear-gradient(135deg, #3C2F27, #5A463A); border-radius: 20px;">
                    <div class="card-body">
                        <p class="mb-2 opacity-75">Doanh thu tháng ${selectedMonth}/${selectedYear}</p>
                        <h3 class="fw-bold"><fmt:formatNumber value="${dashboard.currentMonthRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h3>
                        <small class="${dashboard.currentMonthRevenue >= dashboard.previousMonthRevenue ? 'text-success' : 'text-danger'}">
                            <i class="fas ${dashboard.currentMonthRevenue >= dashboard.previousMonthRevenue ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                            ${dashboard.monthlyGrowthRate}
                        </small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-white text-center" style="background: linear-gradient(135deg, #5A463A, #7A5C4A); border-radius: 20px;">
                    <div class="card-body">
                        <p class="mb-2 opacity-75">Doanh thu tháng trước</p>
                        <h3 class="fw-bold"><fmt:formatNumber value="${dashboard.previousMonthRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-white text-center" style="background: linear-gradient(135deg, #D4A76A, #C19A6B); border-radius: 20px;">
                    <div class="card-body">
                        <p class="mb-2 opacity-75">Doanh thu năm ${selectedYear}</p>
                        <h3 class="fw-bold"><fmt:formatNumber value="${dashboard.currentYearRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h3>
                        <small class="${dashboard.currentYearRevenue >= dashboard.previousYearRevenue ? 'text-success' : 'text-danger'}">
                            <i class="fas ${dashboard.currentYearRevenue >= dashboard.previousYearRevenue ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                            vs năm trước
                        </small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card text-white text-center" style="background: linear-gradient(135deg, #E7C79B, #D4A76A); border-radius: 20px;">
                    <div class="card-body">
                        <p class="mb-2 opacity-75">Doanh thu năm ${selectedYear-1}</p>
                        <h3 class="fw-bold"><fmt:formatNumber value="${dashboard.previousYearRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h3>
                    </div>
                </div>
            </div>
        </div>

        <div class="chart-container">
            <div class="chart-title"><i class="fas fa-chart-line"></i> Doanh thu theo năm</div>
            <canvas id="yearlyRevenueChart" height="100"></canvas>
        </div>

        <!-- STATS -->

        <div class="stats-grid">

            <div class="stats-card">
                <div class="stats-icon bg-warning bg-opacity-10">
                    <i class="fas fa-shopping-cart fa-2x text-warning"></i>
                </div>

                <div class="stats-content">
                    <p>Tổng đơn hàng</p>
                    <h3>${dashboard.totalOrders}</h3>
                    <span>đơn hàng</span>
                </div>
            </div>


            <div class="stats-card">
                <div class="stats-icon">
                    <i class="fas fa-dollar-sign fa-2x"></i>
                </div>

                <div class="stats-content">
                    <p>Tổng doanh thu</p>
                    <h3>
                        <fmt:formatNumber
                            value="${dashboard.totalRevenue}"
                            type="currency"
                            currencySymbol="₫"
                            maxFractionDigits="0"/>
                    </h3>
                    <span>VNĐ</span>
                </div>
            </div>

            <div class="stats-card">
                <div class="stats-icon">
                    <i class="fas fa-box fa-2x"></i>
                </div>

                <div class="stats-content">
                    <p>Tổng sản phẩm</p>
                    <h3>${dashboard.totalProducts}</h3>
                    <span>sản phẩm</span>
                </div>
            </div>

            <div class="stats-card">
                <div class="stats-icon">
                    <i class="fas fa-users fa-2x"></i>
                </div>

                <div class="stats-content">
                    <p>Khách hàng</p>
                    <h3>${dashboard.totalUsers}</h3>
                    <span>người dùng</span>
                </div>
            </div>

        </div>

        <!-- CHART -->

        <div class="chart-container">

            <div class="chart-title">
                <i class="fas fa-chart-bar me-2"></i>
                Doanh thu theo tháng
            </div>

            <canvas id="monthlyChart" height="100"></canvas>

        </div>

        <!-- TOP PRODUCT -->

        <div class="chart-container">

            <div class="chart-title">
                <i class="fas fa-fire me-2"></i>
                Top sản phẩm bán chạy nhất
            </div>

            <div class="table-responsive">

                <table class="table table-hover">

                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Mã SP</th>
                        <th>Số lượng bán</th>
                        <th>Doanh thu</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach items="${dashboard.topSellingProducts}"
                               var="p"
                               varStatus="loop">

                        <tr>
                            <td>
                                <span class="badge bg-warning">
                                    ${loop.index + 1}
                                </span>
                            </td>

                            <td>
                                <img src="${pageContext.request.contextPath}/${p.image}"
                                     style="width:45px;height:45px;border-radius:10px;object-fit:cover"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                            </td>

                            <td class="fw-bold">
                                ${p.name}
                            </td>

                            <td>
                                <span class="badge bg-secondary">
                                    ${p.productCode}
                                </span>
                            </td>

                            <td class="fw-bold text-success">
                                ${p.totalSold}
                            </td>

                            <td class="fw-bold text-primary">
                                <fmt:formatNumber
                                        value="${p.totalRevenue}"
                                        type="currency"
                                        currencySymbol="₫"
                                        maxFractionDigits="0"/>
                            </td>
                        </tr>

                    </c:forEach>

                    <c:if test="${empty dashboard.topSellingProducts}">
                        <tr>
                            <td colspan="6" class="text-center py-5">
                                Chưa có dữ liệu
                            </td>
                        </tr>
                    </c:if>

                    </tbody>

                </table>

            </div>

        </div>
        <!-- SLOW MOVING PRODUCT -->

        <div class="chart-container">

            <div class="chart-title">
                <i class="fas fa-turtle me-2"></i>
                Sản phẩm bán chậm (cần nhập nguyên liệu)
            </div>

            <div class="table-responsive">

                <table class="table table-hover">

                    <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Mã SP</th>
                        <th>Số lượng bán</th>
                        <th>Doanh thu</th>
                        <th>Gợi ý</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach items="${dashboard.slowMovingProducts}"
                               var="p"
                               varStatus="loop">

                        <tr>
                            <td>
                                <span class="badge bg-danger">
                                    ${loop.index + 1}
                                </span>
                            </td>

                            <td>
                                <img src="${pageContext.request.contextPath}/${p.image}"
                                     style="width:45px;height:45px;border-radius:10px;object-fit:cover"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                            </td>

                            <td class="fw-bold">${p.name}</td>

                            <td>
                                <span class="badge bg-secondary">
                                    ${p.productCode}
                                </span>
                            </td>

                            <td class="fw-bold text-warning">
                                ${p.totalSold}
                            </td>

                            <td class="fw-bold">
                                <fmt:formatNumber
                                        value="${p.totalRevenue}"
                                        type="currency"
                                        currencySymbol="₫"
                                        maxFractionDigits="0"/>
                            </td>

                            <td>
                                <span class="badge bg-info">
                                    Cần đẩy mạnh
                                </span>
                            </td>
                        </tr>

                    </c:forEach>

                    <c:if test="${empty dashboard.slowMovingProducts}">
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                Chưa có dữ liệu
                            </td>
                        </tr>
                    </c:if>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/admin_dashboard.js"></script>

</body>
</html>