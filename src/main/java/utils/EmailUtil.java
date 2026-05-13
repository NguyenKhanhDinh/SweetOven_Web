package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailUtil {
    private static final String FROM_EMAIL = "khanhdinhthpt@gmail.com";
    private static final String APP_PASSWORD = "wopt lrhp xuro jkcn";

    public static void sendOtpEmail(String toEmail, String fullName, String otp) throws Exception {
        Session session = buildSession();

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "Sweet Oven Bakery"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("Mã OTP của bạn");
        String html = "<div style='font-family:sans-serif;max-width:480px;margin:auto'>"
                + "<h2 style='color:#3C2F27'>Xin chào " + fullName + "!</h2>"
                + "<p>Mã OTP xác thực tài khoản của bạn là:</p>"
                + "<h1 style='letter-spacing:10px;color:#D4A76A;text-align:center'>" + otp + "</h1>"
                + "<p style='color:#999;font-size:13px'>Mã có hiệu lực trong <b>5 phút</b>. Không chia sẻ mã này cho ai.</p>"
                + "</div>";
        message.setContent(html, "text/html; charset=utf-8");
        Transport.send(message);
    }
    private static Session buildSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
    }
    public static void sendResetPasswordEmail(String toEmail, String fullName, String resetLink) throws Exception {
        Session session = buildSession();
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "Sweet Oven Bakery"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("Đặt lại mật khẩu - Sweet Oven Bakery");
        String html = "<div style='font-family:sans-serif;max-width:520px;margin:auto;background:#F9F6F0;border-radius:12px;padding:30px'>"
                + "<div style='text-align:center;margin-bottom:20px'>"
                + "<h1 style='color:#3C2F27;font-size:1.8rem;margin:0'>Sweet Oven Bakery</h1>"
                + "</div>"
                + "<h2 style='color:#3C2F27'>Xin chào " + fullName + "!</h2>"
                + "<p style='color:#555;line-height:1.6'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                + "<p style='color:#555;line-height:1.6'>Nhấn vào nút bên dưới để tạo mật khẩu mới:</p>"
                + "<div style='text-align:center;margin:30px 0'>"
                + "<a href='" + resetLink + "' style='background:#3C2F27;color:#fff;padding:14px 36px;border-radius:30px;"
                + "text-decoration:none;font-weight:700;font-size:15px;letter-spacing:1px;display:inline-block'>"
                + "ĐẶT LẠI MẬT KHẨU</a>"
                + "</div>"
                + "<p style='color:#999;font-size:13px;line-height:1.6'>Liên kết này có hiệu lực trong <b>15 phút</b>.</p>"
                + "<p style='color:#999;font-size:13px'>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>"
                + "<hr style='border:none;border-top:1px solid #e0d8cc;margin:20px 0'>"
                + "<p style='color:#bbb;font-size:12px;text-align:center'>© Sweet Oven Bakery</p>"
                + "</div>";
        message.setContent(html, "text/html; charset=utf-8");
        Transport.send(message);
    }
}
