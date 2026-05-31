package controller;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.UserAddress;
import service.UserAddressService;
import utils.NominatimUtil;
import utils.ORSUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/shipping-info")
public class ShippingInfoController extends HttpServlet {
    private static final double SHOP_LAT = 10.8706;
    private static final double SHOP_LNG = 106.8031;

    private static final long FEE_TIER1 = 15_000;
    private static final long FEE_TIER2 = 25_000;
    private static final long FEE_TIER3 = 35_000;
    private static final long FEE_TIER4 = 50_000;

    private static final UserAddressService userAddressService = new UserAddressService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject json = new JsonObject();

        try {
            String addrIdStr = request.getParameter("addressId");
            String addressDetail = request.getParameter("addressDetail");
            String ward = request.getParameter("ward");
            String district = request.getParameter("district");
            String province = request.getParameter("province");


            if (addrIdStr != null && !addrIdStr.isEmpty()) {
                HttpSession session = request.getSession(false);
                User user = (session != null) ? (User) session.getAttribute("user") : null;
                if (user == null) {
                    json.addProperty("error", "Chưa đăng nhập!");
                    response.getWriter().write(json.toString());
                    return;
                }
                int addrId = Integer.parseInt(addrIdStr);
                List<UserAddress> list = userAddressService.getUserAddressByUserId(user.getId());
                UserAddress addr = list.stream().filter(a -> a.getId() == addrId).findFirst().orElse(null);
                if (addr == null) {
                    json.addProperty("error", "Không tìm thấy địa chỉ!");
                    response.getWriter().write(json.toString());
                    return;
                }
                double[] cached = ORSUtil.getCached(addrId);
                if (cached != null) {
                    json.addProperty("shippingFee", calcFee(cached[0]));
                    json.addProperty("distanceKm", Math.round(cached[0] * 10.0) / 10.0);
                    json.addProperty("durationMin", Math.round(cached[1]));
                    response.getWriter().write(json.toString());
                    return;
                }
                Double lat = addr.getLat();
                Double lng = addr.getLng();

                if (lat == null || lng == null) {
                    json.addProperty("shippingFee", FEE_TIER2);
                    json.addProperty("durationMin", -1);
                    json.addProperty("distanceKm", -1);
                    json.addProperty("note", "Chưa có tọa độ, dùng phí mặc định!");
                    response.getWriter().write(json.toString());
                    return;
                }
                double[] route = ORSUtil.getRoute(addrId, SHOP_LAT, SHOP_LNG, lat, lng);
                if (route == null) {
                    json.addProperty("error", "Không thể tính tuyến đường!");
                    response.getWriter().write(json.toString());
                    return;
                }
                json.addProperty("shippingFee", calcFee(route[0]));
                json.addProperty("distanceKm",Math.round(route[0] * 10.0) / 10.0);
                json.addProperty("durationMin",Math.round(route[1]) );
            } else if (province != null && !province.isEmpty()) {
                double[] coords = NominatimUtil.geocode(addressDetail != null ? addressDetail : "",
                        ward != null ? ward : "",
                        district != null ? district : "",
                        province);
                if (coords == null) {
                    json.addProperty("error", "Không tìm thấy tọa độ địa chỉ!");
                    response.getWriter().write(json.toString());
                    return;
                }
                double[] route = ORSUtil.getRoute(-1, SHOP_LAT, SHOP_LNG, coords[0], coords[1]);
                if (route == null) {
                    json.addProperty("error", "Không thể tính tuyến đường!");
                    response.getWriter().write(json.toString());
                    return;
                }
                json.addProperty("shippingFee", calcFee(route[0]));
                json.addProperty("distanceKm", Math.round(route[0] * 10.0) / 10.0);
                json.addProperty("durationMin", Math.round(route[1]));
            } else {
                json.addProperty("error", "Thiếu thông tin địa chỉ!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("error", "Lỗi server: " + e.getMessage());
        }
        response.getWriter().write(json.toString());
    }

    private long calcFee(double km) {
        if (km < 3) return FEE_TIER1;
        else if (km < 7) return FEE_TIER2;
        else if (km < 15) return FEE_TIER3;
        return FEE_TIER4;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

}
