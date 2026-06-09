package controller.voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Discount;
import model.User;
import service.DiscountService;
import service.UserDiscountService;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

@WebServlet("/apply-discount")
public class ApplyDiscountController extends HttpServlet {
    private final DiscountService discountService = new DiscountService();
    private final UserDiscountService userDiscountService = new UserDiscountService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            writeJson(response, false, 0, 0, "Vui lòng đăng nhập để sử dụng mã giảm giá!");
            return;
        }

        String action = request.getParameter("action");
        if ("remove".equals(action)) {
            if (session != null) {
                session.removeAttribute("appliedDiscount");
                session.removeAttribute("appliedDiscountId");
                session.removeAttribute("appliedDiscountAmount");
            }
            writeJson(response, true, 0, 0, "Đã xóa mã giảm giá.");
            return;
        }
        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            writeJson(response, false, 0, 0, "Vui lòng nhập lại mã giảm giá.");
            return;
        }
        BigDecimal subtotal = BigDecimal.ZERO;
        if (session != null) {
            Object obj = session.getAttribute("checkoutTotal");
            if (obj instanceof BigDecimal) subtotal = (BigDecimal) obj;
        }
        Discount discount;
        try {
            discount = discountService.getDiscountByCode(code.trim());
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, false, 0, 0, "Lỗi hệ thống. Vui lòng thử lai!");
            return;
        }

        if (discount == null) {
            writeJson(response, false, 0, 0, "Mã giảm giá không tồn tại!");
            return;
        }
        if (!discount.isValid()) {
            writeJson(response, false, 0, 0, "Mã giảm giá đã hết hạn hoặc chưa bắt đầu!");
            return;
        }
        boolean alreadySaved = userDiscountService.isAlreadySaved(user.getId(), discount.getId());

        if (userDiscountService.isAlreadyUsed(user.getId(), discount.getId())) {
            writeJson(response, false, 0, 0, "Tài khoản của bạn đã sử dụng mã này rồi!");
            return;
        }
        if (!alreadySaved){
            userDiscountService.saveDiscount(user.getId(), discount.getId());
        }
        if (discount.getMinValueOrder() != null && subtotal.compareTo(discount.getMinValueOrder()) < 0) {
            String minStr = String.format("%,.0f", discount.getMinValueOrder());
            writeJson(response, false, 0, 0, "Đơn hàng chưa đạt giá trị tối thiểu" + minStr + " VNĐ để áp dụng mã này!");
            return;
        }
        BigDecimal discountAmount = discountService.calculateDiscountAmount(discount, subtotal);
        if (discountAmount == null) {
            writeJson(response, false, 0, 0, "Không thể áp dụng mã giảm giá này!");
            return;
        }
        if (session != null) {
            session.setAttribute("appliedDiscount", discount);
            session.setAttribute("appliedDiscountId", discount.getId());
            session.setAttribute("appliedDiscountAmount", discountAmount);
        }
        writeJson(response, true, discount.getId(), discountAmount.longValue(), "Áp dụng mã thành công! Giảm " + discount.getDisplayValue());
    }


    private void writeJson(HttpServletResponse response, boolean success, int discountId, long discountAmount, String message) throws IOException {
        String escaped = message.replaceAll("\"", "\\\"");
        String json = String.format("{\"success\":%b,\"discountId\":%d,\"discountAmount\":%d,\"message\":\"%s\"}", success, discountId, discountAmount, escaped);
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
