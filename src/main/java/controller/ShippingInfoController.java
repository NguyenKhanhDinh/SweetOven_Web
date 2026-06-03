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
import utils.GHNUtil;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/shipping-info")
public class ShippingInfoController extends HttpServlet {
    private static final long SHIPPING_FEE_DEFAULT = 30_000L;
    private static final UserAddressService userAddressService = new UserAddressService();
    private static final Map<Integer, Object[]> addressGhnCache = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject json = new JsonObject();

        try {
            String addrIdStr = request.getParameter("addressId");
            String province = request.getParameter("province");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");

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

                int districtId;
                String wardCode;

                if (addr.hasGhnData()) {
                    districtId = addr.getGhnDistrictId();
                    wardCode = addr.getGhnWardCode();
                    System.out.println("[GHN] dùng GHN data từ DB cho address" + addrId + "- districtId = " + districtId + ", ward code " + wardCode);
                } else {
                    Object[] cached = addressGhnCache.get(addrId);
                    if (cached != null) {
                        districtId = (int) cached[0];
                        wardCode = (String) cached[1];
                    } else {
                        districtId = GHNUtil.getDistrictId(addr.getProvince(), addr.getDistrict());
                        wardCode = (districtId != -1) ? GHNUtil.getWardCode(districtId, addr.getWard()) : null;
                        addressGhnCache.put(addrId, new Object[]{districtId, wardCode});

                        if (districtId != -1) {
                            try {
                                userAddressService.saveGhnData(addrId, districtId, wardCode != null ? wardCode : "");
                                System.out.println("[GHN] Đã lưu GHN data vào DB cho address" +addrId);
                            } catch (Exception e) {
                                System.err.println("[GHN] Không thể lưu GHN data: "+e.getMessage());
                            }
                        }
                    }
                }

                long fee = (districtId != -1) ? GHNUtil.calculateFee(districtId, wardCode) : SHIPPING_FEE_DEFAULT;
                if (fee < 0) fee = SHIPPING_FEE_DEFAULT;

                json.addProperty("shippingFee", fee);
                json.addProperty("districtId", districtId);
                json.addProperty("wardCode", wardCode != null ? wardCode : "");
                String eta1 =(districtId !=-1)?GHNUtil.getExpectedDeliveryTime(districtId, wardCode):null;
                if (eta1 != null) json.addProperty("expectedDelivery", eta1);

            } else if (province != null &&!province.isEmpty()) {
                int districtId = GHNUtil.getDistrictId(province, district);
                String wardCode =(districtId !=-1 && ward != null && !ward.isEmpty()) ? GHNUtil.getWardCode(districtId, ward) : null;
                long fee = GHNUtil.calculateFeeByAddress(province, district, ward);
                if (fee < 0) fee = SHIPPING_FEE_DEFAULT;

                json.addProperty("shippingFee", fee);
                json.addProperty("districtId", districtId);
                json.addProperty("wardCode", wardCode != null ? wardCode : "");
                String eta2 =(districtId != -1)?GHNUtil.getExpectedDeliveryTime(districtId, wardCode):null;
                if (eta2 != null) json.addProperty("expectedDelivery", eta2);

            } else {
                json.addProperty("error", "Thiếu thông tin địa chỉ!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("error", "Lỗi server: " + e.getMessage());
        }
        write(response, json);
    }

    private void write(HttpServletResponse response, JsonObject json) throws IOException {
        response.getWriter().write(json.toString());
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

}
