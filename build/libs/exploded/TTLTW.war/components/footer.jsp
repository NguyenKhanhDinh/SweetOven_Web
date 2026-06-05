<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven Bakery - Footer</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
    />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
            rel="stylesheet"
    />

    <link rel="stylesheet" href="${contextPath}/components/css/footer.css"/>
</head>
<body>

<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4 mb-lg-0">
                <h4>Sweet Oven Bakery</h4>
                <p>Tiệm bánh ngọt & đồ nướng được làm thủ công mỗi ngày, mang đến hương vị ngọt ngào và chân thật nhất.
                    Chúng tôi tin rằng hạnh phúc có thể bắt đầu từ một chiếc bánh ấm nóng vừa ra lò.</p>
                <div class="social-links">
                    <a href="#" class="facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="youtube"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="tiktok"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <h4>Thông tin liên hệ</h4>
                <p><i class="fas fa-map-marker-alt me-2"></i> 123 Đường Ngọt Ngào, TP. Hồ Chí Minh</p>
                <p><i class="fas fa-phone me-2"></i> 0909 123 456</p>
                <p><i class="fas fa-envelope me-2"></i> sweetovenbakery@gmail.com</p>
            </div>

            <div class="col-lg-3 col-md-6">
                <h4>Giờ mở cửa</h4>
                <p>Thứ 2 - Thứ 6: 7:00 - 21:00</p>
                <p>Thứ 7 - Chủ nhật: 7:00 - 22:00</p>
                <p>Phục vụ giao hàng tận nơi từ 7:00 - 20:00</p>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 Sweet Oven Bakery. All rights reserved.</p>
        </div>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>