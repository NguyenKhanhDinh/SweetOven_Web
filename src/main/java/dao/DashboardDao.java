package dao;

import utils.JdbiConnector;
import java.math.BigDecimal;

public class DashboardDao {

    // Tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM `order`";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
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

    // Tổng người dùng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM user WHERE role = 0"; // role = 0 là khách hàng
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }
}