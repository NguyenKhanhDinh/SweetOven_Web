<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Liên hệ | Sweet Oven</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        .contact-page {
            font-family: 'Quicksand', sans-serif;
            --primary:#8B4513;
            --secondary:#D4A76A;
            --light:#FFF9F0;
        }

        .contact-page .hero {
            padding:120px 20px 60px;
            text-align:center;
            background:linear-gradient(135deg,var(--light),#f5e6c6);
        }

        .contact-page .hero h1 {
            font-size:2.8rem;
            font-weight:700;
            color:var(--primary);
        }

        .contact-page .hero p {
            color:#6b4f2d;
        }

        .contact-page .wrapper {
            max-width:1200px;
            margin:auto;
            padding:40px 20px;
        }

        .contact-page .grid {
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:30px;
        }

        .contact-page .card {
            background:white;
            padding:30px;
            border-radius:20px;
            box-shadow:0 10px 25px rgba(0,0,0,0.08);
        }

        .contact-page h3 {
            color:var(--primary);
            font-weight:700;
            margin-bottom:20px;
        }

        .contact-page input,
        .contact-page textarea {
            width:100%;
            padding:12px;
            border-radius:10px;
            border:1px solid #ddd;
            margin-bottom:15px;
        }

        .contact-page button {
            background:var(--secondary);
            border:none;
            padding:12px;
            border-radius:25px;
            width:100%;
            font-weight:600;
        }

        .contact-page button:hover {
            background:#c89555;
        }

        .contact-page iframe {
            width:100%;
            border-radius:15px;
            height:250px;
            border:none;
        }

        @media(max-width:768px){
            .contact-page .grid {
                grid-template-columns:1fr;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="contact"/>
</jsp:include>

<div class="contact-page">

    <section class="hero">
        <h1>Liên hệ với chúng tôi</h1>
        <p>Sweet Oven luôn sẵn sàng hỗ trợ bạn 💛</p>
    </section>

    <div class="wrapper">
        <div class="grid">

            <!-- LEFT -->
            <div>
                <div class="card info">
                    <h3>Thông tin</h3>
                    <p><i class="fa fa-location-dot"></i> 123 Đường Ngọt Ngào, TP.HCM</p>
                    <p><i class="fa fa-phone"></i> 0909 123 456</p>
                    <p><i class="fa fa-envelope"></i> sweetoven@gmail.com</p>
                </div>

                <div class="card mt-4">
                    <h3>Bản đồ</h3>
                    <iframe src="https://www.google.com/maps?q=Ho+Chi+Minh&output=embed"></iframe>
                </div>
            </div>

            <!-- RIGHT -->
            <div class="card">
                <h3>Gửi tin nhắn</h3>

                <!-- THÔNG BÁO -->
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success">
                            ${sessionScope.successMsg}
                    </div>
                    <c:remove var="successMsg" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMsg}">
                    <div class="alert alert-danger">
                            ${sessionScope.errorMsg}
                    </div>
                    <c:remove var="errorMsg" scope="session"/>
                </c:if>

                <form action="${pageContext.request.contextPath}/contact" method="post">

                    <input type="text" name="fullName" placeholder="Họ và tên" required>

                    <input type="email" name="email" placeholder="Email" required>

                    <input type="text" name="phoneNumber" placeholder="Số điện thoại">

                    <textarea name="content" placeholder="Nội dung" required></textarea>

                    <button type="submit">Gửi liên hệ</button>
                </form>

            </div>

        </div>
    </div>

</div>

<jsp:include page="/components/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>