package controller.cart;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.CartItem;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/update-cart")
public class UpdateCart extends HttpServlet {
    private final CartDao cartDao = new CartDao();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Giỏ hàng không tồn tại!\"}");
            return;
        }

       int productId;
        try{
            productId = Integer.parseInt(request.getParameter("productId"));
        }catch(NumberFormatException e){
            response.getWriter().write("{\"success\":false,\"message\":\"ProductId không hợp lệ!\"}");
            return;
        }

        String action = request.getParameter("action");
        String errorMsg = null;

        if("increase".equals(action)){
            CartItem cartItem = cart.get(productId);
            if(cartItem != null && cartItem.getQuantity() < cartItem.getProduct().getStockQuantity()){
                cart.increase(productId);
            }else {
                errorMsg = "Đã đạt số lượng tối đa";
            }
        }else if("decrease".equals(action)){
            cart.decrease(productId);
        }else if("set".equals(action)){
            try{
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                CartItem cartItem = cart.get(productId);
                if(cartItem != null ){
                    int stock = cartItem.getProduct().getStockQuantity();
                    if( quantity < 1) quantity = 1;
                    if(quantity>stock) {
                        quantity = stock;
                        errorMsg = "Chỉ còn " + stock + " sản phẩm trong kho";
                    }
                    cart.updateItem(productId,quantity);
                }

            }catch(NumberFormatException e){
                response.getWriter().write("{\"success\":false,\"message\":\"Số lượng không hợp lệ!\"}");
                return;
            }
        }
        session.setAttribute("cart", cart);
        User user = (User) session.getAttribute("user");
        if(user != null){
            try{
               cartDao.saveCartToDB(user.getId(), cart);
            }catch(Exception e){
                System.err.println("[UpdateCart] Lỗi sync database: " + e.getMessage());
            }
        }
        CartItem updateItem = cart.get(productId);
        int newQty = updateItem != null ? updateItem.getQuantity() : 0;
        BigDecimal itemTotal = updateItem != null ? updateItem.getPrice().multiply(BigDecimal.valueOf(newQty)) : BigDecimal.ZERO;
        BigDecimal cartTotal = cart.getTotalPrice();
        int totalQuantity = cart.getTotalQuantity();

        String json = String.format("{\"success\":true,\"newQty\":%d,\"itemTotal\":%s,\"cartTotal\":%s,\"totalQuantity\":%d%s}"
                ,newQty,itemTotal.toPlainString(),cartTotal.toPlainString(),totalQuantity,errorMsg!=null?",\"warning\":\""+ errorMsg+"\"": "");
        response.getWriter().write(json);

    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         response.sendRedirect(request.getContextPath()+"/my-cart");
    }

}
