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

import java.io.IOException;
import java.util.List;

@WebServlet("/address")
public class UserAddressController extends HttpServlet {
    UserAddressService userAddressService = new UserAddressService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        JsonObject json = new JsonObject();

        if (user == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Vui lòng đăng nhập!");
            response.getWriter().write(json.toString());
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "add";
        try {
            switch (action) {
                case "add": {
                    String addresssDetail = request.getParameter("addressDetail");
                    String province = request.getParameter("province");
                    String district = request.getParameter("district");
                    String ward = request.getParameter("ward");

                    UserAddress userAddress = new UserAddress();
                    userAddress.setUserId(user.getId());
                    userAddress.setAddressDetail(addresssDetail);
                    userAddress.setProvince(province);
                    userAddress.setDistrict(district);
                    userAddress.setWard(ward);
                    userAddress.setIsDefault(true);

                    userAddressService.clearDefaultUserAddress(user.getId());
                    boolean added = userAddressService.addUserAddress(userAddress);

                    if (added) {
                        List<UserAddress> list = userAddressService.getUserAddressByUserId(user.getId());
                        if (list != null && !list.isEmpty()) {
                            int newId = list.get(0).getId();
                            try {
                                double[] coords = NominatimUtil.geocode(addresssDetail, ward, district, province);
                                if (coords != null) {
                                    userAddressService.saveCoords(newId, coords[0], coords[1]);
                                }
                            }catch (Exception e){
                                e.printStackTrace();
                            }
                        }
                        json.addProperty("success", true);
                        json.addProperty("message", "Đã thêm địa chỉ thành công!");
                    } else {
                        json.addProperty("success", false);
                        json.addProperty("message", "Thêm địa chỉ thất bại, vui lòng thử lại!");
                    }
                    break;
                }
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String addressDetail = request.getParameter("addressDetail");
                    String province = request.getParameter("province");
                    String district = request.getParameter("district");
                    String ward = request.getParameter("ward");

                    UserAddress userAddress = new UserAddress();
                    userAddress.setId(id);
                    userAddress.setUserId(user.getId());
                    userAddress.setAddressDetail(addressDetail);
                    userAddress.setProvince(province);
                    userAddress.setDistrict(district);
                    userAddress.setWard(ward);

                    boolean updated = userAddressService.updateUserAddress(userAddress);

                    if (updated) {

                        try{
                            double[] coords = NominatimUtil.geocode(addressDetail, ward, district, province);
                            if (coords != null) userAddressService.saveCoords(id, coords[0], coords[1]);
                        }catch (Exception e){
                            e.printStackTrace();
                        }
                        json.addProperty("success", true);
                        json.addProperty("message", "Đã cập nhật địa chỉ thành công!");
                    } else {
                        json.addProperty("success", false);
                        json.addProperty("message", "Cập nhật địa chỉ thất bại, vui lòng thử lại!");
                    }
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    List<UserAddress> existing = userAddressService.getUserAddressByUserId(user.getId());
                    UserAddress toDelete = existing.stream().filter(a -> a.getId() == id).findFirst().orElse(null);
                    boolean deleted = userAddressService.deleteUserAddress(id, user.getId());
                    if (deleted) {
                        if (toDelete != null && toDelete.getIsDefault()) {
                            List<UserAddress> remaining = userAddressService.getUserAddressByUserId(user.getId());
                            if (remaining != null && !remaining.isEmpty()) {
                                userAddressService.setDefaultUserAddress(remaining.get(0).getId(), user.getId());
                            }
                        }
                        json.addProperty("success", true);
                        json.addProperty("message", "Đã xóa địa chỉ!");
                    } else {
                        json.addProperty("success", false);
                        json.addProperty("message", "Xóa địa chỉ thất bại!");
                    }
                    break;
                }
                case "setDefault": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    boolean ok = userAddressService.setDefaultUserAddress(id, user.getId());
                    json.addProperty("success", ok);
                    json.addProperty("message", ok ? "Đã đặt địa chỉ mặc định!" : "Thất bại!");
                    break;
                }
                default:
                    json.addProperty("success", false);
                    json.addProperty("message", "Action không hợp lệ!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi server: " + e.getMessage());
        }
        response.getWriter().write(json.toString());
    }
}
