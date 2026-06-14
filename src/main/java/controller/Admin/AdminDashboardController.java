package controller.Admin;

import jakarta.servlet.http.HttpSession;
import model.User;
import service.DashboardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DashboardData;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Year;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User adminUser = (User) session.getAttribute("user");
        if (adminUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");
        String action = request.getParameter("action");

        int year = (yearParam != null && !yearParam.isEmpty())
                ? Integer.parseInt(yearParam)
                : Year.now().getValue();

        int month = (monthParam != null && !monthParam.isEmpty())
                ? Integer.parseInt(monthParam)
                : LocalDate.now().getMonthValue();

        // Xử lý in báo cáo
        if ("print".equals(action)) {
            handlePrint(request, response, year, month);
            return;
        }

        // Lấy dữ liệu dashboard qua service
        DashboardData dashboard = dashboardService.getDashboardData(year, month);

        // Set attributes cho JSP
        request.setAttribute("dashboard", dashboard);
        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("years", dashboardService.getAvailableYears());

        request.getRequestDispatcher("/adminPage/admin_dashboard.jsp")
                .forward(request, response);
    }

    private void handlePrint(HttpServletRequest request, HttpServletResponse response, int year, int month)
            throws ServletException, IOException {

        // Lấy dữ liệu báo cáo in qua service
        DashboardData dashboard = dashboardService.getPrintReportData(year, month);

        // Format ngày in
        String printDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date());

        // Set attributes cho JSP in
        request.setAttribute("dashboard", dashboard);
        request.setAttribute("selectedYear", year);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("printDate", printDate);

        request.getRequestDispatcher("/adminPage/print_report_dashboard.jsp")
                .forward(request, response);
    }
}