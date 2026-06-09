package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.UserAddressService;
import service.UserDiscountService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/checkout")
public class CheckOutController extends HttpServlet {
    private final UserAddressService userAddressService = new UserAddressService();
    private final UserDiscountService userDiscountService = new UserDiscountService();
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("30000");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-cart");
            return;
        }
        String raw = request.getParameter("selectedProductIds");
        if (raw == null || raw.trim().isEmpty()) {
            request.setAttribute("cart", cart);
            request.setAttribute("errorMsg", "Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
            request.getRequestDispatcher("/my-cart").forward(request, response);
            return;
        }
        Set<Integer> selectedIds = parseIds(raw);
        if (selectedIds.isEmpty()) {
            request.setAttribute("cart", cart);
            request.setAttribute("errorMsg", "Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
            request.getRequestDispatcher("/my-cart").forward(request, response);
            return;
        }
        List<CartItem> checkoutItems = new ArrayList<>();
        BigDecimal subtotal = BigDecimal.ZERO;

        for (CartItem item : cart.getItems()) {
            if (selectedIds.contains(item.getProduct().getId())) {
                checkoutItems.add(item);
                subtotal = subtotal.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            }
        }


        if (checkoutItems.isEmpty()) {
            request.setAttribute("cart", cart);
            request.setAttribute("errorMsg", "Không thấy sản phẩm nào đã được chọn trong giỏ hàng!");
            request.getRequestDispatcher("/my-cart").forward(request, response);
            return;
        }
        session.setAttribute("checkoutItems", checkoutItems);
        session.setAttribute("checkoutTotal", subtotal);
        session.setAttribute("checkoutSelectedIds", raw);

        User user = (User) session.getAttribute("user");
        if (user != null) {
            try {
                List<UserAddress> addresses = userAddressService.getUserAddressByUserId(user.getId());
                request.setAttribute("userAddresses", addresses);
            } catch (Exception e) {
                System.err.println("[CheckOutController] Lỗi tải địa chỉ: " + e.getMessage());
            }
            try {
                List<UserDiscount> savedVouchers = userDiscountService.getSavedActiveDiscounts(user.getId());
                request.setAttribute("savedVouchers", savedVouchers);
            } catch (Exception e) {
                System.err.println("[CheckOutController] Lỗi tải voucher: " + e.getMessage());
            }
        }
        BigDecimal finalTotal = subtotal.add(SHIPPING_FEE);
        request.setAttribute("checkoutItems", checkoutItems);
        request.setAttribute("checkoutTotal", subtotal);
        request.setAttribute("shippingFee", SHIPPING_FEE);
        request.setAttribute("finalTotal", finalTotal);
        request.setAttribute("selectedProductIds", raw);

        request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
    }

    private Set<Integer> parseIds(String raw) {
        Set<Integer> ids = new HashSet<>();
        for (String part : raw.split(",")) {
            try {
                ids.add(Integer.parseInt(part.trim()));
            } catch (NumberFormatException ignored) {
            }
        }
        return ids;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("checkoutItems") != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                try {
                    List<UserAddress> addresses = userAddressService.getUserAddressByUserId(user.getId());
                    request.setAttribute("userAddresses", addresses);
                } catch (Exception e) {
                    System.err.println("[CheckOutController] GET - Lỗi tải địa chỉ: " + e.getMessage());
                }
                try {
                    List<UserDiscount> savedVouchers = userDiscountService.getSavedActiveDiscounts(user.getId());
                    request.setAttribute("savedVouchers", savedVouchers);
                } catch (Exception e) {
                    System.err.println("[CheckOutController] GET-Lỗi tải voucher: " + e.getMessage());
                }
            }
            BigDecimal subtotal = (BigDecimal) session.getAttribute("checkoutTotal");
            if (subtotal == null) {
                subtotal = BigDecimal.ZERO;
            }
            BigDecimal finalTotal = subtotal.add(SHIPPING_FEE);

            request.setAttribute("checkoutItems", session.getAttribute("checkoutItems"));
            request.setAttribute("checkoutTotal", subtotal);
            request.setAttribute("shippingFee", SHIPPING_FEE);
            request.setAttribute("finalTotal", finalTotal);
            request.setAttribute("selectedProductIds", session.getAttribute("checkoutSelectedIds"));

            request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/my-cart");
    }
}
