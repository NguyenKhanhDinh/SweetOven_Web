package controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import model.User;
import java.io.IOException;

@WebServlet("/login")
public class LoginControllerr extends HttpServlet {
private UserService userService;

    public void init() {
        userService = new UserService();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    if (session != null && session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath()+"/home");
        return;
    }
    request.getRequestDispatcher("/authPage/login.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User user = userService.login(username, password);

        if(user!=null){
            HttpSession session = request.getSession();
            session.setAttribute("user",user);

            response.sendRedirect(request.getContextPath()+"/home");
        }else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/authPage/login.jsp").forward(request, response);
        }
    }

}
