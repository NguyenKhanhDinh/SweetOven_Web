package controller.Auth;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
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
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/authPage/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserService.LoginResult loginResult = userService.loginCheck(username, password);

        if (loginResult == UserService.LoginResult.NOT_VERIFIED) {
            request.setAttribute("error", "Tài khoản chưa được xác thực email. Vui lòng kiểm tra hộp thư của bạn.");
            request.setAttribute("showResend", true);
            request.setAttribute("pendingUsernameForResend", username);
            request.getRequestDispatcher("/authPage/login.jsp").forward(request, response);
            return;
        }

        if (loginResult == UserService.LoginResult.BLOCKED) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khoá. Vui lòng liên hệ hỗ trợ.");
            request.getRequestDispatcher("/authPage/login.jsp").forward(request, response);
            return;
        }

        User user = userService.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            Cart sessionCart = (Cart) session.getAttribute("cart");
            if (sessionCart == null) sessionCart = new Cart();
            CartDao cartDao = new CartDao();
            Cart merged = cartDao.mergeDBCartIntoSession(user.getId(), sessionCart);
            cartDao.saveCartToDB(user.getId(), merged);
            session.setAttribute("cart", merged);
            if (user.getRoleId() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/authPage/login.jsp").forward(request, response);
        }
    }

}