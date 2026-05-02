package utils;

import com.mysql.cj.Session;
import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailUtil {
    private static final String FROM_EMAIL = "khanhdinhthpt@gmail.com";
    private static final String APP_PASSWORD = "wopt lrhp xuro jkcn";

    public static void sendOtpEmail(String toEmail, String fullName, String otp) throws MessagingException {
        Sesstion sesstion = buildSession();

        MimeMessage message = new MimeMessage(sesstion);
        message.setForm()

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
