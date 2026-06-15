package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.VNPayUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/vnpay-ipn")
public class VNPayIpnController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleIpn(request,response);
    }

    private void handleIpn(HttpServletRequest request, HttpServletResponse response) throws IOException{
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        Map<String,String> params = new HashMap<>();
        request.getParameterMap().forEach((key,values)->{
            if(values != null && values.length>0){
                params.put(key,values[0]);
            }
        });
        String vnpTxnRef = params.getOrDefault("vnp_TxnRef","");
        String vnpResponseCode = params.getOrDefault("vnp_ResponseCode","");
        String vnpTransactionNo = params.getOrDefault("vnp_TransactionNo","");
        String vnpAmount = params.getOrDefault("vnp_Amount","");

        System.out.println("[VNPay IPN] TxnRef= " + vnpTxnRef + " ResponseCode=" +vnpResponseCode + " TransactionNo=" +vnpTransactionNo + " Amount=" + vnpAmount);

        boolean signatureValid = VNPayUtil.verifySignature(params);
        if(!signatureValid){
            System.err.println("[VNPay IPN] Chữ ký không hợp lệ! TxnRef=" + vnpTxnRef);
            response.setStatus(200);
            response.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Signature.\"}");
            return;
        }
        if ("00".equals(vnpResponseCode)) {
            System.out.println("[VNPay IPN] Thanh toán thành công! TxnRef=" + vnpTxnRef + " TransactionNo=" + vnpTransactionNo);
        }else{
            System.out.println("[VNPay IPN] Thanh toán thất bại! TxnRef=" + vnpTxnRef + " ResponseCode=" + vnpResponseCode);
        }
        response.setStatus(200);
        response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleIpn(request,response);
    }
}
