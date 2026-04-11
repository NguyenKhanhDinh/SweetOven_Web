package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.UserService;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    UserService userService = new UserService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User loginUser = (User) request.getSession().getAttribute("user");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }
        User user = userService.findById(loginUser.getId());
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/user.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
