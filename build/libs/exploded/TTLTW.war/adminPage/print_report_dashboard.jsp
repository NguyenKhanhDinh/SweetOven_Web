<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sweet Oven - In báo cáo thống kê</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/print_report_dashboard.css">
</head>
<body>
<div class="report-container">
    <div class="no-print">
        <button onclick="window.print()" style="background:#2f5597">
            <i class="fas fa-print"></i> In báo cáo
        </button>

        <button onclick="window.close()" style="background:#6c757d">
            <i class="fas fa-times"></i> Đóng
        </button>

        <button
            onclick="window.location.href='${pageContext.request.contextPath}/admin/dashboard?year=${selectedYear}&month=${selectedMonth}'"
            style="background:#198754">
            <i class="fas fa-arrow-left"></i> Dashboard
        </button>
    </div>

    <div class="document-header">

        <div class="company-section">
            <div class="company-name">
                SWEET OVEN
            </div>

            <div class="company-desc">
                Hệ thống quản lý và kinh doanh bánh ngọt
            </div>
        </div>

        <div class="report-number">
            Báo cáo tháng ${selectedMonth}/${selectedYear}
        </div>

    </div>

    <div class="report-title">
        <h1>BÁO CÁO THỐNG KÊ DOANH THU</h1>

        <p>
            Tháng ${selectedMonth} năm ${selectedYear}
        </p>
    </div>

    <div class="info-line">
        Ngày lập báo cáo: ${printDate}
    </div>

    <div class="section-title">
        I. TỔNG QUAN HOẠT ĐỘNG KINH DOANH
    </div>

    <table class="summary-table">

        <tr>
            <td>Tổng số đơn hàng</td>
            <td>${dashboard.totalOrders}</td>
        </tr>

        <tr>
            <td>Tổng doanh thu</td>
            <td>
                <fmt:formatNumber
                    value="${dashboard.totalRevenue}"
                    type="currency"
                    currencySymbol="₫"
                    maxFractionDigits="0"/>
            </td>
        </tr>

        <tr>
            <td>Tổng sản phẩm</td>
            <td>${dashboard.totalProducts}</td>
        </tr>

        <tr>
            <td>Tổng khách hàng</td>
            <td>${dashboard.totalUsers}</td>
        </tr>

    </table>

    <div class="section-title">
        II. PHÂN TÍCH DOANH THU
    </div>

    <table class="summary-table">

        <tr>
            <td>Doanh thu tháng ${selectedMonth}/${selectedYear}</td>
            <td>
                <fmt:formatNumber
                    value="${dashboard.currentMonthRevenue}"
                    type="currency"
                    currencySymbol="₫"
                    maxFractionDigits="0"/>
            </td>
        </tr>

        <tr>
            <td>Doanh thu năm ${selectedYear}</td>
            <td>
                <fmt:formatNumber
                    value="${dashboard.currentYearRevenue}"
                    type="currency"
                    currencySymbol="₫"
                    maxFractionDigits="0"/>
            </td>
        </tr>

        <tr>
            <td>Doanh thu năm ${selectedYear - 1}</td>
            <td>
                <fmt:formatNumber
                    value="${dashboard.previousYearRevenue}"
                    type="currency"
                    currencySymbol="₫"
                    maxFractionDigits="0"/>
            </td>
        </tr>

    </table>

    <div class="section-title">
        III. TOP SẢN PHẨM BÁN CHẠY
    </div>

    <table class="report-table">

        <thead>
            <tr>
                <th>STT</th>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Mã SP</th>
                <th>Số lượng bán</th>
                <th>Doanh thu</th>
            </tr>
        </thead>

        <tbody>

            <c:forEach items="${dashboard.topSellingProducts}" var="p" varStatus="loop">

                <tr>

                    <td class="text-center rank">
                        ${loop.index + 1}
                    </td>

                    <td class="text-center">
                        <img
                            src="${p.image}"
                            class="product-img"
                            onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                    </td>

                    <td>${p.name}</td>

                    <td class="text-center">
                        ${p.productCode}
                    </td>

                    <td class="text-right">
                        ${p.totalSold}
                    </td>

                    <td class="text-right">
                        <fmt:formatNumber
                            value="${p.totalRevenue}"
                            type="currency"
                            currencySymbol="₫"
                            maxFractionDigits="0"/>
                    </td>

                </tr>

            </c:forEach>

        </tbody>

    </table>

    <div class="section-title">
        IV. SẢN PHẨM CÓ DOANH SỐ THẤP
    </div>

    <table class="report-table">

        <thead>
            <tr>
                <th>STT</th>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Mã SP</th>
                <th>Số lượng bán</th>
                <th>Doanh thu</th>
            </tr>
        </thead>

        <tbody>

            <c:forEach items="${dashboard.slowMovingProducts}" var="p" varStatus="loop">

                <tr>

                    <td class="text-center">
                        ${loop.index + 1}
                    </td>

                    <td class="text-center">
                        <img
                            src="${p.image}"
                            class="product-img"
                            onerror="this.src='${pageContext.request.contextPath}/assets/picture/logo.png'">
                    </td>

                    <td>${p.name}</td>

                    <td class="text-center">
                        ${p.productCode}
                    </td>

                    <td class="text-right">
                        ${p.totalSold}
                    </td>

                    <td class="text-right">
                        <fmt:formatNumber
                            value="${p.totalRevenue}"
                            type="currency"
                            currencySymbol="₫"
                            maxFractionDigits="0"/>
                    </td>

                </tr>

            </c:forEach>

        </tbody>

    </table>

    <div class="section-title">
        V. NHẬN XÉT VÀ ĐÁNH GIÁ
    </div>

    <div class="analysis-box">

        <ul>

            <li>
                Tổng doanh thu ghi nhận trong tháng
                <strong>${selectedMonth}/${selectedYear}</strong>
                đạt
                <strong>
                    <fmt:formatNumber
                        value="${dashboard.currentMonthRevenue}"
                        type="currency"
                        currencySymbol="₫"
                        maxFractionDigits="0"/>
                </strong>.
            </li>

            <li>
                Các sản phẩm thuộc nhóm bán chạy đang đóng góp phần lớn doanh thu của cửa hàng.
            </li>

            <li>
                Một số sản phẩm doanh số thấp cần được xem xét triển khai chương trình khuyến mãi,
                điều chỉnh giá bán hoặc tăng cường hoạt động marketing.
            </li>

            <li>
                Đề xuất tiếp tục theo dõi xu hướng tiêu dùng để tối ưu cơ cấu sản phẩm và tồn kho.
            </li>

        </ul>

    </div>

    <div class="footer-sign">

        <div class="sign-box">

            <div class="sign-title">
                Người lập báo cáo
            </div>

            <div class="sign-note">
                (Ký và ghi rõ họ tên)
            </div>

        </div>

        <div class="sign-box">

            <div class="sign-title">
                Quản lý cửa hàng
            </div>

            <div class="sign-note">
                (Ký và ghi rõ họ tên)
            </div>

        </div>

    </div>

</div>
</body>
</html>