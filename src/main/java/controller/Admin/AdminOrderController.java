package controller.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.User;
import service.OrderService;
import utils.GHNUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderController extends HttpServlet {

    private OrderService orderService = new OrderService();
    private static final int PAGE_SIZE = 10;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "view":
                viewOrder(request, response);
                break;
            case "api":
                apiGetOrder(request, response);
                break;
            default:
                listOrders(request, response);
                break;
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String statusParam = request.getParameter("status");
        String paymentMethodParam = request.getParameter("paymentMethod");
        String pageParam = request.getParameter("page");

        int status = parseIntOrDefault(statusParam, -1);
        int paymentMethod = parseIntOrDefault(paymentMethodParam, -1);
        int page = Math.max(1, parseIntOrDefault(pageParam, 1));

        List<Order> orders = orderService.getOrders(keyword, status, paymentMethod, page, PAGE_SIZE);
        int totalOrders = orderService.countOrders(keyword, status, paymentMethod);
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        request.setAttribute("totalAllOrders", orderService.countAllOrders());
        request.setAttribute("pendingOrders", orderService.countByStatus(1));
        request.setAttribute("processingOrders", orderService.countByStatus(2));
        request.setAttribute("shippingOrders", orderService.countByStatus(3));
        request.setAttribute("deliveredOrders", orderService.countByStatus(4));
        request.setAttribute("cancelledOrders", orderService.countByStatus(5));
        request.setAttribute("todayOrders", orderService.countOrdersToday());

        request.setAttribute("orders", orders);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("statusFilter", status);
        request.setAttribute("methodFilter", paymentMethod);

        request.getRequestDispatcher("/adminPage/admin_orders.jsp").forward(request, response);
    }

    private void apiGetOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        if (id <= 0) {
            response.getWriter().write("{\"error\":\"ID không hợp lệ\"}");
            return;
        }
        Order order = orderService.findById(id);
        if (order == null) {
            response.getWriter().write("{\"error\":\"Không tìm thấy đơn hàng\"}");
            return;
        }
        List<OrderDetail> details = orderService.getOrderDetails(id);

        boolean isGhnCreated = isGhnOrderCode(order.getOrderCode());

        StringBuilder detailsJson = new StringBuilder("[");
        for (int i = 0; i < details.size(); i++) {
            OrderDetail detail = details.get(i);
            if (i > 0) detailsJson.append(",");
            String name = detail.getProductName() != null ? escapeJson(detail.getProductName()) : "";
            String image = detail.getProductImage() != null ? escapeJson(detail.getProductImage()) : "";
            detailsJson.append(String.format(
                    "{\"productId\":%d,\"productName\":\"%s\",\"productImage\":\"%s\",\"quantity\":%d,\"buyPrice\":\"%s\",\"totalPrice\":\"%s\"}",
                    detail.getProductId(), name, image, detail.getQuantity(), detail.getBuyPriceFormatted(), detail.getTotalPriceFormatted()
            ));
        }
        detailsJson.append("]");
        String json = String.format(
                "{\"id\":%d,\"orderCode\":\"%s\",\"fullName\":\"%s\",\"phoneNumber\":\"%s\"," +
                        "\"address\":\"%s\",\"orderDate\":\"%s\",\"paymentMethod\":%d,\"orderStatus\":%d,\"note\":\"%s\",\"cancelReason\":\"%s\"," +
                        "\"subTotal\":\"%s\",\"discountAmount\":\"%s\",\"shippingFee\":\"%s\",\"totalAmount\":\"%s\",\"isGhnCreated\":%b,\"details\":%s}",
                order.getId(), escapeJson(order.getOrderCode()), escapeJson(order.getFullName()), escapeJson(order.getPhoneNumber()),
                escapeJson(order.getAddress()), order.getOrderDateFormatted(), order.getPaymentMethod(), order.getOrderStatus(),
                escapeJson(order.getNote()), escapeJson(order.getCancelReason()), order.getSubTotalFormatted(), order.getDiscountAmountFormatted(),
                order.getShippingFeeFormatted(), order.getTotalAmountFormatted(),isGhnCreated, detailsJson
        );
        response.getWriter().write(json);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t").replace("\f", "\\f").replace("\b", "\\b");
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        Order order = orderService.findById(id);
        if (order == null) {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy đơn hàng");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        List<OrderDetail> details = orderService.getOrderDetails(id);
        request.setAttribute("viewOrder", order);
        request.setAttribute("orderDetails", details);
        listOrders(request, response);
    }

    private int parseIntOrDefault(String param, int defaultVal) {
        if (param == null || param.isBlank()) return defaultVal;
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        return true;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        switch (action) {
            case "updateStatus":
                updateStatus(request, response);
                break;
            case "cancel":
                cancelOrder(request, response);
                break;
            case "createGhn":
                createGhnOrder(request, response);
                break;
            case "syncGhn":
                syncGhnStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void createGhnOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        HttpSession session = request.getSession();

        if (id <= 0) {
            session.setAttribute("errorMsg", "ID đơn hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        Order order = orderService.findById(id);
        if (order == null) {
            session.setAttribute("errorMsg", "Không tìm thấy đơn hàng!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        if (order.getOrderStatus() != 2) {
            session.setAttribute("errorMsg", "Chỉ tạo đơn GHN khi đơn hàng ở trạng thái Đang xử lý!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        if (isGhnOrderCode(order.getOrderCode())) {
            session.setAttribute("errorMsg","Đơn hàng đã có mã GHN: " + order.getOrderCode() + " không thể tạo lại!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        String address = order.getAddress();
        String province = "", district = "", ward = "", streetAddress = address;
        if (address != null) {
            String[] parts = address.split(",");
            if (parts.length >= 4) {
                streetAddress = parts[0].trim();
                ward = parts[parts.length - 3].trim();
                district = parts[parts.length - 2].trim();
                province = parts[parts.length - 1].trim();
            } else if (parts.length == 3) {
                streetAddress = parts[0].trim();
                district = parts[1].trim();
                province = parts[2].trim();
            }
        }
        int districtId = GHNUtil.getDistrictId(province, district);
        String wardCode = (districtId > 0 && !ward.isEmpty()) ? GHNUtil.getWardCode(districtId, ward) : null;
        if (districtId == -1) {
            session.setAttribute("errorMsg", "Không xác định được địa chỉ giao hàng trên GHN. Kiểm tra lại địa chỉ đơn hàng #" + id);
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        long codAmount = (order.getPaymentMethod() == 1) ? order.getTotalAmount().longValue() : 0L;
        String ghnCode = GHNUtil.createOrder(order.getFullName(), order.getPhoneNumber(), streetAddress, districtId, wardCode, codAmount, order.getNote());
        if (ghnCode == null || ghnCode.isEmpty()) {
            session.setAttribute("errorMsg", "Tạo đơn hàng nhanh thất bại! Kiểm tra log server để biết chi tiết");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        OrderService.UpdateResult saveResult = orderService.updateOrderCode(id, ghnCode);
        if (saveResult == OrderService.UpdateResult.SUCCESS) {
            session.setAttribute("successMsg", "Tạo đơn GHN thành công! Mã đơn hàng " + ghnCode);
        } else {
            session.setAttribute("errorMsg", "Tạo đơn giao hàng nhanh thành công (mã: " + ghnCode + ") nhưng lưu DB thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
    }

    private void syncGhnStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        HttpSession session = request.getSession();

        if (id <= 0) {
            session.setAttribute("errorMsg", "ID không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        Order order = orderService.findById(id);
        if (order == null) {
            session.setAttribute("errorMsg", "Không tìm thấy đơn hàng!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        if(!isGhnOrderCode(order.getOrderCode())) {
            session.setAttribute("errorMsg","Đơn hàng #" +id +" chưa có mã GHN. Hãy tạo đơn giao hàng nhanh trước!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        String ghnStatus = GHNUtil.trackOrder(order.getOrderCode());
        if (ghnStatus == null) {
            session.setAttribute("errorMsg", "Không lấy được trạng thái từ GHN!");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        int newStatus = mapGhnStatus(ghnStatus);
        if (newStatus == -1) {
            session.setAttribute("successMsg", "Trạng thái GHN:" + ghnStatus + "(Chưa cập nhật)");
            response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
            return;
        }
        OrderService.UpdateResult result = orderService.forceUpdateOrderStatus(id, newStatus);
        if (result == OrderService.UpdateResult.SUCCESS) {
            session.setAttribute("successMsg", "Đồng bộ trạng thái từ GHN thành công! (" + ghnStatus + "->" + STATUS_MAP[newStatus] + ")");
        } else {
            session.setAttribute("errorMsg", "Đồng bộ trạng thái thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
    }

    private int mapGhnStatus(String ghnStatus) {
        if (ghnStatus == null) return -1;
        switch (ghnStatus.toUpperCase()) {
            case "READY_TO_PICK":
            case "PICKING":
                return 2;
            case "PICKED":
            case "STORING":
            case "TRANSPORTING":
            case "SORTING":
            case "DELIVERING":
                return 3;
            case "DELIVERED":
                return 4;
            case "CANCEL":
            case "RETURN":
            case "RETURNED":
            case "RETURN_TRANSPORTING":
            case "RETURN_SORTING":
            case "DAMAGE":
            case "LOST":
                return 5;
            default:
                return -1;
        }
    }
    private static final String[] STATUS_MAP = {"","Chờ xác nhận","Đang xử lý","Đang giao","Đã giao","Đã hủy"};

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        String reason = request.getParameter("reason");

        OrderService.UpdateResult result = orderService.cancelOrderAdmin(id, reason);
        HttpSession session = request.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Đã hủy đơn hàng thành công!");
                break;
            case NOT_FOUND:
                session.setAttribute("errorMsg", "Không tìm thấy đơn hàng!");
                break;
            case INVALID_TRANSITION:
                session.setAttribute("errorMsg", "Đơn hàng đã giao hoặc đã hủy, không thể hủy thêm!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        int newStatus = parseIntOrDefault(request.getParameter("newStatus"), -1);

        OrderService.UpdateResult result = orderService.updateOrderStatus(id, newStatus);
        HttpSession session = request.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Cập nhật trạng thái đơn hàng thành công!");
                break;
            case NOT_FOUND:
                session.setAttribute("errorMsg", "Không tìm thấy đơn hàng!");
                break;
            case INVALID_TRANSITION:
                session.setAttribute("errorMsg", "Không thể chuyển sang trạng thái này!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders" + buildQueryString(request));
    }

    private String buildQueryString(HttpServletRequest request) {
        StringBuffer sb = new StringBuffer("?");
        for (String p : new String[]{"keyword", "status", "paymentMethod", "page"}) {
            String v = request.getParameter(p);
            if (v != null && !v.isBlank()) sb.append(p).append("=").append(v).append("&");
        }
        String qs = sb.toString();
        return qs.equals("?") ? "" : qs.substring(0, qs.length() - 1);
    }
    private static  boolean isGhnOrderCode(String orderCode) {
       return orderCode != null && orderCode.matches("^[A-Z]{2,}[A-Z0-9]{4,}$");
    }
}
