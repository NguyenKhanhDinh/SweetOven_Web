package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import model.CartItem;
import model.Order;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
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

    public static void sendOrderInvoice(String toEmail, Order order, List<CartItem> items, String ghnCode) throws Exception {
        Session session = buildSession();
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL,"Sweet Oven Bakery"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject("Xác nhận đơn hàng #" + order.getOrderCode() + "- Sweet Oven Bakery");
        message.setContent(builInvoiceHtml(order,items,ghnCode),"text/html;charset=utf-8");
        Transport.send(message);
    }

    private static String builInvoiceHtml(Order order, List<CartItem> items, String ghnCode) {
        StringBuilder sb = new StringBuilder();
        sb.append("<div style= 'font-family:\"Helvetica Neue\",Arial,sans-serif;max-width:600px;margin:auto;")
                .append("background:#fffdfb; boder :1px soid #f0dece;border-radius:14px;overflow:hidden;')>")
                .append("<div style='background:linear-gradient(135deg,#3C2F27,#8B4513);padding:32px 28px;text-align:center;'>")
                .append("<h1 style='color:#fff;margin:0;font-size:22px;letter-spacing:1px;'>\uD83C\uDF82 Sweet Oven Bakery</h1>")
                .append("<p style='color:#D4A76A;margin:8px 0 0;font-size:14px;'>Xác nhận đặt hàng thành công</p>").append("</div>")
                .append("<div style='padding:28px 28px 0;'>")
                .append("<p style='color:#3C2F27;font-size:15px;margin:0 0 6px;'>Xin chào <strong>")
                .append(escHtml(order.getFullName())).append("</strong>,</p>")
                .append("<p style='color:#555;font-size:14px;line-height:1.6;margin:0 0 20px;'>")
                .append("Cảm ơn bạn đã đặt hàng tại Sweet Oven Bakery! ")
                .append("Dưới đây là thông tin đơn hàng của bạn.</p>")
                .append("<div style='background:#fdf5ee;border:1px solid #f0dece;border-radius:10px;")
                .append("padding:16px 18px;margin-bottom:20px;font-size:13px;'>")
                .append("<table style='width:100%;border-collapse:collapse;'>")
                .append("<tr><td style='color:#85756b;padding:4px 0;width:140px;'>Mã đơn hàng</td>")
                .append("<td style='font-weight:700;color:#3C2F27;'>\").append(escHtml(order.getOrderCode())).append(\"</td></tr>")
                .append("<tr><td style='color:#85756b;padding:4px 0;'>Địa chỉ giao</td>")
                .append("<td style='color:#3C2F27;'>\").append(escHtml(order.getAddress())).append(\"</td></tr>")
                .append("<tr><td style='color:#85756b;padding:4px 0;'>Số điện thoại</td>")
                .append("<td style='color:#3C2F27;'>\").append(escHtml(order.getPhoneNumber())).append(\"</td></tr>")
                .append("<tr><td style='color:#85756b;padding:4px 0;'>Thanh toán</td>")
                .append("<td style='color:#3C2F27;'>").append(order.getPaymentMethod() == 1 ? "Thanh toán khi nhận hàng (COD)" : order.getPaymentMethod() == 2 ? "Ví MoMo" : "VNPay").append("</td></tr>");
        if(ghnCode != null && !ghnCode.equals("")){
            sb.append("<tr><td style='color:#85756b;padding:4px 0;'>Mã vận đơn</td>").append("<td><a href='https://donhang.ghn.vn/?order_code=").append(escHtml(ghnCode))
                    .append("' style='color:#8B4513;font-weight:700;'>").append(" — Theo dõi đơn hàng →</a></td></tr>");
        }
        sb.append("</table></div>")
                .append("<p style='font-weight:700;color:#3C2F27;font-size:14px;margin:0 0 10px;'>")
                .append("\uD83D\uDCE6 Sản phẩm đã đặt</p>").append("<table style='width:100%;border-collapse:collapse;font-size:13px;margin-bottom:16px;'>")
                .append("<thead><tr style='border-bottom:2px solid #f0dece;'>")
                .append("<th style='text-align:left;padding:6px 4px;color:#85756b;font-weight:600;'>Sản phẩm</th>")
                .append("<th style='text-align:center;padding:6px 4px;color:#85756b;font-weight:600;'>SL</th>")
                .append("<th style='text-align:right;padding:6px 4px;color:#85756b;font-weight:600;'>Thành tiền</th>")
                .append("</tr></thead><tbody>");
        for (CartItem item : items){
            BigDecimal lineTotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            sb.append("<tr style='border-bottom:1px solid #f7ede3;'>").append("<td style='padding:8px 4px;color:#3C2F27;'>")
                    .append(escHtml(item.getProduct().getName() != null ? item.getProduct().getName() : "Sản phẩm")).append("</td>")
                    .append("<td style='text-align:center;padding:8px 4px;color:#555;'>x\").append(item.getQuantity()).append(\"</td>")
                    .append("<td style='text-align:right;padding:8px 4px;font-weight:600;color:#8B4513;'>")
                    .append(formatMoney(lineTotal)).append("</td>").append("</tr>");
        }
        sb.append("</tbody></table>").append("<div style='border-top:2px solid #f0dece;padding-top:12px;font-size:13px;'>")
                .append(summaryRow("Tạm tính", formatMoney(order.getSubTotal()), false))
                .append(summaryRow("Phí vận chuyển", formatMoney(order.getShippingFee()), false));
        if(order.getDiscountAmount() != null && order.getDiscountAmount().compareTo(BigDecimal.ZERO) >0){
            sb.append(summaryRow("Giảm giá","-" + formatMoney(order.getDiscountAmount()), false));
        }
        sb.append(summaryRow("TỔNG CỘNG",formatMoney(order.getTotalAmount()), true)).append("</div>")
                .append("<p style='font-size:12px;color:#aaa;margin:20px 0 0;line-height:1.6;'>")
                .append("Bạn sẽ được shipper liên hệ trước khi giao. Nếu cần hỗ trợ, vui lòng liên hệ fanpage hoặc")
                .append("reply email này.</p>").append("</div>").append("</div>");
        return sb.toString();
    }
    private static String summaryRow(String lable, String value, boolean isTotal){
        String style = isTotal ? "font-weight:800;font-size:15px;color:#8B4513;padding:8px 0;" : "font-weight:500;color:#555;padding:4px 0;";
        return "<div style='display:flex;justify-content:space-between;\" + style + \"'>"+"<span>" +escHtml(lable) +"</span>"
                +"<span>" + value + "</span>" + "</div>";
    }
    private static String formatMoney(BigDecimal value) {
        if (value == null) return "0 VNĐ";
        NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
        return nf.format(value) + "VNĐ";
    }
    private static String escHtml(String s) {
        if(s==null) return "";
        return s.replace("&","&amp;").replace("<","&lt;")
                .replace(">","&gt;").replace("\"","&quot;")
                .replace("'","&#39");
    }

}
