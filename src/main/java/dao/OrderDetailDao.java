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

    public boolean insertOrderDetail(OrderDetail orderDetail) {
        String sql = """
                    INSERT INTO order_detail (order_id,product_id,quantity,buy_price,total_price)
                    VALUES (:orderId,:productId,:quantity,:buyPrice,:totalPrice)
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bindBean(orderDetail).execute() > 0);
    }
}
