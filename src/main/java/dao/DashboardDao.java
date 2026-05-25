package dao;

import model.DashboardRevenueData;
import utils.JdbiConnector;
import java.math.BigDecimal;
import java.util.List;

public class DashboardDao {

    // Tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM `order`";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    public List<DashboardRevenueData> getMonthlyRevenue(int year) {
        String sql = """
        SELECT MONTH(order_date) as month, COALESCE(SUM(total_amount), 0) as revenue
        FROM `order` 
        WHERE YEAR(order_date) = :year AND order_status = 4
        GROUP BY MONTH(order_date)
        ORDER BY month
        """;

        List<DashboardRevenueData> results = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("year", year)
                        .map((rs, ctx) -> new DashboardRevenueData(rs.getInt("month"), rs.getBigDecimal("revenue")))
                        .list()
        );

        // Đảm bảo đủ 12 tháng
        List<DashboardRevenueData> fullResults = new ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            final int month = i;
            DashboardRevenueData existing = results.stream()
                    .filter(r -> r.getPeriod() == month)
                    .findFirst()
                    .orElse(new DashboardRevenueData(month, BigDecimal.ZERO));
            fullResults.add(existing);
        }
        return fullResults;
    }

    // Tổng doanh thu đối với đơn hàng hoàn thành
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM `order` WHERE order_status = 4";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(BigDecimal.class).one()
        );
    }

    // Tổng sản phẩm
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM product";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    // Tổng người dùng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM user WHERE role = 0"; // role = 0 là khách hàng
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }
}