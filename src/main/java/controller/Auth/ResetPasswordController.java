package controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {
    private UserService userService;

    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        UserService.ResetPasswordResult result = userService.validateToken(token);
        if(result == UserService.ResetPasswordResult.INVALID_TOKEN){
            request.setAttribute("tokenError", "Liên kết không hợp lệ hoặc đã được sử dụng");
        }else  if(result == UserService.ResetPasswordResult.EXPIRED_TOKEN){
            request.setAttribute("tokenError", "Liên kết đã hết hạn, vui lòng thử lại");
        }else {
            request.setAttribute("token", token);
        }
        request.getRequestDispatcher("/authPage/resetpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");
        UserService.ResetPasswordResult result = userService.resetPassword(token, newPassword, confirmPwd);
        switch (result) {
            case SUCCESS:
                request.setAttribute("success", "Mật khẩu đã được đặt lại thành công. Bạn có thể đăng nhập với mật khẩu mới");
                break;
            case COMFIRM_NOT_MATCH:
                request.setAttribute("error", "Mật khẩu xác nhận không khớp");
                request.setAttribute("token", token);
                break;
            case WEAK_PASSWORD:
                request.setAttribute("error", "Mật khẩu mới quá yếu, vui lòng chọn mật khẩu mạnh hơn");
                request.setAttribute("token", token);
                break;
            case EXPIRED_TOKEN:
                request.setAttribute("error", "Liên kết đã hết hạn, vui lòng thử lại");
                break;
            default:
                request.setAttribute("error", "Con lỗi xảy ra, vui lòng thử lại");
                request.setAttribute("token", token);
                break;
        }
        request.getRequestDispatcher("/authPage/resetpassword.jsp").forward(request, response);
    }
}
