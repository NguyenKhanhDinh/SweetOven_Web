package model;

import java.math.BigDecimal;

public class DashboardRevenueData {
    private int period;
    private BigDecimal revenue;

    public DashboardRevenueData() {}
    public DashboardRevenueData(int period, BigDecimal revenue) {
        this.period = period;
        this.revenue = revenue;
    }
    public int getPeriod() { return period; }
    public void setPeriod(int period) { this.period = period; }
    public BigDecimal getRevenue() { return revenue; }
    public void setRevenue(BigDecimal revenue) { this.revenue = revenue; }
}