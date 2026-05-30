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
        HttpSession session = request.getSession();
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String redirectTo = request.getParameter("redirectTo");
        String redirectUrl ;
        if("home".equals(redirectTo)) {
            redirectUrl = request.getContextPath() +"/home";
        }else{
            redirectUrl = request.getContextPath() +"/vouchers";
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=vouchers");
            return;
        }
        String discountIdStr = request.getParameter("discountId");
        if (discountIdStr == null || discountIdStr.isBlank()) {
            session.setAttribute("errorMsg", "Voucher không hợp lệ!");
            response.sendRedirect(redirectUrl);
            return;
        }
        int discountId;
        try {
            discountId = Integer.parseInt(discountIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Voucher không hợp lệ!");
            response.sendRedirect(redirectUrl);
            return;
        }
        try {
            if (userDiscountService.isAlreadySaved(user.getId(), discountId)) {
                session.setAttribute("errorMsg", "Bạn đã lưu Voucher này rồi!");
            } else {
                boolean saved = userDiscountService.saveDiscount(user.getId(), discountId);
                if (saved) {
                    session.setAttribute("successMsg", "Lưu Voucher thành công!");
                } else {
                    session.setAttribute("errorMsg", "Không thể lưu Voucher vui lòng thử lại!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi hệ thống. Vui lòng thử lại!");
        }
        response.sendRedirect(redirectUrl);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.sendRedirect(request.getContextPath() + "/vouchers");
    }
}
