package controller.voucher;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserDiscountService;

import java.io.IOException;

@WebServlet("/save-voucher")
public class SaveVoucherController extends HttpServlet {
    private final UserDiscountService userDiscountService = new UserDiscountService();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (session != null) ? (User) session.getAttribute("user") : null;


        if (user == null) {
            response.getWriter().write("{\"status\":\"login\",\"message\":\"Vui lòng đăng nhập để lưu voucher!\"}");
            return;
        }
        String discountIdStr = request.getParameter("discountId");
        if (discountIdStr == null || discountIdStr.isBlank()) {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Voucher không hợp lệ!\"}");
            return;
        }
        int discountId;
        try {
            discountId = Integer.parseInt(discountIdStr.trim());
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Voucher không hợp lệ!\"}");
            return;
        }
        try {
            if (userDiscountService.isAlreadySaved(user.getId(), discountId)) {
                response.getWriter().write("{\"status\":\"already\",\"message\":\"Bạn đã lưu voucher này rồi!\"}");
            } else {
                boolean saved = userDiscountService.saveDiscount(user.getId(), discountId);
                if (saved) {
                    response.getWriter().write("{\"status\":\"ok\",\"message\":\"Lưu voucher thành công!\"}");
                } else {
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Không thể lưu voucher. Vui lòng thử lại!\"}");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Hệ thống lỗi. Vui lòng thử lại!\"}");

        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.sendRedirect(request.getContextPath() + "/vouchers");
    }
}
