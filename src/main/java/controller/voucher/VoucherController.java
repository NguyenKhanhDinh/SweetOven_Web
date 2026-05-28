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
import java.util.List;

@WebServlet("/vouchers")
public class VoucherController extends HttpServlet {
    private final DiscountService discountService = new DiscountService();
    private final UserDiscountService userDiscountService = new UserDiscountService();

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Discount> discounts = discountService.getAllDiscounts();
        request.setAttribute("discounts", discounts);

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            try {
                List<Integer> savedIds = userDiscountService.getSavedDiscountIds(user.getId());
                request.setAttribute("savedIds", savedIds);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/WEB-INF/vouchers.jsp").forward(request, response);
    }
}
