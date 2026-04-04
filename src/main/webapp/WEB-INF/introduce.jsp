<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu | Sweet Oven</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        .introduce-page {
            font-family:'Quicksand',sans-serif;
        }

        .introduce-page {
            --primary:#8B4513;
            --secondary:#D4A76A;
            --light:#FFF9F0;
            --dark:#2c1a0d;
        }

        /* HERO */
        .introduce-page .slogan {
            text-align:center;
            padding:140px 20px 90px;
            background:linear-gradient(135deg,var(--light),#f5e6c6);
        }

        .introduce-page .slogan h1 {
            font-size:3rem;
            font-weight:700;
            color:var(--primary);
        }

        .introduce-page .btn-main {
            background:var(--secondary);
            border:none;
            padding:10px 25px;
            border-radius:30px;
            margin-top:20px;
        }

        /* SECTION */
        .introduce-page .section {
            padding:80px 0;
        }

        .introduce-page .section-title {
            text-align:center;
            margin-bottom:40px;
        }

        .introduce-page .section-title h2 {
            color:var(--primary);
            font-weight:700;
        }

        /* FLEX */
        .introduce-page .about-flex {
            display:flex;
            gap:40px;
            align-items:center;
            flex-wrap:wrap;
        }

        .introduce-page .about-flex img {
            max-width:500px;
            width:100%;
            border-radius:20px;
        }

        .introduce-page .about-text {
            flex:1;
        }

        /* WHY */
        .introduce-page .why-box {
            text-align:center;
            padding:20px;
        }

        .introduce-page .why-box i {
            font-size:30px;
            color:var(--secondary);
        }

        /* MISSION */
        .introduce-page .about-mission {
            background:url('https://images.unsplash.com/photo-1556909114-4d0d853e5e25') center/cover;
            position:relative;
            color:white;
        }

        .introduce-page .about-mission::before {
            content:"";
            position:absolute;
            inset:0;
            background:rgba(139,69,19,0.7);
        }

        .introduce-page .mission-container {
            position:relative;
            display:flex;
            gap:20px;
            flex-wrap:wrap;
            justify-content:center;
        }

        .introduce-page .mission-box {
            background:white;
            color:var(--primary);
            padding:25px;
            border-radius:15px;
            width:280px;
            text-align:center;
        }

        /* TEAM */
        .introduce-page .team-member {
            text-align:center;
            padding:20px;
            border-radius:15px;
            background:white;
        }

        .introduce-page .team-member img {
            width:140px;
            height:140px;
            border-radius:50%;
            border:3px solid var(--secondary);
        }
    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="introduce"/>
</jsp:include>

<!-- WRAPPER FIX -->
<div class="introduce-page">

    <!-- HERO -->
    <section class="slogan">
        <h1>NƯỚNG VỊ HẠNH PHÚC</h1>
        <p>Thưởng thức bánh, đồ nướng ngon mỗi ngày</p>
        <a href="menu" class="btn btn-main">Khám phá sản phẩm</a>
    </section>

    <!-- INTRO -->
    <section class="section">
        <div class="container">

            <div class="about-flex mb-5">
                <img src="https://cdn.tgdd.vn/2020/08/CookProduct/cn-1200x676-5.jpg">
                <div class="about-text">
                    <h2>Sweet Oven Bakery</h2>
                    <p>Tiệm bánh, đồ nướng thủ công với nguyên liệu tự nhiên, mang đến hương vị chân thật nhất.</p>
                    <ul>
                        <li>✔ Làm mỗi ngày</li>
                        <li>✔ Không chất bảo quản</li>
                        <li>✔ Hương vị nguyên bản</li>
                    </ul>
                </div>
            </div>

            <div class="about-flex">
                <div class="about-text">
                    <h2>Đam mê trong từng chiếc bánh</h2>
                    <p>Mỗi sản phẩm là sự kết hợp giữa sáng tạo và tâm huyết.</p>
                </div>
                <img src="https://images.unsplash.com/photo-1745917261044-7ce73d9b95c6">
            </div>

        </div>
    </section>

    <!-- WHY -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title"><h2>Tại sao chọn chúng tôi?</h2></div>

            <div class="row">
                <div class="col-md-4 why-box">
                    <i class="fa fa-leaf"></i>
                    <p>Nguyên liệu sạch</p>
                </div>

                <div class="col-md-4 why-box">
                    <i class="fa fa-clock"></i>
                    <p>Tươi mỗi ngày</p>
                </div>

                <div class="col-md-4 why-box">
                    <i class="fa fa-star"></i>
                    <p>Chất lượng cao</p>
                </div>
            </div>

        </div>
    </section>

    <!-- MISSION -->
    <section class="section about-mission">
        <div class="container text-center">
            <h2>Sứ mệnh</h2>

            <div class="mission-container">
                <div class="mission-box">
                    <i class="fa fa-heart"></i>
                    <h3>Sứ mệnh</h3>
                    <p>Mang đến niềm vui qua từng chiếc bánh</p>
                </div>

                <div class="mission-box">
                    <i class="fa fa-eye"></i>
                    <h3>Tầm nhìn</h3>
                    <p>Trở thành thương hiệu được yêu thích</p>
                </div>

                <div class="mission-box">
                    <i class="fa fa-star"></i>
                    <h3>Giá trị</h3>
                    <p>Chất lượng – Tận tâm – Sáng tạo</p>
                </div>
            </div>

        </div>
    </section>

    <!-- TEAM -->
    <section class="section">
        <div class="container text-center">

            <div class="section-title"><h2>Đội ngũ</h2></div>

            <div class="row">
                <div class="col-md-4">
                    <div class="team-member">
                        <img src="https://images.unsplash.com/photo-1583394293214-28ded15ee548">
                        <h5>Nguyễn Khánh Dinh</h5>
                        <span class="badge bg-warning text-dark">Head Chef</span>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="team-member">
                        <img src="https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf">
                        <h5>Đoàn Huy Cương</h5>
                        <span class="badge bg-warning text-dark">Baker</span>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="team-member">
                        <img src="https://images.unsplash.com/photo-1566554273541-37a9ca77b91f">
                        <h5>Bùi Ánh Hậu</h5>
                        <span class="badge bg-warning text-dark">Decorator</span>
                    </div>
                </div>
            </div>

        </div>
    </section>

</div>

<!-- FOOTER -->
<jsp:include page="/components/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>