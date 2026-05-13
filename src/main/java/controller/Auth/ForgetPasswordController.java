package controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

import java.io.IOException;

@WebServlet("/forget-password")
public class ForgetPasswordController extends HttpServlet {
    private UserService userService;

    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        UserService.ResetPasswordResult result = userService.validateToken(token);
        if (result == UserService.ResetPasswordResult.INVALID_TOKEN) {
            request.setAttribute("error", "Liên kết không hợp lệ hoặc đã được sử dụng");
        } else if (result == UserService.ResetPasswordResult.EXPIRED_TOKEN) {
            request.setAttribute("error", "Liên kết đã hết hạn, vui lòng thử lại");
        } else {
            request.setAttribute("token", token);
        }
        request.getRequestDispatcher("/authPage/forgetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
        boolean sent = userService.processForgotPassword(email, baseUrl);
        if (sent) {
            request.setAttribute("message", "Nếu email tồn tại trong hệ thống, một liên kết đặt lại mật khẩu đã được gửi đến email của bạn");
        } else {
            request.setAttribute("error", "Không thể gửi email đặt lại mật khẩu, hãy thử lại sau");
        }
        request.getRequestDispatcher("/authPage/forgetpassword.jsp").forward(request, response);
    }
}