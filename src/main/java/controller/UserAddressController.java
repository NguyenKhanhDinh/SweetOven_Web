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
        String addressDetail = request.getParameter("addressDetail");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");

        UserAddress address = new UserAddress();
        address.setUserId(user.getId());
        address.setAddressDetail(addressDetail);
        address.setProvince(province);
        address.setDistrict(district);
        address.setWard(ward);
        List<UserAddress> existingAddresses = userAddressService.getUserAddressByUserId(user.getId());
        if (existingAddresses == null || existingAddresses.isEmpty()) {
            address.setDefault(true);
        } else {
            address.setDefault(false);
        }
        userAddressService.addUserAddress(address);

        response.sendRedirect("profile");
    }
}
