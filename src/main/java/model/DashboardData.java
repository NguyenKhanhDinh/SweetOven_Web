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
    private List<DashboardRevenueData> weeklyRevenue;
    private List<DashboardProductSales> topSellingProducts;
    private List<DashboardProductSales> slowMovingProducts;
    private BigDecimal currentMonthRevenue;
    private BigDecimal previousMonthRevenue;
    private BigDecimal currentYearRevenue;
    private BigDecimal previousYearRevenue;

    // Getters & Setters
    public BigDecimal getPreviousMonthRevenue() { return previousMonthRevenue; }
    public void setPreviousMonthRevenue(BigDecimal previousMonthRevenue) { this.previousMonthRevenue = previousMonthRevenue; }
    public BigDecimal getCurrentYearRevenue() { return currentYearRevenue; }
    public void setCurrentYearRevenue(BigDecimal currentYearRevenue) { this.currentYearRevenue = currentYearRevenue; }
    public BigDecimal getPreviousYearRevenue() { return previousYearRevenue; }
    public void setPreviousYearRevenue(BigDecimal previousYearRevenue) { this.previousYearRevenue = previousYearRevenue; }

    public String getMonthlyGrowthRate() {
        if (previousMonthRevenue == null || previousMonthRevenue.compareTo(BigDecimal.ZERO) == 0) {
            return "+100%";
        }
        BigDecimal growth = currentMonthRevenue.subtract(previousMonthRevenue)
                .divide(previousMonthRevenue, 2, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100));
        return (growth.compareTo(BigDecimal.ZERO) >= 0 ? "+" : "") + growth + "%";
    }
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
    public List<DashboardRevenueData> getWeeklyRevenue() { return this.weeklyRevenue; }
    public void setWeeklyRevenue(List<DashboardRevenueData> list) { this.weeklyRevenue = list; }
    public List<DashboardRevenueData> getMonthlyRevenue() { return monthlyRevenue; }
    public void setMonthlyRevenue(List<DashboardRevenueData> monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
    public List<DashboardRevenueData> getYearlyRevenue() { return yearlyRevenue; }
    public void setYearlyRevenue(List<DashboardRevenueData> yearlyRevenue) { this.yearlyRevenue = yearlyRevenue; }
    public List<DashboardProductSales> getTopSellingProducts() { return topSellingProducts; }
    public void setTopSellingProducts(List<DashboardProductSales> topSellingProducts) { this.topSellingProducts = topSellingProducts; }
    public List<DashboardProductSales> getSlowMovingProducts() { return slowMovingProducts; }
    public void setSlowMovingProducts(List<DashboardProductSales> slowMovingProducts) { this.slowMovingProducts = slowMovingProducts; }
}