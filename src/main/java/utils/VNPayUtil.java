package utils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayUtil {
    private static final String VNP_TMN_CODE = "TQO4LXFS";
    private static final String VNP_HASH_SECRET = "GQXWLZR6VQCQLYSUSMYUQBNK9CXRQ0AK";
    private static final String VNP_URL = "https://pay.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_RETURN_URL = "https://app.sweetoven.id.vn/vnpay-return";

    private static final String VNP_VERSION = "2.1.0";
    private static final String VNP_COMMAND = "pay";
    private static final String VNP_CURR_CODE = "VND";
    private static final String VNP_LOCALE = "vn";
    private static final String VNP_ORDER_TYPE = "other";
    private static final TimeZone VN_TIMEZONE = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");

    public static String createPaymentUrl( long amount, String orderCode, String ipAddress) throws Exception {
        String vnpTxnRef = orderCode;
        String vnpOrderInfo = "Thanh toan hoa don" + orderCode;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        sdf.setTimeZone(VN_TIMEZONE);
        String vnpCreateDate = sdf.format(new Date());
        String vnpExpireDate = getExpireDate(15);

        long vnpAmount = amount * 100;
        Map<String, String> params = new TreeMap<>();
        params.put("vnp_Version", VNP_VERSION);
        params.put("vnp_Command", VNP_COMMAND);
        params.put("vnp_TmnCode", VNP_TMN_CODE);
        params.put("vnp_Amount", String.valueOf(vnpAmount));
        params.put("vnp_CurrCode", VNP_CURR_CODE);
        params.put("vnp_TxnRef", vnpTxnRef);
        params.put("vnp_OrderInfo", vnpOrderInfo);
        params.put("vnp_OrderType", VNP_ORDER_TYPE);
        params.put("vnp_Locale", VNP_LOCALE);
        params.put("vnp_ReturnUrl", VNP_RETURN_URL);
        params.put("vnp_IpAddr", ipAddress == null ? "127.0.0.1" : ipAddress);
        params.put("vnp_CreateDate", vnpCreateDate);
        params.put("vnp_ExpireDate", vnpExpireDate);

        StringBuilder hashData = new StringBuilder();
        StringBuilder queryData = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            hashData.append(entry.getKey()).append('=').append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII));
            queryData.append(URLEncoder.encode(entry.getKey(), StandardCharsets.US_ASCII)).append('=').append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII));
            hashData.append('&');
            queryData.append('&');
        }
        hashData.deleteCharAt(hashData.length() - 1);
        queryData.deleteCharAt(queryData.length() - 1);

        String secureHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        queryData.append("&vnp_SecureHash=").append(secureHash);

        return VNP_URL + "?" + queryData;
    }

    private static String hmacSHA512(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA512");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
        byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    private static String getExpireDate(int minutesFromNow) {
        Calendar cal = Calendar.getInstance(VN_TIMEZONE);
        cal.add(Calendar.MINUTE, minutesFromNow);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        sdf.setTimeZone(VN_TIMEZONE);
        return sdf.format(cal.getTime());
    }

    public static boolean verifySignature(Map<String, String> params) {
        String receiveHash = params.get("vnp_SecureHash");
        if (receiveHash == null) return false;

        Map<String, String> signParams = new TreeMap<>(params);
        signParams.remove("vnp_SecureHash");
        signParams.remove("vnp_SecureHashType");

        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> entry : signParams.entrySet()) {
            hashData.append(entry.getKey()).append('=').append(URLEncoder.encode(entry.getValue(),StandardCharsets.US_ASCII)).append('&');
        }
        hashData.deleteCharAt(hashData.length() - 1);
        try {
            String computed = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
            return computed.equalsIgnoreCase(receiveHash);
        }catch (Exception e) {
            return false;
        }
    }
}
