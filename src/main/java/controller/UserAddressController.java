package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.UserAddress;
import service.UserAddressService;

import java.io.IOException;
import java.util.List;

@WebServlet("/address")
public class UserAddressController extends HttpServlet {
    UserAddressService userAddressService = new UserAddressService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "add"; {
            switch (action) {
                case "add": {
                   String addresssDetail = request.getParameter("addressDetail");
                   String province = request.getParameter("province");
                   String district = request.getParameter("district");
                   String ward = request.getParameter("ward");

                   UserAddress userAddress = new UserAddress();
                   userAddress.setId(user.getId());
                   userAddress.setAddressDetail(addresssDetail);
                   userAddress.setProvince(province);
                   userAddress.setDistrict(district);
                   userAddress.setWard(ward);

                   List<UserAddress> existing = userAddressService.getUserAddressByUserId(user.getId());
                   userAddress.setIsDefault(existing== null||existing.isEmpty());
                   userAddressService.addUserAddress(userAddress);
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

                    userAddressService.updateUserAddress(userAddress);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    userAddressService.deleteUserAddress(id,user.getId());
                    break;
                }
                case "setDefault": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    userAddressService.setDefaultUserAddress(id,user.getId());
                    break;
                }
            }
        }


        response.sendRedirect("profile");
    }
}
