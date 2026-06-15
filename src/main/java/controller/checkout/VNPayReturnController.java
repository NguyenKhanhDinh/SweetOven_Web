package controller.checkout;

import controller.voucher.PlaceOrderController;
import dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.VNPayPendingOrder;
import service.OrderService;
import utils.EmailUtil;
import utils.VNPayUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/vnpay-return")
public class VNPayReturnController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        Map<String, String> params = new HashMap<>();
        request.getParameterMap().forEach((key, values) -> {
            if (values != null && values.length > 0) {
                params.put(key, values[0]);
            }
        });
        String vnpResponseCode = nvl(params.get("vnp_ResponseCode"));
        String vnpTxnRef = nvl(params.get("vnp_TxnRef"));
        String vnpTransactionNo = nvl(params.get("vnp_TransactionNo"));
        String vnpAmount = nvl(params.get("vnp_Amount"));
        String vnpMessage = vnpResponseCode.equals("00") ? "Thành công" : "Thất bại(mã: " + vnpResponseCode + ")";

        System.out.println("[VNPay Return] TxnRef=" + vnpTxnRef + " ResponseCode=" + vnpResponseCode + " TransactionNo= " + vnpTransactionNo);

        boolean signatureVaild = VNPayUtil.verifySignature(params);
        if (!signatureVaild) {
            System.out.println("[VNPay Return] Chữ ký không hợp lệ! TxnRef=" + vnpTxnRef);
            session.setAttribute("errorMsg", "Thanh toán VNPay thất bại: chữ ký không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        String sessionKey = "vnpay_pending" + vnpTxnRef;
        VNPayPendingOrder pending = (VNPayPendingOrder) session.getAttribute(sessionKey);

        if (!"00".equals(vnpResponseCode) || pending == null) {
            if (pending == null) {
                System.out.println("[VNPay Return] Không tìm thấy pending order. sessionKey=" + sessionKey);
            }
            session.removeAttribute(sessionKey);
            session.setAttribute("errorMsg", "Thanh toán VNPay thất bại hoặc bị hủy. Vui lòng thử lại! (" + vnpMessage + ")");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        Order order = PlaceOrderController.buildOrder(
                pending.orderCode, pending.user, pending.fullName, pending.phone, pending.fullAddr,
                pending.discountId, pending.subTotal, pending.discountAmount, pending.shippingFee,
                pending.totalAmount, pending.note, 3
        );
        int orderId;
        try {
            orderId = orderService.createOrder(order, pending.checkoutItems);
        } catch (Exception e) {
            e.printStackTrace();
            session.removeAttribute(sessionKey);
            session.setAttribute("errorMsg", "Đã thanh toán qua VNPay thành công nhưng lỗi khi lưu đơn hàng." + "Vui lòng liên hệ hỗ trợ! Mã GD: " + vnpTransactionNo);
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        if (orderId <= 0) {
            session.removeAttribute(sessionKey);
            session.setAttribute("errorMsg", "Đã thanh toán qua VNPay thành công nhưng lỗi khi lưu đơn hàng." + "Vui lòng liên hệ hỗ trợ! Mã GD: " + vnpTransactionNo);
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        order.setId(orderId);
        if (pending.user == null && pending.guestEmail != null && !pending.guestEmail.isEmpty()) {
            final String emailTo = pending.guestEmail;
            final Order orderCopy = order;
            final var items = pending.checkoutItems;

            new Thread(() -> {
                try {
                    EmailUtil.sendOrderInvoice(emailTo, orderCopy, items, null);
                    System.out.println("[EMAIL] Đã gửi hóa đơn VNPay tới: " + emailTo);
                } catch (Exception e) {
                    System.err.println("[EMAIL] Lỗi gửi Email VNPay: " + e.getMessage());
                }
            }).start();
            session.setAttribute("invoiceEmailSent", pending.guestEmail);
        }
        PlaceOrderController ctrl =  new PlaceOrderController();
        ctrl.markDiscountUsed(pending.user,pending.discountId);

        session.setAttribute("checkoutSelectedIds", pending.checkoutSelectedIds);
        ctrl.cleanCart(session,pending.user,pending.checkoutItems);

        session.removeAttribute(sessionKey);
        session.setAttribute("paymentSuccess", "Thanh toán qua VNPay thành công! Mã GD: " + vnpTransactionNo + " Đơn hàng sẽ được xử lý sau khi admim xác nhận.");
        response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
    }

    private String nvl(String s) {
        return s == null ? "" : s.trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }


}
