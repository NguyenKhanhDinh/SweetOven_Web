package controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) != null && request.getSession(false).getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/authPage/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        UserService.ValidateResult result = userService.validate(fullName, username, email, phone, password);
        switch (result) {
            case OK -> {
                String otp = utils.OtpUtil.generateOtp();
                request.getSession().setAttribute("pendingEmail", email);
                request.getSession().setAttribute("pendingFullName", fullName);
                request.getSession().setAttribute("pendingUsername", username);
                request.getSession().setAttribute("pendingPhone", phone);
                request.getSession().setAttribute("pendingPassword", password);
                request.getSession().setAttribute("pendingOtp", otp);
                request.getSession().setAttribute("otpExpiry", System.currentTimeMillis() + 5 * 60 * 1000);
                try {
                    utils.EmailUtil.sendOtpEmail(email, fullName, otp);
                    response.sendRedirect(request.getContextPath()+"/verify-email");
                } catch (Exception e) {
                    forwardWithError(request, response, "Không thể gửi email xác thực, hãy thử lại sau", fullName, username, email, phone);
                }
            }
            case USERNAME_EXISTS ->
                    forwardWithError(request, response, "Tên đăng nhập đã tồn tại", fullName, username, email, phone);
            case EMAIL_EXISTS ->
                    forwardWithError(request, response, "Email đã tồn tại", fullName, username, email, phone);
            case PHONE_EXISTS ->
                    forwardWithError(request, response, "Số điện thoại đã tồn tại", fullName, username, email, phone);
            case INVALID_INPUT ->
                    forwardWithError(request, response, "Dư liệu không hợp lệ", fullName, username, email, phone);
            default ->
                    forwardWithError(request, response, "Lỗi hệ thống, hãy thử lại sau", fullName, username, email, phone);

        }

    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg, String fullName, String username, String email, String phone) throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.setAttribute("fullName", fullName);
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);

        request.getRequestDispatcher("/authPage/register.jsp").forward(request, response);
    }
}
