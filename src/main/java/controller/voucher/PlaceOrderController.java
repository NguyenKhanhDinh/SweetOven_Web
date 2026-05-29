package controller.voucher;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.OrderService;
import service.UserAddressService;
import service.UserDiscountService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;


@WebServlet("/place-order")
public class PlaceOrderController extends HttpServlet {
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("30000");
    private final OrderService orderService = new OrderService();
    private final UserDiscountService userDiscountService = new UserDiscountService();
    private final UserAddressService userAddressService = new UserAddressService();
    private final CartDao cartDao = new CartDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        @SuppressWarnings("unchecked")
        List<CartItem> checkOutItems = (List<CartItem>) session.getAttribute("checkOutItems");
        if (checkOutItems == null || checkOutItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-cart");
            return;
        }
        User user = (User) session.getAttribute("user");

        String fullName = trim(request.getParameter("fullName"));
        String phone = trim(request.getParameter("phoneNumber"));
        String addrDetail = trim(request.getParameter("addressDetail"));
        String ward = trim(request.getParameter("ward"));
        String district = trim(request.getParameter("district"));
        String province = trim(request.getParameter("province"));
        String note = trim(request.getParameter("note"));

        String selectedAddrId = trim(request.getParameter("selectedAddrId"));
        if (user != null && selectedAddrId != null && !selectedAddrId.isEmpty()) {
            try {
                int addrId = Integer.parseInt(selectedAddrId);
                List<UserAddress> addrs = userAddressService.getUserAddressByUserId(user.getId());
                for (UserAddress addr : addrs) {
                    if (addr.getId() == addrId) {
                        addrDetail = addr.getAddressDetail();
                        ward = nvl(addr.getWard());
                        district = nvl(addr.getDistrict());
                        province = nvl(addr.getProvince());
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        StringBuilder fullAddr = new StringBuilder(addrDetail);
        if (ward != null && !ward.isEmpty()) fullAddr.append(", ").append(ward);
        if (district != null && !district.isEmpty()) fullAddr.append(", ").append(district);
        if (province != null && !province.isEmpty()) fullAddr.append(", ").append(province);

        if (fullName.isEmpty() || phone.isEmpty() || addrDetail.isEmpty() || province.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng điền đầy đủ thông tin nhận hàng!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        int paymentMethod = 1;
        try {
            paymentMethod = Integer.parseInt(request.getParameter("paymentMethod"));
        } catch (Exception ignored) {
        }
        int discountId = 0;
        BigDecimal discountAmount = BigDecimal.ZERO;
        try {
            String dIdStr = request.getParameter("discountId");
            String dAmtStr = request.getParameter("discountAmount");
            if (dIdStr != null && !dIdStr.isEmpty()) discountId = Integer.parseInt(dIdStr);
            if (dAmtStr != null && !dAmtStr.isEmpty()) discountAmount = new BigDecimal(dAmtStr);
        } catch (Exception ignored) {
        }
        BigDecimal subTotal = BigDecimal.ZERO;
        for (CartItem item : checkOutItems) {
            subTotal = subTotal.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        if (discountAmount.compareTo(subTotal) > 0) discountAmount = subTotal;
        BigDecimal totalAmount = subTotal.subtract(discountAmount).add(SHIPPING_FEE);

        Order order = new Order();
        order.setOrderCode("ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        order.setUserId(user != null ? user.getId() : 0);
        order.setFullName(fullName);
        order.setPhoneNumber(phone);
        order.setAddress(fullAddr.toString());
        order.setDiscountId(discountId);
        order.setSubTotal(subTotal);
        order.setDiscountAmount(discountAmount);
        order.setShippingFee(SHIPPING_FEE);
        order.setTotalAmount(totalAmount);
        order.setNote(note);
        order.setPaymentMethod(paymentMethod);
        order.setOrderStatus(1);

        int orderId;
        try {
            orderId = orderService.createOrder(order, checkOutItems);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Đặt hàng thất bại. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        if (orderId <= 0) {
            session.setAttribute("errorMsg", "Đặt hàng thất bại. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        if (user != null && discountId > 0) {
            try {
                userDiscountService.markAsUsed(user.getId(), discountId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            String selectedIdsRaw = (String) session.getAttribute("checkedOutSelectedIds");
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null && selectedIdsRaw != null) {
                for (String part : selectedIdsRaw.split(",")) {
                    try {
                        int pid = Integer.parseInt(part.trim());
                        cart.removeItem(pid);
                    } catch (Exception ignored) {
                    }
                }
                session.setAttribute("cart", cart);
                if (user != null) {
                    cartDao.saveCartToDB(user.getId(), cart);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");
        session.removeAttribute("checkoutSelectedIds");
        session.removeAttribute("appliedDiscount");
        session.removeAttribute("appliedDiscountId");
        session.removeAttribute("appliedDiscountAmount");

        response.sendRedirect(request.getContextPath() + "/order-detail? id=" + orderId);


    }

    private String nvl(String s) {
        return s == null ? "" : s;
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
