package controller.momo;

import controller.voucher.PlaceOrderController;
import dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MomoPendingOrder;
import model.Order;
import service.OrderService;
import utils.EmailUtil;
import utils.MomoUtil;

import java.io.IOException;
import java.util.Base64;

@WebServlet("/momo-return")
public class MoMoReturnController extends HttpServlet {
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

        String partnerCode = nlv(request.getParameter("partnerCode"));
        String orderCode = nlv(request.getParameter("orderId"));
        String requestId = nlv(request.getParameter("requestId"));
        String amount = nlv(request.getParameter("amount"));
        String orderInfo = nlv(request.getParameter("orderInfo"));
        String orderType = nlv(request.getParameter("orderType"));
        String transId = nlv(request.getParameter("transId"));
        String resultCode = nlv(request.getParameter("resultCode"));
        String message = nlv(request.getParameter("message"));
        String payType = nlv(request.getParameter("payType"));
        String responseTime = nlv(request.getParameter("responseTime"));
        String extraData = nlv(request.getParameter("extraData"));
        String signature = nlv(request.getParameter("signature"));

        String sessionKey = "";
        try {
            sessionKey = new String(Base64.getDecoder().decode(extraData), "UTF-8");
        } catch (Exception e) {
            System.err.println("[MoMo Return] Không giải mã được extraData: " + extraData);
        }
        String rawSignature = "accessKey=" + "F8BBA842ECF85" + "&amount=" + amount + "&extraData=" + extraData
                + "&message=" + message + "&orderId=" + orderCode + "&orderInfo=" + orderInfo + "&orderType=" + orderType
                + "&partnerCode=" + partnerCode + "&payType=" + payType + "&requestId=" + requestId + "&responseTime=" + responseTime
                + "&resultCode=" + resultCode + "&transId=" + transId;
        boolean signaturevaild = MomoUtil.verifySignature(rawSignature, signature);
        System.out.println("[MoMo Return] orderCode: " + orderCode + " resultCode: " + resultCode + " signtureValid: " + signaturevaild + " sessionKey: " + sessionKey);

        MomoPendingOrder pending = null;
        if (!sessionKey.isEmpty()) {
            pending = (MomoPendingOrder) session.getAttribute(sessionKey);
        }
        if (!"0".equals(resultCode) || !signaturevaild || pending == null) {
            if (pending == null) {
                System.err.println("[MoMo Return] Không tìm thấy pending order,sessionKey=" + sessionKey);
            }
            if (!sessionKey.isEmpty()) session.removeAttribute(sessionKey);

            session.setAttribute("errorMsg", "Thanh toán MoMo thất bại hoặc bị hủy. Vui long thử lại! (" + message + ")");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        Order order = PlaceOrderController.buildOrder(pending.orderCode, pending.user
                , pending.fullName, pending.phone, pending.fullAddr, pending.discountId
                , pending.subTotal, pending.discountAmount, pending.shippingFee, pending.totalAmount, pending.note, 2);
        int orderId;
        try {
            orderId = orderService.createOrder(order, pending.checkoutItems);
        } catch (Exception e) {
            e.printStackTrace();
            session.removeAttribute(sessionKey);
            session.setAttribute("errorMsg", "Đã thanh toán qua MoMo thành công nhưng lỗi khi lưu đơn hàng. Vui lòng liên hệ hỗ trợ! Mã giao dịch: " + transId);
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        if (orderId <= 0) {
            session.removeAttribute(sessionKey);
            session.setAttribute("errorMsg", "Đã thanh toán qua MoMo thành công nhưng lỗi khi lưu đơn hàng. Vui lòng liên hệ hỗ trợ! Mã giao dịch: " + transId);
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        order.setId(orderId);
        String ghnOrderCode = PlaceOrderController.createGhnOrder(pending.fullName, pending.phone
                , pending.fullAddr, pending.ghnDistrictId, pending.ghnWardCode, pending.province
                , pending.district, pending.ward, pending.totalAmount, pending.note, orderId, session);

        if (pending.user == null && pending.guestEmail != null && !pending.guestEmail.isEmpty()) {
            final String emailTo = pending.guestEmail;
            final String finalGhn = ghnOrderCode;
            final Order orderCopy = order;
            final var items = pending.checkoutItems;
            new Thread(() -> {
                try {
                    EmailUtil.sendOrderInvoice(emailTo, orderCopy, items, finalGhn);
                    System.out.println("[EMAIL] Đã gửi hóa đơn MoMo tới: " + emailTo);
                } catch (Exception e) {
                    System.err.println("[EMAIL] Lỗi gửi Email MoMo:" + e.getMessage());
                }
            }).start();
            session.setAttribute("invoiceEmailSent", pending.guestEmail);
        }
        PlaceOrderController ctrl = new PlaceOrderController();
        ctrl.markDiscountUsed(pending.user, pending.discountId);

        session.setAttribute("checkoutSelectedIds", pending.checkoutSelectedIds);
        ctrl.cleanCart(session, pending.user, pending.checkoutItems);

        session.removeAttribute(sessionKey);

        session.setAttribute("paymentSuccess", "Thanh toán MoMo thành công! Mã GD: " + transId);
        response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);

    }

    private String nlv(String s) {
        return s == null ? "" : s.trim();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
