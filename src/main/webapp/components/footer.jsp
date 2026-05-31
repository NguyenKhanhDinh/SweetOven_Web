<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven Bakery - Footer</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${contextPath}/components/css/footer.css"/>
</head>
<body>

<!-- ════════════════════════════════════════════════════════════
     CTA BANNER — phía trên footer
     ════════════════════════════════════════════════════════════ -->
<section class="footer-cta">
    <div class="container">
        <div class="cta-inner">
            <div class="cta-text">
                <span class="cta-icon">
                    <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                    </svg>
                </span>
                <div class="cta-copy">
                    <span class="cta-eyebrow">Hỗ trợ khách hàng</span>
                    <strong>Cần tư vấn hoặc đặt bánh theo yêu cầu?</strong>
                    <span>Đội ngũ Sweet Oven luôn sẵn sàng lắng nghe bạn.</span>
                </div>
            </div>
            <a href="${contextPath}/contact" class="cta-btn">
                Liên hệ ngay
            </a>
        </div>
    </div>
</section>

<!-- ════════════════════════════════════════════════════════════
     FOOTER
     ════════════════════════════════════════════════════════════ -->
<footer class="footer">
    <div class="container">
        <div class="footer-cols">

            <!-- ── BRAND ─────────────────────────────────────── -->
            <div class="footer-brand">
                <div class="brand-wordmark">
                    <span class="brand-name">Sweet Oven</span>
                    <span class="brand-tagline">Bakery &amp; Handcrafted Goods</span>
                </div>
                <p class="brand-desc">
                    Tiệm bánh ngọt &amp; đồ nướng được làm thủ công mỗi ngày,
                    mang đến hương vị ngọt ngào và chân thật nhất.
                    Chúng tôi tin rằng hạnh phúc có thể bắt đầu từ một chiếc bánh ấm nóng vừa ra lò.
                </p>
                <div class="social-links">
                    <a href="#" class="facebook" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="instagram" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="youtube" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="tiktok" aria-label="TikTok"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>

            <!-- ── CONTACT ────────────────────────────────────── -->
            <div class="footer-col-contact">
                <h4 class="footer-section-title">Thông tin liên hệ</h4>
                <ul class="contact-list">
                    <li>
                        <span class="contact-icon-wrap"><i class="fas fa-map-marker-alt"></i></span>
                        <span class="contact-text">123 Đường Ngọt Ngào,<br>TP. Hồ Chí Minh</span>
                    </li>
                    <li>
                        <span class="contact-icon-wrap"><i class="fas fa-phone"></i></span>
                        <span class="contact-text">0909 123 456</span>
                    </li>
                    <li>
                        <span class="contact-icon-wrap"><i class="fas fa-envelope"></i></span>
                        <span class="contact-text">sweetovenbakery@gmail.com</span>
                    </li>
                </ul>
            </div>

            <!-- ── HOURS ──────────────────────────────────────── -->
            <div class="footer-col-hours">
                <h4 class="footer-section-title">Giờ mở cửa</h4>
                <ul class="hours-list">
                    <li>
                        <span class="hours-day">Thứ 2 – Thứ 6</span>
                        <span class="hours-time">07:00 – 21:00</span>
                    </li>
                    <li>
                        <span class="hours-day">Thứ 7 – CN</span>
                        <span class="hours-time">07:00 – 22:00</span>
                    </li>
                    <li>
                        <span class="hours-day">Giao hàng</span>
                        <span class="hours-time">07:00 – 20:00</span>
                    </li>
                </ul>
                <span class="hours-badge">
                    <span class="status-dot"></span>Đang mở cửa
                </span>
            </div>

        </div><!-- /.footer-cols -->

        <!-- ── BOTTOM BAR ─────────────────────────────────────── -->
        <div class="footer-bottom">
            <p class="copyright mb-0">&copy; 2026 Sweet Oven Bakery. All rights reserved.</p>
            <nav class="footer-legal">
                <a href="#">Chính sách bảo mật</a>
                <a href="#">Điều khoản sử dụng</a>
                <a href="#">Sitemap</a>
            </nav>
        </div>

    </div><!-- /.container -->
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
