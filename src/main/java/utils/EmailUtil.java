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
}
