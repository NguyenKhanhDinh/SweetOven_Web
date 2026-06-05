package controller.voucher;

import dao.CartDao;
import dao.OrderDao;
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
import utils.EmailUtil;
import utils.GHNUtil;
import utils.MomoUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;


@WebServlet("/place-order")
public class PlaceOrderController extends HttpServlet {
    private static final BigDecimal DEFLAUT_SHIPPING_FEE = new BigDecimal("30000");
    private final OrderService orderService = new OrderService();
    private final UserDiscountService userDiscountService = new UserDiscountService();
    private final UserAddressService userAddressService = new UserAddressService();
    private final CartDao cartDao = new CartDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        @SuppressWarnings("uncheked")
        List<CartItem> checkoutItems = (List<CartItem>) session.getAttribute("checkoutItems");
        if (checkoutItems == null || checkoutItems.isEmpty()) {
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

        String guestEmail = "";
        if (user == null) {
            guestEmail = trim(request.getParameter("guestEmail"));
            if (!guestEmail.isEmpty() && !guestEmail.matches("^[\\w.+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z](.+){2,}$")) {
                session.setAttribute("error", "Email không hợp lệ. Vui lòng kiểm tra lại!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
        }

        int ghnDistrictId = 0;
        String ghnWardCode = "";
        try {
            String dId = trim(request.getParameter("ghnDistrictId"));
            String wc = trim(request.getParameter("ghnWardCode"));
            if (!dId.isEmpty()) ghnDistrictId = Integer.parseInt(dId);
            if (!wc.isEmpty()) ghnWardCode = wc;
        } catch (Exception ignored) {
        }
        BigDecimal shippingFee = DEFLAUT_SHIPPING_FEE;
        try {
            String feeStr = trim(request.getParameter("shippingFee"));
            if (!feeStr.isEmpty()) {
                shippingFee = new BigDecimal(feeStr);
            }
        } catch (Exception ignored) {
        }

        String selectedAddrId = trim(request.getParameter("selectedAddressId"));
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
        if (user == null && guestEmail.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng nhập lại email để nhận hóa đơn đặt hàng!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        int paymentMethod = 1;
        try {
            paymentMethod = Integer.parseInt(request.getParameter("paymentMethod"));
        } catch (Exception ignored) {
        }
        Integer discountId = null;
        BigDecimal discountAmount = BigDecimal.ZERO;
        try {
            String dIdStr = request.getParameter("discountId");
            String dAmtStr = request.getParameter("discountAmount");
            if (dIdStr != null && !dIdStr.isEmpty())
                discountId = Integer.parseInt(dIdStr) > 0 ? Integer.parseInt(dIdStr) : null;
            if (dAmtStr != null && !dAmtStr.isEmpty()) discountAmount = new BigDecimal(dAmtStr);
        } catch (Exception ignored) {
        }
        BigDecimal subTotal = BigDecimal.ZERO;
        for (CartItem item : checkoutItems) {
            subTotal = subTotal.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        if (discountAmount.compareTo(subTotal) > 0) discountAmount = subTotal;
        BigDecimal totalAmount = subTotal.subtract(discountAmount).add(shippingFee);

        if (paymentMethod == 2) {
            String orderCode = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String sessionKey = "momo_pending" + orderCode;

            MomoPendingOrder pending = new MomoPendingOrder();
            pending.orderCode = orderCode;
            pending.user = user;
            pending.guestEmail = guestEmail;
            pending.fullName = fullName;
            pending.phone = phone;
            pending.fullAddr = fullAddr.toString();
            pending.ward = nvl(ward);
            pending.district = nvl(district);
            pending.province = nvl(province);
            pending.note = note;
            pending.ghnDistrictId = ghnDistrictId;
            pending.ghnWardCode = ghnWardCode;
            pending.discountId = discountId;
            pending.subTotal = subTotal;
            pending.discountAmount = discountAmount;
            pending.shippingFee = shippingFee;
            pending.totalAmount = totalAmount;
            pending.checkoutItems = checkoutItems;
            pending.checkoutSelectedIds = (String) session.getAttribute("checkoutSelectedIds");

            session.setAttribute(sessionKey, pending);

            try {
                String momoPayUrl = MomoUtil.createPaymentUrl(sessionKey, totalAmount, orderCode);
            } catch (Exception e) {
                System.err.println("[MoMo] Lỗi tạo link thanh toán:" + e.getMessage());
                session.removeAttribute(sessionKey);
                session.setAttribute("errorMsg", "Không thể kết nối MoMo. Vui lòng chọn phương thức thanh toán khác!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
        }

        Order order = buildOrder(null, user, fullName, phone, fullAddr.toString(), discountId, subTotal, discountAmount, shippingFee, totalAmount, note, paymentMethod);


        int orderId;
        try {
            orderId = orderService.createOrder(order, checkoutItems);
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
        order.setId(orderId);
        String ghnOrderCode = null;

        if (user == null && !guestEmail.isEmpty()) {
            final String finalGhnCode = ghnOrderCode;
            final List<CartItem> itemCopy = checkoutItems;
            final Order orderCopy = order;
            final String emailTo = guestEmail;

            new Thread(() -> {
                try {
                    EmailUtil.sendOrderInvoice(emailTo, orderCopy, itemCopy, finalGhnCode);
                    System.out.println("[EMAIL] Đã gửi hóa đơn tới: " + emailTo + "cho order #" + orderCopy.getOrderCode());
                } catch (Exception e) {
                    System.err.println("[EMAIL] Lỗi hóa đơn: " + e.getMessage());
                }
            }).start();
            session.setAttribute("invoiceEmailSent", guestEmail);
        }

        markDiscountUsed(user, discountId);
        cleanCart(session, user, checkoutItems);

        response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);

    }

    public static String createGhnOrder(String fullName, String phone, String fullAddr, int ghnDistrictId, String ghnWardCode, String province, String district, String ward, BigDecimal totalAmount, String note, int orderId, HttpSession session) {
        String ghnOrderCode = null;
        try {
            long codAmount = totalAmount.longValue();
            if (ghnDistrictId == 0 && !province.isEmpty()) {
                ghnDistrictId = GHNUtil.getDistrictId(province, district);
                if (ghnDistrictId != -1 && !ward.isEmpty()) {
                    ghnWardCode = nvlStatic(GHNUtil.getWardCode(ghnDistrictId, ward));
                }
            }
            if (ghnDistrictId > 0) {
                ghnOrderCode = GHNUtil.createOrder(fullName, phone, fullAddr.toString(), ghnDistrictId, ghnWardCode.isEmpty() ? null : ghnWardCode, codAmount, note);
                if (ghnOrderCode != null) {
                    session.setAttribute("lastghnOrderCode_" + orderId, ghnOrderCode);
                }
            }
        } catch (Exception e) {
            System.err.println("[GHN] Lỗi tạo vận đơn(order đã được lưu): " + e.getMessage());
        }
        return ghnOrderCode;
    }

    private static String nvlStatic(String s) {
        return s == null ? "" : s;
    }

    public static Order buildOrder(String orderCode, User user, String fullName, String phone, String fullAddr, Integer discountId, BigDecimal subTotal, BigDecimal discountAmount, BigDecimal shippingFee, BigDecimal totalAmount, String note, int paymentMethod) {
        Order order = new Order();
        order.setOrderCode(orderCode != null ? orderCode : "ORD_" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        order.setUserId(user != null ? user.getId() : null);
        order.setFullName(fullName);
        order.setPhoneNumber(phone);
        order.setAddress(fullAddr);
        order.setDiscountId(discountId);
        order.setSubTotal(subTotal);
        order.setDiscountAmount(discountAmount);
        order.setShippingFee(shippingFee);
        order.setTotalAmount(totalAmount);
        order.setNote(note);
        order.setPaymentMethod(paymentMethod);
        order.setOrderStatus(1);
        return order;
    }

    public void markDiscountUsed(User user, Integer discountId) {
        if (user != null && discountId != null) {
            try {
                userDiscountService.markAsUsed(user.getId(), discountId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void cleanCart(HttpSession session, User user, List<CartItem> checkoutItems) {
        try {
            String selectedIdsRaw = (String) session.getAttribute("checkoutSelectedIds");
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null && selectedIdsRaw != null) {
                for (String part : selectedIdsRaw.split(",")) {
                    try {
                        cart.removeItem(Integer.parseInt(part.trim()));
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
