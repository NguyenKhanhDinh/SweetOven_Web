<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sweet Oven Bakery - Bánh ngọt & Đồ nướng</title>
    <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        :root {
            --primary: #8B4513;
            --secondary: #D4A76A;
            --light: #FFF9F0;
            --shadow: 0 10px 30px rgba(0,0,0,0.08);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Quicksand', sans-serif;
            color: #333;
            line-height: 1.6;
            padding-top: 0;
        }

        .hero-carousel {
            min-height: 90vh;
            position: relative;
        }

        .carousel-item {
            min-height: 90vh;
            background-size: cover;
            background-position: center;
            position: relative;
        }

        .carousel-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4));
        }

        .carousel-content {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            transform: translateY(-50%);
            color: white;
            text-align: center;
            z-index: 2;
        }

        .carousel-content h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: white;
            line-height: 1.2;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
        }

        .carousel-content p {
            font-size: 1.2rem;
            margin-bottom: 2.5rem;
            line-height: 1.7;
            font-weight: 400;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.5);
        }

        .btn-primary-custom {
            background: #8B4513;
            color: white;
            border: none;
            padding: 0.8rem 2.5rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: var(--transition);
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.3);
            text-decoration: none;
        }

        .btn-primary-custom:hover {
            background: var(--secondary);
            color:#8B4513;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(139, 69, 19, 0.4);
        }

        .carousel-control-prev,
        .carousel-control-next {
            display: none;
        }
        .carousel-content .btn-primary-custom {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 1rem 3rem;
            font-size: 1.2rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.2);
            border-radius: 50px;
        }
        .carousel-content .btn-primary-custom:hover {
            background: white;
            color: var(--primary);
            border-color: white;
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.4);
        }

        .carousel-indicators {
            bottom: 2rem;
        }

        .carousel-indicators button {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin: 0 8px;
            border: 2px solid white;
            background: transparent;
            transition: var(--transition);
        }

        .carousel-indicators button.active {
            background: white;
            transform: scale(1.2);
        }

        .section-title {
            text-align: center;
            margin-bottom: 4rem;
            position: relative;
        }

        .section-title h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: inline-block;
        }

        .section-title h2::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: var(--secondary);
            border-radius: 2px;
        }

        .section-title p {
            font-size: 1.1rem;
            max-width: 600px;
            margin: 2rem auto 0;
            color:#8B4513;
            font-weight: 400;
        }

        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: var(--transition);
            height: 450px;
            position: relative;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(139, 69, 19, 0.1);
            cursor: pointer;
        }

        .product-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .product-img {
            height: 220px;
            overflow: hidden;
            position: relative;
            flex-shrink: 0;
        }

        .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }

        .product-card:hover .product-img img {
            transform: scale(1.08);
        }

        .product-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #FF6B6B;
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
            box-shadow: 0 3px 10px rgba(212, 167, 106, 0.3);
            z-index: 2;
        }

        .product-content {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            justify-content: space-between;
            position: relative;
        }

        .product-card:hover .product-content::before {
            transform: scaleX(1);
        }

        .product-content h3 {
            font-size: 1.3rem;
            margin-bottom: 0.8rem;
            font-weight: 600;
            color:#8B4513;
            transition: var(--transition);
            display: -webkit-box;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.4;
            min-height: 2.8rem;
        }

        .product-card:hover h3 {
            color: var(--secondary);
        }

        .product-price {
            font-size: 1.4rem;
            font-weight: 700;
            color: #8B4513;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .product-price::before {
            content: '•';
            color: var(--secondary);
            font-size: 1.8rem;
        }

        .btn-add-to-cart {
            background: linear-gradient(135deg, var(--primary), #A0522D);
            color: white;
            border: none;
            width: 100%;
            padding: 0.8rem;
            border-radius: 12px;
            font-weight: 600;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.2);
        }

        .btn-add-to-cart:hover {
            background: linear-gradient(135deg, var(--secondary), #E6B17E);
            color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 19, 0.3);
        }

        .btn-add-to-cart i {
            transition: var(--transition);
        }

        .btn-add-to-cart:hover i {
            transform: translateX(3px);
        }

        .promotions-section {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 5rem 0;
            color: white;
            overflow: hidden;
        }

        .promo-row-scroll {
            display: flex;
            flex-wrap: nowrap;
            overflow-x: auto;
            gap: 1.5rem;
            padding: 1rem 0.5rem 2rem;
            scrollbar-width: thin;
            scrollbar-color: var(--secondary) transparent;
            -webkit-overflow-scrolling: touch;
        }

        .promo-row-scroll::-webkit-scrollbar {
            height: 6px;
        }

        .promo-row-scroll::-webkit-scrollbar-thumb {
            background: var(--secondary);
            border-radius: 10px;
        }

        .promo-item {
            flex: 0 0 calc(25% - 1.2rem);
            min-width: 280px;
            display: flex;
        }

        .promo-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            transition: var(--transition);
            height: 100%;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .promo-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.15);
        }

        .promo-icon {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            color: var(--light);
        }

        .promo-code {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 10px;
            font-weight: 600;
            margin: 1rem 0;
            display: inline-block;
            border: 1px dashed rgba(255, 255, 255, 0.5);
            font-size: 1.2rem;
            letter-spacing: 1px;
        }

        .promo-card h4 {
            color: white;
            font-weight: 600;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .promo-discount {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--light);
            margin-bottom: 0.5rem;
        }

        .promo-condition {
            font-size: 0.9rem;
            opacity: 0.9;
            margin-top: 0.5rem;
        }

        .categories-section {
            background: linear-gradient(135deg, var(--light) 0%, #fdf6e3 100%);
            padding: 6rem 0;
            position: relative;
            overflow: hidden;
        }

        .categories-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" fill="%23D4A76A" opacity="0.03"><path d="M30,30 Q50,10 70,30 T90,30 T70,50 T90,70 T70,90 T50,70 T30,90 T10,70 T30,50 T10,30 T30,30 Z"/></svg>');
            background-size: 200px;
            animation: float 20s infinite linear;
        }

        @keyframes float {
            0% { transform: translateX(0) translateY(0); }
            100% { transform: translateX(-200px) translateY(-200px); }
        }

        .category-row-scroll {
            display: flex;
            flex-wrap: nowrap;
            overflow-x: auto;
            gap: 1.5rem;
            padding: 1rem 0.5rem 2rem;
            scrollbar-width: thin;
            scrollbar-color: var(--secondary) transparent;
            -webkit-overflow-scrolling: touch;
        }

        .category-row-scroll::-webkit-scrollbar {
            height: 6px;
        }

        .category-row-scroll::-webkit-scrollbar-thumb {
            background: var(--secondary);
            border-radius: 10px;
        }

        .category-scroll-item {
            flex: 0 0 calc(25% - 1.2rem);
            min-width: 280px;
            display: flex;
        }

        .category-card {
            height: 350px;
            border-radius: 25px;
            overflow: hidden;
            position: relative;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 2px solid transparent;
            width: 100%;
        }

        .category-card:hover {
            transform: translateY(-15px) scale(1.02);
            box-shadow: 0 25px 50px rgba(139, 69, 19, 0.2);
            border-color: var(--secondary);
        }

        .category-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg,
            rgba(139, 69, 19, 0.1) 0%,
            rgba(212, 167, 106, 0.2) 50%,
            rgba(139, 69, 19, 0.4) 100%);
            z-index: 1;
            transition: var(--transition);
        }

        .category-card:hover::before {
            background: linear-gradient(135deg,
            rgba(139, 69, 19, 0.2) 0%,
            rgba(212, 167, 106, 0.3) 50%,
            rgba(139, 69, 19, 0.6) 100%);
        }

        .category-bg {
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            transition: var(--transition);
            position: relative;
        }

        .category-card:hover .category-bg {
            transform: scale(1.1);
        }

        .category-content {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            padding: 2.5rem 2rem;
            z-index: 2;
            color: white;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            transform: translateY(0);
            transition: var(--transition);
        }

        .category-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--secondary);
            transition: var(--transition);
            display: inline-block;
        }

        .category-card:hover .category-icon {
            transform: scale(1.2) rotate(5deg);
            color: white;
        }

        .category-content h3 {
            font-size: 1.8rem;
            margin-bottom: 0.8rem;
            color: white;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        .category-content p {
            margin-bottom: 1.5rem;
            opacity: 0.9;
            font-weight: 400;
            line-height: 1.6;
            font-size: 1rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }

        .btn-category {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: blur(10px);
        }

        .btn-category:hover {
            background: white;
            color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,255,255,0.3);
        }

        .btn-category i {
            transition: var(--transition);
        }

        .btn-category:hover i {
            transform: translateX(5px);
        }

        .review-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
            height: 100%;
            position: relative;
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .review-card::before {
            content: '"';
            position: absolute;
            top: 10px;
            left: 20px;
            font-size: 5rem;
            color: var(--secondary);
            opacity: 0.2;
            font-family: Georgia, serif;
            line-height: 1;
        }

        .customer-info {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .customer-avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 1rem;
            border: 3px solid var(--secondary);
        }

        .customer-details h5 {
            margin-bottom: 0.3rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary);
        }

        .customer-details p {
            color: var(--primary);
            font-size: 0.9rem;
            margin-bottom: 0;
            font-weight: 400;
        }

        .rating {
            color: var(--secondary);
            margin-bottom: 1rem;
        }

        .review-text {
            font-style: italic;
            line-height: 1.7;
            color: var(--primary);
            font-weight: 400;
        }

        .statistics-section {
            background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), url('https://images.unsplash.com/photo-1558961363-fa8fdf82db35?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            padding: 5rem 0;
            color: white;
            text-align: center;
        }

        .statistics-item {
            margin-bottom: 2rem;
        }

        .statistics-number {
            font-size: 3.5rem;
            font-weight: 700;
            color: var(--secondary);
            margin-bottom: 0.5rem;
            display: block;
        }

        .statistics-text {
            font-size: 1.3rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        @media (max-width: 768px) {
            .hero-carousel {
                min-height: 70vh;
            }

            .carousel-item {
                min-height: 70vh;
            }

            .carousel-content h1 {
                font-size: 2.5rem;
            }

            .section-title h2 {
                font-size: 2rem;
            }

            .product-card {
                height: 400px;
            }

            .category-grid {
                display: none;
            }

            .category-scroll-item {
                flex: 0 0 85%;
                min-width: 260px;
            }

            .category-card {
                height: 300px;
            }

            .category-content {
                padding: 2rem 1.5rem;
            }

            .category-content h3 {
                font-size: 1.5rem;
            }

            .statistics-number {
                font-size: 2.5rem;
            }

            .statistics-text {
                font-size: 1.1rem;
            }
        }

        @media (max-width: 480px) {
            .category-card {
                height: 250px;
            }

            .category-content {
                padding: 1.5rem 1rem;
            }

            .category-content h3 {
                font-size: 1.3rem;
            }

            .category-content p {
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            .carousel-content h1 {
                font-size: 2rem;
            }

            .carousel-content p {
                font-size: 1rem;
            }
        }

        /* ===== FIX HERO BANNER ===== */
        #heroCarousel,
        #heroCarousel .carousel-item {
            height: 90vh;
        }

        #heroCarousel .carousel-item {
            background-size: cover;
            background-position: center;
            position: relative;
        }

        #heroCarousel .carousel-item::before {
            content: "";
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 1;
        }

        .carousel-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            max-width: 600px;
            width: 100%;
            color: #fff;
            text-align: center;
            z-index: 2;
        }

        .carousel-content h1 {
            font-size: 3.2rem;
            font-weight: 700;
        }

        .carousel-content p {
            font-size: 1.2rem;
            margin: 1rem 0 2rem;
        }

        @media (max-width: 768px) {
            .carousel-content {
                left: 5%;
                right: 5%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<jsp:include page="components/header.jsp" />

<main>
    <div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel">
        <div class="carousel-inner">
            <c:forEach var="b" items="${banners}" varStatus="st">
                <div class="carousel-item ${st.first ? 'active' : ''}"
                     style="background-image: url('${b.imageUrl}')">
                    <div class="carousel-content">
                        <h1>${b.title}</h1>
                        <p>${b.description}</p>
                        <a href="menu" class="btn btn-primary-custom">
                            Khám phá ngay
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <section class="py-5 my-5">
        <div class="container">
            <div class="section-title">
                <h2>Sản Phẩm Nổi Bật</h2>
                <p>Những chiếc bánh được yêu thích nhất tại Sweet Oven Bakery</p>
            </div>

            <div class="row g-4">
                <c:forEach var="p" items="${featuredProducts}">
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="product-card">
                            <c:if test="${p.stockQuantity <= 0}">
                                <div class="product-badge">Hết hàng</div>
                            </c:if>
                            <div class="product-img" onclick="goToProductDetail(${p.id})">
                                <img src="${p.image}" alt="${p.name}">
                            </div>
                            <div class="product-content">
                                <h3>${p.name}</h3>
                                <div class="product-price">
                                    <fmt:formatNumber value="${p.price}" type="number" /> VNĐ
                                </div>
                                <form method="get" action="${pageContext.request.contextPath}/add-cart"
                                      onclick="event.stopPropagation();">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <input type="hidden" name="quantity" value="1">
                                    <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/">
                                    <button type="submit" class="btn-add-to-cart" ${p.stockQuantity <=0 ? 'disabled' : '' }>
                                        <c:choose>
                                            <c:when test="${p.stockQuantity <= 0}">Hết hàng</c:when>
                                            <c:otherwise>Thêm vào giỏ</c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="text-center mt-5">
                <a href="menu" class="btn btn-primary-custom">Xem tất cả sản phẩm</a>
            </div>
        </div>
    </section>

    <section id="promotions" class="promotions-section">
        <div class="container">
            <div class="section-title">
                <h2>Mã Giảm Giá</h2>
                <p>Lưu ngay các mã giảm giá hấp dẫn cho đơn hàng của bạn</p>
            </div>

            <div class="promo-row-scroll">
                <c:forEach var="d" items="${discounts}">
                    <div class="promo-item">
                        <div class="promo-card w-100">
                            <div class="promo-icon">
                                <i class="fas ${d.discountType ? 'fa-percentage' : 'fa-hand-holding-usd'}"></i>
                            </div>
                            <div class="promo-discount">
                                <c:choose>
                                    <c:when test="${d.discountType == true}">
                                        <fmt:formatNumber value="${d.value}" maxFractionDigits="0" />%
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${d.value}" type="number" groupingUsed="true"
                                                          maxFractionDigits="0" />VNĐ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h4>
                                <c:choose>
                                    <c:when test="${d.discountType == true}">Ưu Đãi Đặc Biệt</c:when>
                                    <c:otherwise>Giảm Trực Tiếp</c:otherwise>
                                </c:choose>
                            </h4>
                            <p>Cho đơn hàng từ
                                <fmt:formatNumber value="${d.minValueOrder}" type="number" groupingUsed="true"
                                                  maxFractionDigits="0" />đ
                            </p>
                            <div class="promo-code">${d.code}</div>
                            <p class="promo-condition">${d.description}</p>
                            <p class="promo-condition">
                                HSD:
                                <fmt:formatDate value="${d.endDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty discounts}">
                    <div class="col-12 text-center text-white">
                        <p>Hiện tại chưa có mã giảm giá nào hấp dẫn. Hãy quay lại sau nhé!</p>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <section class="categories-section">
        <div class="container">
            <div class="section-title">
                <h2>Danh Mục Sản Phẩm</h2>
                <p>Khám phá đa dạng các loại bánh và đồ nướng tại Sweet Oven</p>
            </div>
            <div class="category-row-scroll">
                <c:forEach var="c" items="${categories}">
                    <div class="category-scroll-item">
                        <div class="category-card">
                            <div class="category-bg"
                                 style="background-image: url('${not empty c.thumbnail ? c.thumbnail : 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-4.0.3&auto=format&fit=crop&w=1089&q=80'}');">
                            </div>
                            <div class="category-content">
                                <i class="fas fa-cookie category-icon"></i>
                                <h3>${c.name}</h3>
                                <p>${c.description}</p>
                                <a href="menu?categoryId=${c.id}" class="btn btn-category">
                                    Khám phá ngay
                                    <i class="fas fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="text-center mt-5">
                <a href="menu" class="btn btn-primary-custom">
                    <i class="fas fa-store me-2"></i>
                    Xem Tất Cả Sản Phẩm
                </a>
            </div>
        </div>
    </section>

    <section class="py-5 my-5">
        <div class="container">
            <div class="section-title">
                <h2>Đánh Giá Từ Khách Hàng</h2>
                <p>Những phản hồi chân thành là động lực để chúng tôi hoàn thiện hơn mỗi ngày</p>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="review-card">
                        <div class="customer-info">
                            <img src="https://i.pravatar.cc/150?img=32" alt="Khách hàng" class="customer-avatar">
                            <div class="customer-details">
                                <h5>Chị Mai Anh</h5>
                                <p>Đã mua hàng 5 lần</p>
                            </div>
                        </div>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="review-text">
                            Bánh ở đây ngon tuyệt! Đặc biệt là bánh tiramisu, mềm mịn và không quá ngọt. Giao hàng nhanh, đóng gói cẩn thận. Mình sẽ ủng hộ dài lâu!
                        </p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="review-card">
                        <div class="customer-info">
                            <img src="https://i.pravatar.cc/150?img=12" alt="Khách hàng" class="customer-avatar">
                            <div class="customer-details">
                                <h5>Anh Tuấn Minh</h5>
                                <p>Đã mua hàng 3 lần</p>
                            </div>
                        </div>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                        <p class="review-text">
                            Mình rất ấn tượng với bánh mì nguyên cám ở đây. Thơm ngon, bổ dưỡng và giá cả hợp lý. Nhân viên tư vấn nhiệt tình, giao hàng đúng hẹn.
                        </p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-4">
                    <div class="review-card">
                        <div class="customer-info">
                            <img src="https://i.pravatar.cc/150?img=44" alt="Khách hàng" class="customer-avatar">
                            <div class="customer-details">
                                <h5>Chị Hương Giang</h5>
                                <p>Đã mua hàng 8 lần</p>
                            </div>
                        </div>
                        <div class="rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </div>
                        <p class="review-text">
                            Bánh croissant giòn tan, bơ thơm đúng chuẩn Pháp. Mình rất thích nhưng mong cửa hàng có thêm nhiều lựa chọn không đường cho người ăn kiêng.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="statistics-section">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="statistics-item">
                        <span class="statistics-number">+120</span>
                        <div class="statistics-text">LOẠI BÁNH</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="statistics-item">
                        <span class="statistics-number">+1000</span>
                        <div class="statistics-text">KHÁCH HÀNG MỖI NGÀY</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="statistics-item">
                        <span class="statistics-number">+4</span>
                        <div class="statistics-text">NĂM KINH NGHIỆM</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="components/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function goToProductDetail(productId) {
        sessionStorage.setItem('selectedProductId', productId);
        window.location.href = 'product?id=' + productId;
    }
</script>

</body>
</html>