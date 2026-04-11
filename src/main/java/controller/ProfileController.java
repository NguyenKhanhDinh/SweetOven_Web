package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loginUser = (User) request.getSession().getAttribute("user");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String genderStr = request.getParameter("gender");

        loginUser.setFullName(fullName);
        loginUser.setEmail(email);
        loginUser.setPhoneNumber(phone);
        int gender =-1;
        try {
            if (genderStr != null && !genderStr.isBlank()) {
                loginUser.setGender(Integer.parseInt(genderStr));
            }
        } catch (NumberFormatException e) {
           gender =-1;
        }

        String message = userService.updateProfile(loginUser);
        if ("SUCCESS".equals(message)) {
            session.setAttribute("successMsg", "Cập nhật thành công!");
        }else{
            session.setAttribute("errorMsg",message);
        }
        response.sendRedirect(request.getContextPath()+"/profile");
    }
}
