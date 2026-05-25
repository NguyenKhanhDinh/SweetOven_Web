package controller.Admin;

import dao.DashboardDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DashboardData;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Year;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private final DashboardDao dashboardDao = new DashboardDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");

        int year = (yearParam != null && !yearParam.isEmpty())
                ? Integer.parseInt(yearParam)
                : Year.now().getValue();

        int month = (monthParam != null && !monthParam.isEmpty())
                ? Integer.parseInt(monthParam)
                : LocalDate.now().getMonthValue();
        // Doanh thu so sánh
        int previousMonth = month - 1;
        int previousMonthYear = year;
        if (previousMonth < 1) {
            previousMonth = 12;
            previousMonthYear = year - 1;
        }
        DashboardData dashboard = new DashboardData();
        dashboard.setPreviousMonthRevenue(dashboardDao.getRevenueByMonth(previousMonthYear, previousMonth));
        dashboard.setCurrentYearRevenue(dashboardDao.getRevenueByYear(year));
        dashboard.setPreviousYearRevenue(dashboardDao.getRevenueByYear(year - 1));
        dashboard.setYearlyRevenue(dashboardDao.getYearlyRevenue());
        // Thống kê tổng quan
        dashboard.setTotalOrders(dashboardDao.getTotalOrders());
        dashboard.setTotalRevenue(dashboardDao.getTotalRevenue());
        dashboard.setTotalProducts(dashboardDao.getTotalProducts());
        dashboard.setTotalUsers(dashboardDao.getTotalUsers());

        // Doanh thu theo tháng
        dashboard.setMonthlyRevenue(dashboardDao.getMonthlyRevenue(year));

        // Doanh thu theo tháng được chọn
        dashboard.setCurrentMonthRevenue(
                dashboardDao.getRevenueByMonth(year, month)
        );

        //Top 10 sản ohaarm bán chạy nhất
        dashboard.setTopSellingProducts(
                dashboardDao.getTopSellingProducts(10)
        );

        //Top 10 sản pẩm bán chậm
        dashboard.setSlowMovingProducts(
                dashboardDao.getSlowMovingProducts(10)
        );

        request.setAttribute("dashboard", dashboard);
        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("years", dashboardDao.getAvailableYears());

        request.getRequestDispatcher("/adminPage/admin_dashboard.jsp")
                .forward(request, response);
    }
}