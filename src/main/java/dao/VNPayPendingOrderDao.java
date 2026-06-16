package dao;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.CartItem;
import model.VNPayPendingOrder;
import utils.JdbiConnector;


import java.util.List;

public class VNPayPendingOrderDao {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    public boolean save(VNPayPendingOrder vnPayPendingOrder) {
        try {
            String itemsJson = objectMapper.writeValueAsString(vnPayPendingOrder.checkoutItems);
            String sql = """
                    INSERT INTO  vnpay_pending_order
                    (order_code,user_id,guest_email,full_name,phone,full_addr,ward,district,province,note,ghn_district_id,ghn_ward_code,
                    discount_id,sub_total,discount_amount,shipping_fee,total_amount,checkout_items,checkout_selected_ids,created_at,expired_at)
                    VALUES(:orderCode,:userId,:guestEmail,:fullName,:phone,:fullAddr,:ward,:district,:province,:note,:ghnDistrictId,:ghnWardCode,
                    :discountId,:subTotal,:discountAmount,:shippingFee,:totalAmount,:checkoutItems,:checkoutSelectedIds,NOW(),NOW()+INTERVAL 30 MINUTE)
                    """;
            int row = JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql)
                    .bind("orderCode", vnPayPendingOrder.orderCode)
                    .bind("userId", vnPayPendingOrder.userId)
                    .bind("guestEmail", vnPayPendingOrder.guestEmail)
                    .bind("fullName", vnPayPendingOrder.fullName)
                    .bind("phone", vnPayPendingOrder.phone)
                    .bind("fullAddr", vnPayPendingOrder.fullAddr)
                    .bind("ward", vnPayPendingOrder.ward)
                    .bind("district", vnPayPendingOrder.district)
                    .bind("province", vnPayPendingOrder.province)
                    .bind("note", vnPayPendingOrder.note)
                    .bind("ghnDistrictId", vnPayPendingOrder.ghnDistrictId)
                    .bind("ghnWardCode", vnPayPendingOrder.ghnWardCode)
                    .bind("discountId", vnPayPendingOrder.discountId)
                    .bind("subTotal", vnPayPendingOrder.subTotal)
                    .bind("discountAmount", vnPayPendingOrder.discountAmount)
                    .bind("shippingFee", vnPayPendingOrder.shippingFee)
                    .bind("totalAmount", vnPayPendingOrder.totalAmount)
                    .bind("checkoutItems", itemsJson)
                    .bind("checkoutSelectedIds", vnPayPendingOrder.checkoutSelectedIds).execute());
            return row > 0;

        } catch (Exception e) {
            System.err.println("[VNPayPendingOrderDao] Lỗi save: " + e.getMessage());
            return false;
        }
    }

    public VNPayPendingOrder findByOrderCode(String orderCode) {
        try {
            String sql = "SELECT * FROM vnpay_pending_order WHERE order_code = :orderCode AND  expired_at > NOW()";
            return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql)
                    .bind("orderCode", orderCode)
                    .map((rs, ctx) -> {
                        VNPayPendingOrder p = new VNPayPendingOrder();
                        p.orderCode = rs.getString("order_code");
                        p.guestEmail = rs.getString("guest_email");
                        p.fullName = rs.getString("full_name");
                        p.phone = rs.getString("phone");
                        p.fullAddr = rs.getString("full_addr");
                        p.ward = rs.getString("ward");
                        p.district = rs.getString("district");
                        p.province = rs.getString("province");
                        p.note = rs.getString("note");
                        p.ghnDistrictId = rs.getInt("ghn_district_id");
                        p.ghnWardCode = rs.getString("ghn_ward_code");
                        p.discountId = (Integer) rs.getObject("discount_id");
                        p.subTotal = rs.getBigDecimal("sub_total");
                        p.discountAmount = rs.getBigDecimal("discount_amount");
                        p.shippingFee = rs.getBigDecimal("shipping_fee");
                        p.totalAmount = rs.getBigDecimal("total_amount");
                        p.checkoutSelectedIds = rs.getString("checkout_selected_ids");

                        try {
                            String json = rs.getString("checkout_items");
                            p.checkoutItems = objectMapper.readValue(json, new TypeReference<List<CartItem>>() {
                            });
                        } catch (Exception e) {
                            System.err.println("[VNPayOrderPendingDao] Lỗi parse checkoutItems: " + e.getMessage());
                            p.checkoutItems = List.of();
                        }
                        p.userId = rs.getObject("user_id") != null ? rs.getInt("user_id") : null;
                        return p;

                    }).findFirst().orElse(null));
        }catch (Exception e) {
            System.err.println("[VNPayOrderPendingDao] Lỗi findByOrderCode: " + e.getMessage());
            return null;
        }
    }
    public void delete(String orderCode) {
        try {
            JdbiConnector.getJdbi().useHandle(handle -> {
                handle.createUpdate("DELETE FROM vnpay_pending_order WHERE order_code = :orderCode").bind("orderCode", orderCode).execute();
            });
        }catch (Exception e){
            System.err.println("[VNPayOrderPendingDao] Lỗi delete: " + e.getMessage());
        }
    }
}
