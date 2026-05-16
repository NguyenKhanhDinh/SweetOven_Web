package controller;

import dao.CartDao;
import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.CartItem;
import model.Product;

import java.io.IOException;

@WebServlet("/my-cart")
public class MyCart extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final CartDao cartDao = new CartDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
      HttpSession session = request.getSession();

      Cart cart = (Cart)session.getAttribute("cart");
      if (cart == null){
          cart = new Cart();
          session.setAttribute("cart", cart);
      }
      for(CartItem item : cart.getItems()){
          Product latest = productDao.findById(item.getProduct().getId());
          if(latest != null){
              item.getProduct().setStockQuantity(latest.getStockQuantity());
          }
      }
      request.setAttribute("cart", cart);
      request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
