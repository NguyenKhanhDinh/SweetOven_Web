package dao;

import model.Order;
import utils.JdbiConnector;

import java.util.List;

public class OrderDao {
    // phương thức để hiển thị đơn hàng ở trang profile
    public List<Order> getOrdersByUserId(int userId) {
        String sql = """
                SELECT *
                FROM `order`
                WHERE user_id = :userId
                ORDER BY order_date DESC
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).mapToBean(Order.class).list());
    }

    // lấy đơn hàng theo id đơn hàng để hiển thị cho trang chi tiết đơn hàng
    public Order getOrderByOrderId(int orderId) {
        String sql = """
                SELECT *
                FROM `order`
                WHERE id = :orderId
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("orderId", orderId).mapToBean(Order.class).findFirst().orElse(null));
    }

    public int insertOrder(Order order) {
        String sql = """
                    INSERT INTO `order`
                    (order_code,user_id,full_name,phone_number,address,discount_id,sub_total,discount_amount,shipping_fee,total_amount,note,payment_method,order_status,order_date)
                    VALUES
                    (:orderCode,:userId,:fullName,:phoneNumber,:address,:discountId,:subTotal,:discountAmount,:shippingFee,:totalAmount,:note,:paymentMethod,:orderStatus,NOW())
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql).bindBean(order)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class).findFirst().orElse(0));
    }

}
