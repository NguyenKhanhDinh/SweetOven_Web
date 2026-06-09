package controller;

import dao.UserFavoritesDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    UserService userService = new UserService();
    OrderService orderService = new OrderService();
    UserAddressService userAddressService = new UserAddressService();
    UserFavoritesDao  userFavoritesDao = new UserFavoritesDao();
    ProductService  productService = new ProductService();
    UserDiscountService userDiscountService = new UserDiscountService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User loginUser = (User) request.getSession().getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User user = userService.findById(loginUser.getId());
        List<Order> orders = orderService.getOrdersByUserId(loginUser.getId());
        List<UserAddress> addresses = userAddressService.getUserAddressByUserId(user.getId());
        List<Product> favoritesProducts = new java.util.ArrayList<>();
        try{
            List<UserFavorites> favorites = userFavoritesDao.getUserFavoritesByUserId(user.getId());
            List<Integer> favoriteProductIds = favorites.stream().map(UserFavorites::getProductId).collect(Collectors.toList());
            if(!favoriteProductIds.isEmpty()){
                favoritesProducts = productService.getFavoriteProducts(favoriteProductIds);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        List<model.UserDiscount> vouchers = new ArrayList<>();
        try {
            vouchers = userDiscountService.getSavedActiveDiscounts(user.getId());
        }catch(Exception e){
            e.printStackTrace();
        }

        request.setAttribute("user", user);
        request.setAttribute("orders", orders);
        request.setAttribute("addresses", addresses);
        request.setAttribute("favoriteProducts", favoritesProducts);
        request.setAttribute("vouchers", vouchers );
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
