package controller.checkout;

import controller.voucher.PlaceOrderController;
import dao.UserDao;
import dao.VNPayPendingOrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.User;
import model.VNPayPendingOrder;
import service.OrderService;
import service.UserService;
import utils.VNPayUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/vnpay-ipn")
public class VNPayIpnController extends HttpServlet {
    private static final VNPayPendingOrderDao vnPayPendingOrderDao = new VNPayPendingOrderDao();
    private static final OrderService orderService = new OrderService();
    private static final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleIpn(request, response);
    }

    private void handleIpn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        Map<String, String> params = new HashMap<>();
        request.getParameterMap().forEach((key, values) -> {
            if (values != null && values.length > 0) {
                params.put(key, values[0]);
            }
        });
        String vnpTxnRef = params.getOrDefault("vnp_TxnRef", "");
        String vnpResponseCode = params.getOrDefault("vnp_ResponseCode", "");
        String vnpTransactionNo = params.getOrDefault("vnp_TransactionNo", "");
        String vnpAmount = params.getOrDefault("vnp_Amount", "");

        System.out.println("[VNPay IPN] TxnRef= " + vnpTxnRef + " ResponseCode=" + vnpResponseCode + " TransactionNo=" + vnpTransactionNo + " Amount=" + vnpAmount);

        boolean signatureValid = VNPayUtil.verifySignature(params);
        if (!signatureValid) {
            System.err.println("[VNPay IPN] Chữ ký không hợp lệ! TxnRef=" + vnpTxnRef);
            response.setStatus(200);
            response.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Signature.\"}");
            return;
        }
        if (!"00".equals(vnpResponseCode)) {
            System.out.println("[VNPay IPN] Thanh toán thất bại! TxnRef=" + vnpTxnRef + " ResponseCode=" + vnpResponseCode);
            vnPayPendingOrderDao.delete(vnpTxnRef);
            response.setStatus(200);
            response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            return;
        }
        VNPayPendingOrder pending = vnPayPendingOrderDao.findByOrderCode(vnpTxnRef);
        if (pending == null) {
            System.out.println("[VNPay INP ] Pending order không còn (Đã xử lý bởi Return). TxnRef=" + vnpTxnRef);
            response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            return;
        }
        User user = null;
        if (pending.userId != null) {
            try {
                user = userService.findById(pending.userId);
            }catch (Exception e){
                System.err.println("[VNPay INP ] Không load được user:" + e.getMessage());
            }
        }
        pending.user = user;

        Order order = PlaceOrderController.buildOrder(
                pending.orderCode,pending.user,pending.fullName,pending.phone,pending.fullAddr,
                pending.discountId,pending.subTotal,pending.discountAmount,pending.shippingFee,pending.totalAmount,pending.note,3);
        int orderId ;
        try {
            orderId = orderService.createOrder(order,pending.checkoutItems);
        }catch (Exception e){
            System.err.println("[VNPay INP] Lỗi lưu đơn hàng:" + e.getMessage());
            response.setStatus(200);
            response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            return;
        }
        if (orderId > 0) {
            System.out.println("[VNPay INP] Đã lưu đơn hàng #" + orderId + "từ INP. TxnRef=" + vnpTxnRef + " TransactionNo=" + vnpTransactionNo);
            vnPayPendingOrderDao.delete(vnpTxnRef);
        }else {
            System.err.println("[VNPay INP] Lưu đơn hàng thất bại. TxnRef=" + vnpTxnRef);
        }
        response.setStatus(200);
        response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleIpn(request, response);
    }
}
