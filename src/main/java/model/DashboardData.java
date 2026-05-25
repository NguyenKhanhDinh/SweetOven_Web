package model;

import java.math.BigDecimal;
import java.util.List;

public class DashboardData {
    private int totalOrders;
    private BigDecimal totalRevenue;
    private int totalProducts;
    private int totalUsers;
    private List<DashboardRevenueData> monthlyRevenue;
    private List<DashboardRevenueData> yearlyRevenue;
    private List<DashboardProductSales> topSellingProducts;
    private List<DashboardProductSales> slowMovingProducts;
    private BigDecimal currentMonthRevenue;

    public BigDecimal getCurrentMonthRevenue() { return currentMonthRevenue; }
    public void setCurrentMonthRevenue(BigDecimal currentMonthRevenue) { this.currentMonthRevenue = currentMonthRevenue; }
    // Getters and Setters
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
    public List<DashboardRevenueData> getMonthlyRevenue() { return monthlyRevenue; }
    public void setMonthlyRevenue(List<DashboardRevenueData> monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
    public List<DashboardRevenueData> getYearlyRevenue() { return yearlyRevenue; }
    public void setYearlyRevenue(List<DashboardRevenueData> yearlyRevenue) { this.yearlyRevenue = yearlyRevenue; }
    public List<DashboardProductSales> getTopSellingProducts() { return topSellingProducts; }
    public void setTopSellingProducts(List<DashboardProductSales> topSellingProducts) { this.topSellingProducts = topSellingProducts; }
    public List<DashboardProductSales> getSlowMovingProducts() { return slowMovingProducts; }
    public void setSlowMovingProducts(List<DashboardProductSales> slowMovingProducts) { this.slowMovingProducts = slowMovingProducts; }
}