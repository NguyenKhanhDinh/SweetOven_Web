package utils;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.*;
import com.sendgrid.helpers.mail.objects.*;
import model.CartItem;
import model.Order;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

public class EmailUtil {
    private static final String FROM_EMAIL = "khanhdinhthpt@gmail.com";
    private static final String FROM_NAME = "Sweet Oven Bakery";
    private static final String API_KEY = System.getenv("SENDGRID_API_KEY");

    private static void sendEmail(String toEmail, String subject, String html) throws Exception {
        Email from = new Email(FROM_EMAIL, FROM_NAME);
        Email to = new Email(toEmail);
        Content content = new Content("text/html", html);
        Mail mail = new Mail(from, subject, to, content);

        SendGrid sg = new SendGrid(API_KEY);
        Request request = new Request();
        request.setMethod(Method.POST);
        request.setEndpoint("mail/send");
        request.setBody(mail.build());
        Response response = sg.api(request);

        if (response.getStatusCode() >= 400) {
            throw new Exception("SendGrid error: " + response.getStatusCode() + " " + response.getBody());
        }
    }

    public static void sendOtpEmail(String toEmail, String fullName, String otp) throws Exception {
        String html = "<div style='font-family:sans-serif;max-width:480px;margin:auto'>"
                + "<h2 style='color:#3C2F27'>Xin chào " + fullName + "!</h2>"
                + "<p>Mã OTP xác thực tài khoản của bạn là:</p>"
                + "<h1 style='letter-spacing:10px;color:#D4A76A;text-align:center'>" + otp + "</h1>"
                + "<p style='color:#999;font-size:13px'>Mã có hiệu lực trong <b>5 phút</b>. Không chia sẻ mã này cho ai.</p>"
                + "</div>";
        sendEmail(toEmail, "Mã OTP của bạn", html);
    }

    public static void sendResetPasswordEmail(String toEmail, String fullName, String resetLink) throws Exception {
        String html = "<div style='font-family:sans-serif;max-width:520px;margin:auto;background:#F9F6F0;border-radius:12px;padding:30px'>"
                + "<h1 style='color:#3C2F27;font-size:1.8rem;margin:0;text-align:center'>Sweet Oven Bakery</h1>"
                + "<h2 style='color:#3C2F27'>Xin chào " + fullName + "!</h2>"
                + "<p style='color:#555;line-height:1.6'>Nhấn vào nút bên dưới để tạo mật khẩu mới:</p>"
                + "<div style='text-align:center;margin:30px 0'>"
                + "<a href='" + resetLink + "' style='background:#3C2F27;color:#fff;padding:14px 36px;border-radius:30px;"
                + "text-decoration:none;font-weight:700;font-size:15px;display:inline-block'>ĐẶT LẠI MẬT KHẨU</a>"
                + "</div>"
                + "<p style='color:#999;font-size:13px'>Liên kết có hiệu lực trong <b>15 phút</b>.</p>"
                + "<hr style='border:none;border-top:1px solid #e0d8cc;margin:20px 0'>"
                + "<p style='color:#bbb;font-size:12px;text-align:center'>© Sweet Oven Bakery</p>"
                + "</div>";
        sendEmail(toEmail, "Đặt lại mật khẩu - Sweet Oven Bakery", html);
    }

    public static void sendOrderInvoice(String toEmail, Order order, List<CartItem> items, String ghnCode) throws Exception {
        sendEmail(toEmail, "Xác nhận đơn hàng #" + order.getOrderCode() + " - Sweet Oven Bakery", builInvoiceHtml(order, items, ghnCode));
    }

    private static String builInvoiceHtml(Order order, List<CartItem> items, String ghnCode) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;background:#fffdfb;border:1px solid #f0dece;border-radius:14px;overflow:hidden;'>")
                .append("<div style='background:#3C2F27;padding:32px 28px;text-align:center;'>")
                .append("<h1 style='color:#fff;margin:0;font-size:22px;'>Sweet Oven Bakery</h1>")
                .append("<p style='color:#D4A76A;margin:8px 0 0;font-size:14px;'>Xác nhận đặt hàng thành công</p></div>")
                .append("<div style='padding:28px;'>")
                .append("<p style='color:#3C2F27;'>Xin chào <strong>").append(escHtml(order.getFullName())).append("</strong>,</p>")
                .append("<p style='color:#555;'>Cảm ơn bạn đã đặt hàng!</p>")
                .append("<table style='width:100%;border-collapse:collapse;font-size:13px;margin-bottom:16px;'>")
                .append("<tr><td style='color:#85756b;padding:4px 0;'>Mã đơn hàng</td><td style='font-weight:700;color:#3C2F27;'>").append(escHtml(order.getOrderCode())).append("</td></tr>")
                .append("<tr><td style='color:#85756b;padding:4px 0;'>Địa chỉ</td><td>").append(escHtml(order.getAddress())).append("</td></tr>")
                .append("</table>")
                .append("<p style='font-weight:700;color:#3C2F27;'>Sản phẩm đã đặt:</p>")
                .append("<table style='width:100%;border-collapse:collapse;font-size:13px;'>");
        for (CartItem item : items) {
            BigDecimal lineTotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            sb.append("<tr style='border-bottom:1px solid #f7ede3;'>")
                    .append("<td style='padding:8px 4px;'>").append(escHtml(item.getProduct().getName())).append("</td>")
                    .append("<td style='text-align:center;'>x").append(item.getQuantity()).append("</td>")
                    .append("<td style='text-align:right;font-weight:600;color:#8B4513;'>").append(formatMoney(lineTotal)).append("</td></tr>");
        }
        sb.append("</table>")
                .append("<div style='border-top:2px solid #f0dece;padding-top:12px;text-align:right;'>")
                .append("<p style='font-weight:800;font-size:15px;color:#8B4513;'>TỔNG CỘNG: ").append(formatMoney(order.getTotalAmount())).append("</p>")
                .append("</div></div></div>");
        return sb.toString();
    }

    private static String formatMoney(BigDecimal value) {
        if (value == null) return "0 VNĐ";
        NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));
        return nf.format(value) + " VNĐ";
    }

    private static String escHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
}