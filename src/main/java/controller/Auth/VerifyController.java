package controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/verify")
public class VerifyController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) == null || request.getSession().getAttribute("pendingEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        request.getRequestDispatcher("authPage/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pendingOtp") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        String inputOtp = request.getParameter("otp");
        String correctOtp = (String) session.getAttribute("pendingOtp");
        long expiry = (long) session.getAttribute("otpExpiry");

        if (System.currentTimeMillis() > expiry) {
            request.setAttribute("error", "Mã OTP đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("authPage/verify.jsp").forward(request, response);
            return;
        }
        if (!correctOtp.equals(inputOtp)) {
            request.setAttribute("error", "Mã OTP không đúng, vui lòng thử lại");
            request.getRequestDispatcher("authPage/verify.jsp").forward(request, response);
            return;
        }
        session.removeAttribute("pendingOtp");
        session.removeAttribute("pendingEmail");
        session.removeAttribute("otpExpiry");
        response.sendRedirect(request.getContextPath() + "/login?register=true");
    }
}
