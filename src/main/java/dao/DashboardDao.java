package dao;

import model.DashboardProductSales;
import model.DashboardRevenueData;
import utils.JdbiConnector;
import java.math.BigDecimal;
import java.util.ArrayList;
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
        SELECT 
            MONTH(order_date) as month,
            COALESCE(SUM(total_amount), 0) as revenue
        FROM `order` 
        WHERE YEAR(order_date) = :year 
            AND order_status = 4
        GROUP BY MONTH(order_date)
        ORDER BY month
        """;

        List<DashboardRevenueData> results = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("year", year)
                        .map((rs, ctx) -> new DashboardRevenueData(rs.getInt("month"), rs.getBigDecimal("revenue")))
                        .list()
        );
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
    //Lấy sản phẩm bán chậm cần đấy mạnh
    public List<DashboardProductSales> getSlowMovingProducts(int limit) {
        String sql = """
        SELECT 
            p.id, p.name, p.product_code,
            pi.image_url as image,
            COALESCE(SUM(od.quantity), 0) as total_sold,
            COALESCE(SUM(od.total_price), 0) as total_revenue
        FROM product p
        LEFT JOIN order_detail od ON p.id = od.product_id
        LEFT JOIN `order` o ON od.order_id = o.id AND o.order_status = 4
        LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1
        GROUP BY p.id, p.name, p.product_code, pi.image_url
        ORDER BY total_sold ASC
        LIMIT :limit
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .map((rs, ctx) -> new DashboardProductSales(
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getString("product_code"),
                                rs.getString("image"),
                                rs.getInt("total_sold"),
                                rs.getBigDecimal("total_revenue")
                        ))
                        .list()
        );
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
    public List<DashboardProductSales> getTopSellingProducts(int limit) {
        String sql = """
        SELECT 
            p.id, p.name, p.product_code,
            pi.image_url as image,
            COALESCE(SUM(od.quantity), 0) as total_sold,
            COALESCE(SUM(od.total_price), 0) as total_revenue
        FROM product p
        LEFT JOIN order_detail od ON p.id = od.product_id
        LEFT JOIN `order` o ON od.order_id = o.id AND o.order_status = 4
        LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1
        GROUP BY p.id, p.name, p.product_code, pi.image_url
        ORDER BY total_sold DESC
        LIMIT :limit
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .map((rs, ctx) -> new DashboardProductSales(
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getString("product_code"),
                                rs.getString("image"),
                                rs.getInt("total_sold"),
                                rs.getBigDecimal("total_revenue")
                        ))
                        .list()
        );
    }
    // Doanh thu theo năm
    public BigDecimal getRevenueByYear(int year) {
        String sql = """
        SELECT COALESCE(SUM(total_amount), 0) 
        FROM `order` 
        WHERE YEAR(order_date) = :year AND order_status = 4
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("year", year)
                        .mapTo(BigDecimal.class)
                        .one()
        );
    }

    // Doanh thu theo năm
    public List<DashboardRevenueData> getYearlyRevenue() {
        String sql = """
        SELECT 
            YEAR(order_date) as year,
            COALESCE(SUM(total_amount), 0) as revenue
        FROM `order` 
        WHERE order_status = 4
        GROUP BY YEAR(order_date)
        ORDER BY year ASC
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> new DashboardRevenueData(rs.getInt("year"), rs.getBigDecimal("revenue")))
                        .list()
        );
    }

    // Tổng người dùng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM user WHERE role_id = 2"; // role = 2 là khách hàng
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }
    // Doanh thu theo tháng cụ thể
    public BigDecimal getRevenueByMonth(int year, int month) {
        // Xử lý tháng 0 đến tháng 12 của năm trước
        if (month < 1) {
            month = 12;
            year = year - 1;
        }
        if (month > 12) {
            month = 1;
            year = year + 1;
        }

        String sql = """
        SELECT COALESCE(SUM(total_amount), 0) 
        FROM `order` 
        WHERE YEAR(order_date) = :year 
            AND MONTH(order_date) = :month 
            AND order_status = 4
        """;

        int finalYear = year;
        int finalMonth = month;
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("year", finalYear)
                        .bind("month", finalMonth)
                        .mapTo(BigDecimal.class)
                        .one()
        );
    }

    // Lấy danh sách năm có dữ liệu
    public List<Integer> getAvailableYears() {
        String sql = """
        SELECT DISTINCT YEAR(order_date) as year
        FROM `order`
        ORDER BY year DESC
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .list()
        );
    }
}