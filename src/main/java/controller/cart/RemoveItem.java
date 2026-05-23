package controller.cart;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/del-item")
public class RemoveItem extends HttpServlet {
    private final CartDao cartDao = new CartDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/my-cart");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Giỏ hàng không tồn tại !\"}");
            return;
        }
        int productId ;
        try {
            productId = Integer.parseInt(request.getParameter("productId"));
        }catch (NumberFormatException e){
            response.getWriter().write("{\"success\":false,\"message\":\"ProductId không hợp lệ !\"}");
            return;
        }
        cart.removeItem(productId);
        session.setAttribute("cart", cart);

        User user = (User) session.getAttribute("user");
        if (user != null) {
            try {
                cartDao.saveCartToDB(user.getId(), cart);
            }catch (Exception e){
                System.err.println("[RemoveItem]Lỗi sync database:" +e.getMessage());
            }
        }
        BigDecimal cartTotal =cart.getTotalPrice();
        int totalQuantity = cart.getTotalQuantity();

        String json = String.format(
                "{\"success\":true,\"message\":\"Đã xóa sản phẩm!\",\"cartTotal\":%s,\"totalQuantity\":%d}",
                cartTotal.toPlainString(),totalQuantity
        );
        response.getWriter().write(json);
    }
}
