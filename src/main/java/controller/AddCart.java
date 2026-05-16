package controller;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.Product;
import model.User;
import service.ProductService;

import java.io.IOException;

@WebServlet("/add-cart")
public class AddCart extends HttpServlet {
 private final CartDao cartDao = new CartDao();
 @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       HttpSession session = request.getSession();

       int productId;
       int quantity ;
       try {
           productId = Integer.parseInt(request.getParameter("productId"));
           String qtyParam = request.getParameter("quantity");
           quantity = (qtyParam != null && !qtyParam.isEmpty()) ? Integer.parseInt(qtyParam) : 1;
       }catch (NumberFormatException e){
           session.setAttribute("error", "Tham số không hợp lệ!");
           response.sendRedirect(request.getContextPath()+"/menu");
           return;
       }
       String returnUrl = request.getParameter("returnUrl");
       if (returnUrl == null || returnUrl.isEmpty()) {
           returnUrl = request.getContextPath() + "/menu";
       }
     Cart cart = (Cart) session.getAttribute("cart");
     if (cart == null) {
         cart = new Cart();
         session.setAttribute("cart", cart);
     }
     ProductService productService = new ProductService();
     Product product = productService.findById(productId);

     if(product == null){
         session.setAttribute("error","Sản phẩm không tồn tại!");
         response.sendRedirect(returnUrl);
         return;
     }
     int currentQtyInCart = (cart.get(productId)!= null)? cart.get(productId).getQuantity(): 0;
     if(currentQtyInCart + quantity > product.getStockQuantity()){
         session.setAttribute("error","Số lượng trong kho không đủ ! Còn" +(product.getStockQuantity()-currentQtyInCart)+ " sản phẩm");
         response.sendRedirect(returnUrl);
         return;
     }
     cart.addItem(product, quantity);
     session.setAttribute("cart", cart);
     session.setAttribute("message","Đã thêm\""+product.getName()+"\" vào giỏ hàng!");

     User user = (User) session.getAttribute("user");
     if(user != null){
         syncCartToDB(user.getId(), cart);
     }
     response.sendRedirect(returnUrl);
    }

    private void syncCartToDB(int userId, Cart cart) {
     try {
         cartDao.saveCartToDB(userId, cart);
     }catch (Exception e){
         System.err.println("[CartSync] lỗi lưu  cart xuống database cho user" + userId + ":" + e.getMessage());
     }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     doGet(request, response);
    }


}
