package controller.Admin;

import dao.DashboardDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DashboardData;

import java.io.IOException;
import java.time.Year;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private final DashboardDao dashboardDao = new DashboardDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String yearParam = request.getParameter("year");
        int year = (yearParam != null && !yearParam.isEmpty()) ? Integer.parseInt(yearParam) : Year.now().getValue();

        DashboardData dashboard = new DashboardData();

        // Thống kê tổng quan
        dashboard.setTotalOrders(dashboardDao.getTotalOrders());
        dashboard.setTotalRevenue(dashboardDao.getTotalRevenue());
        dashboard.setTotalProducts(dashboardDao.getTotalProducts());
        dashboard.setTotalUsers(dashboardDao.getTotalUsers());

        // Doanh thu theo tháng
        dashboard.setMonthlyRevenue(dashboardDao.getMonthlyRevenue(year));
        //Top 10 sản ohaarm bán chạy nhất
        dashboard.setTopSellingProducts(dashboardDao.getTopSellingProducts(10));

        request.setAttribute("dashboard", dashboard);
        request.setAttribute("selectedYear", year);
        request.getRequestDispatcher("/adminPage/admin_dashboard.jsp").forward(request, response);
    }
}