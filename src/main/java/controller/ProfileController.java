package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import model.UserAddress;
import service.OrderService;
import service.UserAddressService;
import service.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    UserService userService = new UserService();
    OrderService orderService = new OrderService();
    UserAddressService userAddressService = new UserAddressService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User loginUser = (User) request.getSession().getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User user = userService.findById(loginUser.getId());
        List<Order> orders = orderService.getOrdersByUserId(loginUser.getId());
        List<UserAddress> addresses = userAddressService.getUserAddressByUserId(user.getId());

        request.setAttribute("user", user);
        request.setAttribute("orders", orders);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/WEB-INF/user.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loginUser = (User) request.getSession().getAttribute("user");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String genderStr = request.getParameter("gender");

        loginUser.setFullName(fullName);
        loginUser.setEmail(email);
        loginUser.setPhoneNumber(phone);
        try {
            if (genderStr != null && !genderStr.isBlank()) {
                loginUser.setGender(Integer.parseInt(genderStr));
            }
        } catch (NumberFormatException e) {
          loginUser.setGender(-1);
        }

        boolean result = userService.updateProfile(loginUser);

        if (result) {
            User freshUser = userService.findById(loginUser.getId());
            session.setAttribute("user", freshUser);

            session.setAttribute("successMsg", "Cập nhật thành công!");
        } else {
            session.setAttribute("errorMsg", "Cập nhật thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
