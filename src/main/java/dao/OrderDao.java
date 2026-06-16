package dao;

import model.Order;
import model.OrderDetail;
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

    public boolean updateOrderCode(int orderId, String newCode) {
        String sql = " UPDATE `order` SET order_code = :orderCode,updated_at = NOW() WHERE id = :orderId ";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("orderCode", newCode).bind("orderId", orderId).execute()>0);
    }
    @Deprecated
    public void updateGhnOrderCode(int orderId, String ghnOrderCode) {
        updateOrderCode(orderId, ghnOrderCode);
    }

    public void cancleOrder(int orderId, String reason) {
        String sql = """
                        UPDATE `order`
                        SET 
                        order_status = 5,
                        cancel_reason = :reason,
                        updated_at = NOW()
                        WHERE id = :orderId
                """;
        JdbiConnector.getJdbi().useHandle(handle -> handle.createUpdate(sql).bind("reason", reason).bind("orderId", orderId).execute());
    }

    // admin
    public int countAllOrders() {
        String sql = "SELECT COUNT(*) FROM `order`";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countOrdersByStatus(int status) {
        String sql = "SELECT COUNT(*) FROM `order` WHERE order_status = :status";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("status", status).mapTo(Integer.class).one());
    }

    public int countOrdersToday() {
        String sql = "SELECT COUNT(*) FROM `order` WHERE DATE(order_date) = CURDATE()";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public List<Order> getOrders(String keyword, int status, int paymentMethod, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("""
                SELECT o.id,o.order_code AS orderCode,o.user_id AS userId,o.full_name AS fullName,
                        o.phone_number AS phoneNumber,o.address,o.discount_id AS discountId,o.sub_total AS subTotal,
                        o.discount_amount AS discountAmount,o.shipping_fee AS shippingFee,o.total_amount AS totalAmount,
                        o.note,o.payment_method AS paymentMethod,o.order_status AS orderStatus,o.cancel_reason AS cancelReason,
                        o.order_date AS orderDate,o.updated_at AS updatedAt FROM `order` o WHERE 1=1
                """
        );
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (o.order_code LIKE :kw OR o.full_name LIKE :kw OR o.phone_number LIKE :kw)");
        }
        if (status >= 0) {
            sql.append(" AND (o.order_status = :status)");
        }
        if (paymentMethod >= 0) {
            sql.append(" AND (o.payment_method = :paymentMethod)");
        }
        sql.append(" ORDER BY o.order_date DESC LIMIT :limit OFFSET :offset");

        int offset = (page - 1) * pageSize;
        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (keyword != null && !keyword.isBlank()) query.bind("kw", kw);
            if (status >= 0) query.bind("status", status);
            if (paymentMethod >= 0) query.bind("paymentMethod", paymentMethod);
            query.bind("limit", pageSize).bind("offset", offset);
            return query.mapToBean(Order.class).list();
        });
    }

    public int countOrders(String keyword, int status, int paymentMethod) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM `order` o WHERE 1=1");

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (o.order_code LIKE :kw OR o.full_name LIKE :kw OR o.phone_number LIKE :kw)");
        }
        if (status >= 0) {
            sql.append(" AND (o.order_status = :status)");
        }
        if (paymentMethod >= 0) {
            sql.append(" AND (o.payment_method = :paymentMethod)");
        }
        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (keyword != null && !keyword.isBlank()) query.bind("kw", kw);
            if (status >= 0) query.bind("status", status);
            if (paymentMethod >= 0) query.bind("paymentMethod", paymentMethod);
            return query.mapTo(Integer.class).one();
        });
    }

    public Order findById(int orderId) {
        String sql = """
                SELECT o.id,o.order_code AS orderCode,o.user_id AS userId,o.full_name AS fullName,o.phone_number AS phoneNumber,o.address,
                o.discount_id AS discountId,o.sub_total AS subTotal,o.discount_amount AS discountAmount,o.shipping_fee AS shippingFee,o.total_amount AS totalAmount,
                o.note,o.payment_method AS paymentMethod,o.order_status AS orderStatus,o.cancel_reason AS cancelReason,o.order_date AS orderDate,o.updated_at AS updatedAt
                FROM `order` o WHERE o.id = :orderId
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("orderId", orderId).mapToBean(Order.class).findFirst().orElse(null));
    }

    public List<OrderDetail> getOrderDetails(int orderId) {
        String sql = """
                SELECT od.id,od.order_id AS orderId,od.product_id AS productId,od.quantity,od.buy_price AS buyPrice,od.total_price AS totalPrice,
                p.name AS productName,pi.image_url AS productImage
                FROM order_detail od LEFT JOIN product p  ON od.product_id = p.id
                LEFT JOIN productimage pi ON od.product_id = pi.product_id AND pi.is_primary = 1
                WHERE od.order_id = :orderId
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("orderId", orderId).mapToBean(OrderDetail.class).list());
    }
    public boolean updateOrderStatus(int orderId, int newStatus) {
        String sql = " UPDATE `order` SET order_status = :status, updated_at = NOW() WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("status",newStatus).bind("id",orderId).execute()>0);
    }
    public boolean cancelOrderAdmin(int orderId,String reason) {
        String sql = "UPDATE `order` SET order_status = 5,cancel_reason = :reason,updated_at = NOW() WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("reason",reason).bind("id",orderId).execute()>0);
    }
    public Order getOrderByOrderCode(String orderCode) {
        String sql = "SELECT * FROM `order` WHERE order_code = :orderCode";
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).bind("orderCode",orderCode).mapToBean(Order.class).findFirst().orElse(null));
    }
}
