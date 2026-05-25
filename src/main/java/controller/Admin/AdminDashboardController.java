package controller.admin;

import dao.DashboardDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DashboardData;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private final DashboardDao dashboardDao = new DashboardDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DashboardData dashboard = new DashboardData();

        // Thống kê tổng quan
        dashboard.setTotalOrders(dashboardDao.getTotalOrders());
        dashboard.setTotalRevenue(dashboardDao.getTotalRevenue());
        dashboard.setTotalProducts(dashboardDao.getTotalProducts());
        dashboard.setTotalUsers(dashboardDao.getTotalUsers());

        request.setAttribute("dashboard", dashboard);
        request.getRequestDispatcher("/adminPage/admin_dashboard.jsp").forward(request, response);
    }
}