package utils;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Base64;

public class MomoUtil {
    private static final String PARTNER_CODE = "MOMO";
    private static final String ACCESS_KEY = "F8BBA842ECF85";
    private static final String SECRET_KEY = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    private static final String ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";

    private static final String REDIRECT_URL = "https://gerbil-padded-glazing.ngrok-free.dev/momo-return";
    private static final String IPN_URL = "https://gerbil-padded-glazing.ngrok-free.dev/momo-ipn";

    private static final HttpClient  HTTP_CLIENT = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(30)).build();

    public  static String createPaymentUrl(String sessionKey, BigDecimal amount,String orderCode) throws Exception {
        String requestId = orderCode + "_" + System.currentTimeMillis();
        String orderInfo = "Thanh toan don hang " + orderCode;
        long amountLong = amount.longValue();
        String requestType = "captureWallet";

        String extraData = Base64.getEncoder().encodeToString(sessionKey.getBytes("UTF-8"));

        String rawSignature = "accessKey=" +ACCESS_KEY
                + "&amount=" + amountLong+ "&extraData=" +extraData +"&ipnUrl=" + IPN_URL + "&orderId=" + orderCode
                +"&orderInfo=" + orderInfo+ "&partnerCode=" + PARTNER_CODE + "&redirectUrl="
                + REDIRECT_URL +"&requestId=" + requestId + "&requestType=" + requestType;
        System.out.println("[MoMo] rawSignature: " + rawSignature);

        String signature = hmacSHA256(rawSignature,SECRET_KEY);

        JsonObject body = new JsonObject();
        body.addProperty("partnerCode", PARTNER_CODE);
        body.addProperty("storeId", "TestStore");
        body.addProperty("accessKey", ACCESS_KEY);
        body.addProperty("requestId", requestId);
        body.addProperty("amount", amountLong);
        body.addProperty("orderId", orderCode);
        body.addProperty("orderInfo", orderInfo);
        body.addProperty("redirectUrl", REDIRECT_URL);
        body.addProperty("ipnUrl", IPN_URL);
        body.addProperty("extraData", extraData);
        body.addProperty("requestType", requestType);
        body.addProperty("signature", signature);
        body.addProperty("lang", "vi");

        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(ENDPOINT))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(body.toString())).build();
        HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("[MoMo] Response: "+response.body());

        JsonObject json = JsonParser.parseString(response.body()).getAsJsonObject();
        int resultCode = json.get("resultCode").getAsInt();
        if(resultCode != 0){
            String message = json.has("message") ? json.get("message").getAsString() : "Unknown Error";
            throw new Exception("[MoMo] Tạo thanh toán thất bại: " + message + "(code: " + resultCode + ")");
        }
        return json.get("payUrl").getAsString();

    }

    private static String hmacSHA256(String data, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes("UTF-8"), "HmacSHA256"));
        byte[] bytes = mac.doFinal(data.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    public static boolean verifySignature(String rawSignature,String signature){
        try {
            return hmacSHA256(rawSignature,SECRET_KEY).equals(signature);
        }catch (Exception e){
            return false;
        }
    }
}
