package controller.order;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


@WebServlet("/ghn-location")
public class GHNLocationController extends HttpServlet {
    private static final String GHN_TOKEN = "d50bc758-57e5-11f1-aed0-b6d7ef90fad3";
    private static final int SHOP_ID = 6470857;
    private static final String BASE_URL = "https://online-gateway.ghn.vn/shiip/public-api";
    private static final HttpClient HTTP = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10)).build();
    private static final Map<String, String> CACHE = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "public, max-age=3600");

        String type = nvl(request.getParameter("type"));
        String provinceId = nvl(request.getParameter("province_id"));
        String districtId = nvl(request.getParameter("district_id"));

        String cacheKey = type + "_" + provinceId + "_" + districtId;
        if (CACHE.containsKey(cacheKey)) {
            response.getWriter().write(CACHE.get(cacheKey));
            return;
        }
        try {
            String ghnUrl;
            String dataField;

            switch (type) {
                case "province":
                    ghnUrl = BASE_URL + "/master-data/province";
                    dataField = "data";
                    break;
                case "district":
                    if (provinceId.isEmpty()) {
                        error(response, "Thiếu province_id");
                        return;
                    }
                    ghnUrl = BASE_URL + "/master-data/district?province_id=" + provinceId;
                    dataField = "data";
                    break;
                case "ward":
                    if (districtId.isEmpty()) { error(response,"Thiếu district_id=" + districtId); return;}
                    ghnUrl = BASE_URL + "/master-data/ward?district_id=" + districtId;
                    dataField = "data";
                    break;
                default:
                    error(response,"type không hợp hệ (province/district/ward)");
                    return;
            }
            HttpRequest ghnResq = HttpRequest.newBuilder().uri(URI.create(ghnUrl)).timeout(Duration.ofSeconds(10))
                    .header("Token",GHN_TOKEN).header("ShopId",String.valueOf(SHOP_ID)).GET().build();
            HttpResponse<String> ghnResp = HTTP.send(ghnResq,HttpResponse.BodyHandlers.ofString());
            String body = ghnResp.body();
            JsonObject root = JsonParser.parseString(body).getAsJsonObject();
            if(root.get("code").getAsInt() != 200){
                error(response,"[GHN] trả lỗi: " + root.get("message").getAsString());
                return;
            }
            JsonArray arr = root.getAsJsonArray(dataField);
            String result = arr.toString();
            CACHE.put(cacheKey, result);
            response.getWriter().write(result);
        } catch (Exception e) {
           e.printStackTrace();
           error(response,"Lỗi server: "+e.getMessage());
        }
    }

    private String nvl(String s) {
        return s == null ? "" : s.trim();
    }

    private void error(HttpServletResponse response, String message) throws IOException {
        JsonObject err = new JsonObject();
        err.addProperty("error", message);
        response.setStatus(400);
        response.getWriter().write(err.toString());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
