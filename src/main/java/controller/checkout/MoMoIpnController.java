package controller.checkout;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.MomoUtil;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/momo-ipn")
public class MoMoIpnController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        System.out.println("[MoMo IPN] Body: " + sb);
        JsonObject json;
        try {
            json = JsonParser.parseString(sb.toString()).getAsJsonObject();
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().println("{\"message\":\"Invalid JSON\"}");
            return;
        }
        String partnerCode = getStr(json, "partnerCode");
        String orderCode = getStr(json, "orderId");
        String requestId = getStr(json, "requestId");
        String amount = getStr(json, "amount");
        String orderInfo = getStr(json, "orderInfo");
        String orderType = getStr(json, "orderType");
        String transId = getStr(json, "transId");
        String resultCode = getStr(json, "resultCode");
        String message = getStr(json, "message");
        String payType = getStr(json, "payType");
        String responseTime = getStr(json, "responseTime");
        String extraData = getStr(json, "extraData");
        String signature = getStr(json, "signature");

        String rawSignature = "accessKey=" + "F8BBA842ECF85" + "&amount=" + amount + "&extraData=" + extraData
                + "&message=" + message + "&orderId=" + orderCode + "&orderInfo=" + orderInfo + "&orderType=" + orderType
                + "&partnerCode=" + partnerCode + "&payType=" + payType + "&requestId=" + requestId + "&responseTime=" + responseTime
                + "&resultCode=" + resultCode + "&transId=" + transId;
        boolean signaturevaild = MomoUtil.verifySignature(rawSignature, signature);
        if (!signaturevaild) {
            System.err.println("[MoMo IPN] Chữ ký không hợp lệ! orderCode=" + orderCode);
            response.setStatus(400);
            response.getWriter().write("{\"message\":\"Invalid signature\"}");
            return;
        }
        if ("0".equals(resultCode)) {
            System.out.println("[MoMo IPN] Thanh toán thành công! orderCode=" + orderCode+ "transId=" + transId);
        } else {
            System.out.println("[MoMo IPN] Thanh toán thất bại! orderCode=" + orderCode + "message=" + message);
        }
        response.setStatus(200);
        response.getWriter().write("{\"message\":\"OK\"}");
    }

    private String getStr(JsonObject obj, String key) {
        try {
            return obj.has(key) && !obj.get(key).isJsonNull() ? obj.get(key).getAsString() : "";
        } catch (Exception e) {
            return "";
        }
    }
}
