package utils;


import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.Normalizer;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;


public class GHNUtil {
    private static final String GNH_TOKEN = "d50bc758-57e5-11f1-aed0-b6d7ef90fad3";
    private static final int SHOP_ID = 6470857;
    private static final int FROM_DISTRICT_ID = 1452;
    private static final int FIXED_WEIGHT_GRAM = 1000;
    private static final int SERVICE_TYPE_ID = 2;
    private static final String BASE_URL = "https://online-gateway.ghn.vn/shiip/public-api";

    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();

    public static final Map<String, Long> feeCache = new ConcurrentHashMap<>();

    public static int getDistrictId(String provinceName, String districtName) {
        try {
            int provinceId = getProvinceId(provinceName);
            if (provinceId == -1) {
                System.err.println("[GHN] không tìm thấy province: " + provinceName);
                return -1;
            }
            String url = BASE_URL + "/master-data/district?province_id=" + provinceId;
            String body = callGet(url);
            if (body == null) return -1;

            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) return -1;

            JsonArray data = root.getAsJsonArray("data");
            for (int i = 0; i < data.size(); i++) {
                JsonObject item = data.get(i).getAsJsonObject();
                String ghnDistrictName = item.get("DistrictName").getAsString();
                if (fuzzyMatch(ghnDistrictName, districtName)) {
                    return item.get("DistrictID").getAsInt();
                }
            }
            System.err.println("[GHN] Không match district: '" + districtName + "' trong province id: " + provinceId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    private static boolean fuzzyMatch(String ghnName, String inputName) {
        String ghn = normalize(ghnName);
        String input = normalize(inputName);
        if (ghn.equals(input)) return true;

        String ghnCore = stripAdminPrefix(ghn);
        String inputCore = stripAdminPrefix(input);
        if (!ghnCore.isEmpty() && !inputCore.isEmpty()) {
            if (ghnCore.equals(inputCore)) return true;
            if (ghnCore.contains(inputCore) || inputCore.contains(ghnCore)) return true;
        }
        return ghnCore.contains(input) || input.contains(ghn);
    }

    private static String normalize(String s) {
        if (s == null) return "";
        String lower = s.toLowerCase().trim().replaceAll("\\s+", " ");
        String noDiacritics = Normalizer.normalize(lower, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "").replace("đ", "d");

        return noDiacritics.replaceAll("^tp\\.?\\s*", "thanh pho ")
                .replaceAll("^q\\.?\\s*(\\d)", "quan $1");
    }

    private static String stripAdminPrefix(String s) {
        return s.replaceAll("^(thanh pho|tinh|quan|huyen|phuong|xa|thi tran|thi xa)\\s*", "").trim();
    }


    private static String callGet(String url) throws Exception {
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url))
                .timeout(Duration.ofSeconds(10)).header("Token", GNH_TOKEN)
                .header("ShopId", String.valueOf(SHOP_ID)).GET().build();
        HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    private static int getProvinceId(String provinceName) {
        try {
            String body = callGet(BASE_URL + "/master-data/province");
            if (body == null) return -1;
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) return -1;
            JsonArray data = root.getAsJsonArray("data");
            for (int i = 0; i < data.size(); i++) {
                JsonObject item = data.get(i).getAsJsonObject();
                String ghnProvinceName = item.get("ProvinceName").getAsString();
                if (fuzzyMatch(ghnProvinceName, provinceName)) {
                    return item.get("ProvinceID").getAsInt();
                }
            }
            System.err.println("[GHN] Không match province: '" + provinceName + "'");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static String getWardCode(int districtId, String wardName) {
        try {
            String body = callGet(BASE_URL + "/master-data/ward?district_id=" + districtId);
            if (body == null) return null;
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) return null;
            JsonArray data = root.getAsJsonArray("data");
            for (int i = 0; i < data.size(); i++) {
                JsonObject item = data.get(i).getAsJsonObject();
                String ghnWardName = item.get("WardName").getAsString();
                if (fuzzyMatch(ghnWardName, wardName)) {
                    return item.get("WardCode").getAsString();
                }
            }
            System.err.println("[GHN] Không match ward: '" + wardName + "' trong district id: " + districtId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static long calculateFee(int toDistrictId, String toWardCode) {
        String cacheKey = toDistrictId + "_" + (toWardCode != null ? toWardCode : "");
        if (feeCache.containsKey(cacheKey)) {
            return feeCache.get(cacheKey);
        }
        try {
            JsonObject payload = new JsonObject();
            payload.addProperty("service_type_id", SERVICE_TYPE_ID);
            payload.addProperty("from_district_id", FROM_DISTRICT_ID);
            payload.addProperty("to_district_id", toDistrictId);
            if (toWardCode != null && !toWardCode.isEmpty()) {
                payload.addProperty("to_ward_code", toWardCode);
            }
            payload.addProperty("weight", FIXED_WEIGHT_GRAM);
            payload.addProperty("length", 20);
            payload.addProperty("width", 15);
            payload.addProperty("height", 10);

            String body = callPost(BASE_URL + "/v2/shipping-order/fee", payload.toString());
            if (body == null) return -1;

            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) {
                System.err.println("[GHN] fee error: " + body);
                return -1;
            }
            long fee = root.getAsJsonObject("data").get("total").getAsLong();
            feeCache.put(cacheKey, fee);
            return fee;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;

    }

    private static String callPost(String url, String jsonBody) throws Exception {
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).timeout(Duration.ofSeconds(10))
                .header("Token", GNH_TOKEN).header("ShopId", String.valueOf(SHOP_ID))
                .header("content-type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody)).build();
        HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    public static long calculateFeeByAddress(String provinceName, String districtName, String wardName) {
        try {
            int districtId = getDistrictId(provinceName, districtName);
            if (districtId == -1) {
                System.err.println("[GHN] Không tìm thấy district: " + districtName + ",  " + provinceName);
                return 30_000L;
            }
            String wardCode = null;
            if (wardName != null && !wardName.trim().isEmpty()) {
                wardCode = getWardCode(districtId, wardName);
            }
            long fee = calculateFee(districtId, wardCode);
            return fee > 0 ? fee : 30_000L;
        } catch (Exception e) {
            e.printStackTrace();
            return 30_000L;
        }
    }

    public static String createOrder(String toName, String toPhone, String toAddress, int toDistrictId, String towardCode, long codAmount, String note) {
        try {
            JsonObject payload = new JsonObject();
            payload.addProperty("payment_type_id", codAmount > 0 ? 2 : 1);
            payload.addProperty("note", note != null ? note : "");
            payload.addProperty("required_note", "CHOXEMHANGKHONGTHU");
            payload.addProperty("to_name", toName);
            payload.addProperty("to_phone", toPhone);
            payload.addProperty("to_address", toAddress);
            payload.addProperty("to_ward_code", towardCode != null ? towardCode : "");
            payload.addProperty("to_district_id", toDistrictId);
            payload.addProperty("cod_amount", codAmount);
            payload.addProperty("weight", FIXED_WEIGHT_GRAM);
            payload.addProperty("length", 20);
            payload.addProperty("width", 15);
            payload.addProperty("height", 10);
            payload.addProperty("service_type_id", SERVICE_TYPE_ID);

            JsonArray items = new JsonArray();
            JsonObject item = new JsonObject();
            item.addProperty("name", "Hàng hóa");
            item.addProperty("quantity", 1);
            items.add(item);
            payload.add("items", items);

            String body = callPost(BASE_URL + "/v2/shipping-order/create", payload.toString());
            if (body == null) return null;
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) {
                System.err.println("[GHN] create order error: " + body);
                return null;
            }
            return root.getAsJsonObject("data").get("order_code").getAsString();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String trackOrder(String ghnOrderCode) {
        try {
            JsonObject payload = new JsonObject();
            payload.addProperty("order_code", ghnOrderCode);
            String body = callPost(BASE_URL + "/v2/shipping-order/detail", payload.toString());
            if (body == null) return null;
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) return null;
            return root.getAsJsonObject("data").get("status").getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getExpectedDeliveryTime(int toDistrictId, String toWardCode) {
        try {
            int serviceId = getServiceId(toDistrictId);
            if (serviceId == -1) {
                System.err.println("[GHN] Không lấy được service_id cho district: " + toDistrictId);
                return null;
            }
            JsonObject payload = new JsonObject();
            payload.addProperty("from_district_id", FROM_DISTRICT_ID);
            payload.addProperty("from_ward_code", "");
            payload.addProperty("to_district_id", toDistrictId);
            if (toWardCode != null && !toWardCode.isEmpty()) {
                payload.addProperty("to_ward_code", toWardCode);
            }
            payload.addProperty("service_id", serviceId);

            String body = callPost(BASE_URL + "/v2/shipping-order/leadtime", payload.toString());
            if (body == null) return null;
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) {
                System.err.println("[GHN] leadtime error: " + body);
                return null;
            }
            System.out.println("[GHN] leadtime raw response: " + body);
            JsonObject data = root.getAsJsonObject("data");
            long epochSec = 0;
            if (data.has("leadtime") && !data.get("leadtime").isJsonNull()) {
                epochSec = data.get("leadtime").getAsLong();
            }
            if (epochSec <= 0 && data.has("expected_delivery_time") && !data.get("expected_delivery_time").isJsonNull()) {
                epochSec = data.get("expected_delivery_time").getAsLong();
            }
            if (epochSec <= 0) {
                System.err.println("[GHN] leadtime =0, Không tính được thời gian dự kiến ");
                return null;
            }
            if (epochSec > 9_999_999_999L) epochSec = epochSec / 1000;
            java.time.LocalDateTime date = java.time.Instant.ofEpochSecond(epochSec).atZone(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime();
            return date.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static int getServiceId(int toDistrictId) {
        try {
            String url =BASE_URL + "/v2/shipping-order/available-services" + "?shop_id=" + SHOP_ID + "&from_district=" + FROM_DISTRICT_ID + "&to_district=" + toDistrictId;
            String body = callGet(url);
            if (body == null) return -1;
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if (root.get("code").getAsInt() != 200) {
                System.err.println("[GHN] available-services error: " + body);
                return -1;
            }
            JsonArray data = root.getAsJsonArray("data");
            if (data == null || data.size() == 0) return -1;
            for(int i = 0; i < data.size(); i++){
                JsonObject svc = data.get(i).getAsJsonObject();
                if (svc.get("service_type_id").getAsInt() == SERVICE_TYPE_ID) {
                    int sid = svc.get("service_id").getAsInt();
                    System.out.println("[GHN] getServiceId -> " + sid);
                    return sid;
                }
            }
            int sid = data.get(0).getAsJsonObject().get("service_id").getAsInt();
            System.out.println("[GHN] getServiceId (fallback) -> " + sid);
            return sid;
        }catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
}
