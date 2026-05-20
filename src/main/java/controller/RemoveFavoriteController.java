package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.UserFavoriteService;

import java.io.IOException;

@WebServlet("/remove-favorite")
public class RemoveFavoriteController extends HttpServlet {
 UserFavoriteService userFavoriteService = new UserFavoriteService();
 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     User loginUser = (User) request.getSession().getAttribute("user");
     if(loginUser==null){
         response.sendRedirect(request.getContextPath()+"/login");
         return;
     }
     try {
         int productId = Integer.parseInt(request.getParameter("id"));
         userFavoriteService.removeFavorites(productId,loginUser.getId());
     }catch (NumberFormatException e){}
     response.sendRedirect(request.getContextPath()+"/profile");
 }
}
