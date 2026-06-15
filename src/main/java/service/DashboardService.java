package service;

import dao.DashboardDao;
import model.DashboardData;
import model.DashboardProductSales;
import model.DashboardRevenueData;

import java.math.BigDecimal;
import java.util.List;

public class DashboardService {
    private DashboardDao dashboardDao = new DashboardDao();

    // Lấy tổng số đơn hàng
    public int getTotalOrders() {
        return dashboardDao.getTotalOrders();
    }

    // Lấy tổng doanh thu
    public BigDecimal getTotalRevenue() {
        return dashboardDao.getTotalRevenue();
    }

    // Lấy tổng số sản phẩm
    public int getTotalProducts() {
        return dashboardDao.getTotalProducts();
    }

    // Lấy tổng số người dùng
    public int getTotalUsers() {
        return dashboardDao.getTotalUsers();
    }

    // Lấy doanh thu theo năm
    public BigDecimal getRevenueByYear(int year) {
        return dashboardDao.getRevenueByYear(year);
    }

    // Lấy doanh thu theo tháng cụ thể
    public BigDecimal getRevenueByMonth(int year, int month) {
        return dashboardDao.getRevenueByMonth(year, month);
    }

    // Lấy doanh thu theo từng tháng trong năm
    public List<DashboardRevenueData> getMonthlyRevenue(int year) {
        return dashboardDao.getMonthlyRevenue(year);
    }

    public List<DashboardRevenueData> getWeeklyRevenue(int year, int month) {
        return dashboardDao.getWeeklyRevenue(year, month);
    }

    // Lấy doanh thu theo từng năm
    public List<DashboardRevenueData> getYearlyRevenue() {
        return dashboardDao.getYearlyRevenue();
    }

    // Lấy top sản phẩm bán chạy
    public List<DashboardProductSales> getTopSellingProducts(int limit) {
        return dashboardDao.getTopSellingProducts(limit);
    }

    // Lấy sản phẩm bán chậm
    public List<DashboardProductSales> getSlowMovingProducts(int limit) {
        return dashboardDao.getSlowMovingProducts(limit);
    }

    // Lấy danh sách năm có dữ liệu
    public List<Integer> getAvailableYears() {
        return dashboardDao.getAvailableYears();
    }

    // Lấy toàn bộ dữ liệu dashboard cho 1 năm và tháng cụ thể
    public DashboardData getDashboardData(int year, int month) {
        // Tính toán tháng trước đó để so sánh
        int previousMonth = month - 1;
        int previousMonthYear = year;
        if (previousMonth < 1) {
            previousMonth = 12;
            previousMonthYear = year - 1;
        }

        DashboardData dashboard = new DashboardData();

        // Doanh thu so sánh
        dashboard.setPreviousMonthRevenue(getRevenueByMonth(previousMonthYear, previousMonth));
        dashboard.setCurrentYearRevenue(getRevenueByYear(year));
        dashboard.setPreviousYearRevenue(getRevenueByYear(year - 1));
        dashboard.setYearlyRevenue(getYearlyRevenue());

        // Thống kê tổng quan
        dashboard.setTotalOrders(getTotalOrders());
        dashboard.setTotalRevenue(getTotalRevenue());
        dashboard.setTotalProducts(getTotalProducts());
        dashboard.setTotalUsers(getTotalUsers());

        dashboard.setWeeklyRevenue(getWeeklyRevenue(year,month));

        // Doanh thu theo tháng
        dashboard.setMonthlyRevenue(getMonthlyRevenue(year));

        // Doanh thu theo tháng được chọn
        dashboard.setCurrentMonthRevenue(getRevenueByMonth(year, month));

        // Top 10 sản phẩm bán chạy nhất
        dashboard.setTopSellingProducts(getTopSellingProducts(10));

        // Top 10 sản phẩm bán chậm
        dashboard.setSlowMovingProducts(getSlowMovingProducts(10));

        return dashboard;
    }

    // Lấy dữ liệu cho báo cáo in
    public DashboardData getPrintReportData(int year, int month) {
        DashboardData dashboard = new DashboardData();

        // Thống kê tổng quan
        dashboard.setTotalOrders(getTotalOrders());
        dashboard.setTotalRevenue(getTotalRevenue());
        dashboard.setTotalProducts(getTotalProducts());
        dashboard.setTotalUsers(getTotalUsers());

        // Doanh thu theo tháng được chọn
        dashboard.setCurrentMonthRevenue(getRevenueByMonth(year, month));

        // Top sản phẩm
        dashboard.setTopSellingProducts(getTopSellingProducts(20));
        dashboard.setSlowMovingProducts(getSlowMovingProducts(20));

        // Doanh thu theo năm
        dashboard.setYearlyRevenue(getYearlyRevenue());
        dashboard.setCurrentYearRevenue(getRevenueByYear(year));
        dashboard.setPreviousYearRevenue(getRevenueByYear(year - 1));

        return dashboard;
    }
}