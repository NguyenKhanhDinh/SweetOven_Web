package dao;

import model.OrderDetail;
import utils.JdbiConnector;

import java.util.List;

public class OrderDetailDao {
    // lấy chi tiết đơn hàng hiển thị cho trang chi tiết đơn hàng
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        String sql = """
            SELECT 
                od.product_id,
                od.quantity,
                od.buy_price AS buyPrice,
                od.total_price AS totalPrice,
                p.name AS productName,
                pi.image_url AS productImage
            FROM order_detail od
            LEFT JOIN product p ON od.product_id = p.id
            LEFT JOIN productimage pi 
                ON p.id = pi.product_id 
                AND pi.is_primary = 1
            WHERE od.order_id = :orderId
        """;
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderId", orderId)
                        .mapToBean(OrderDetail.class)
                        .list()
        );
    }
}
