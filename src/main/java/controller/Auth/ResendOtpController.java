package controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/resend-otp")
public class ResendOtpController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("pendingEmail")==null){
            response.sendRedirect(request.getContextPath()+"/register");
            return;
        }
        String email = (String) session.getAttribute("pendingEmail");
        String fullName = (String) session.getAttribute("pendingFullName");
        String newOtp = utils.OtpUtil.generateOtp();
        session.setAttribute("pendingOtp", newOtp);
        session.setAttribute("otpExpiry", System.currentTimeMillis() + 5 * 60 * 1000);
        try {
            utils.EmailUtil.sendOtpEmail(email, fullName, newOtp);
            request.setAttribute("success", "Mã OTP mới đã được gửi đến email của bạn");
        } catch (Exception e) {
            request.setAttribute("error", "Không thể gửi email xác thực, hãy thử lại sau");
        }
        request.getRequestDispatcher("/authPage/verifyemail.jsp").forward(request, response);
    }
}
