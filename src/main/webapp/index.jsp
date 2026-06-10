<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sweet Oven Bakery - Bánh ngọt & Đồ nướng</title>
    <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery"/>
    <meta name="contextPath" content="${pageContext.request.contextPath}">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<%@ include file="/components/header.jsp" %>

<main>
    <!-- ═══════════════════════════════════════════════════════
         HERO BANNER — compact, elegant, text-left
    ════════════════════════════════════════════════════════ -->
    <div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel" data-bs-interval="5000">

        <div class="carousel-inner">
            <c:forEach var="b" items="${banners}" varStatus="st">
                <div class="carousel-item ${st.first ? 'active' : ''}"
                     style="background-image: url('${pageContext.request.contextPath}${b.imageUrl}')">
                    <div class="hero-overlay"></div>
                    <div class="hero-content">
                        <span class="hero-label">Sweet Oven Bakery</span>
                        <h1 class="hero-title">${b.title}</h1>
                        <p class="hero-desc">${b.description}</p>
                        <div class="hero-actions">
                            <a href="${pageContext.request.contextPath}/menu" class="btn-hero-primary">
                                Khám phá ngay
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Custom pill indicators -->
        <div class="hero-indicators">
            <c:forEach var="b" items="${banners}" varStatus="st">
                <button type="button"
                        data-bs-target="#heroCarousel"
                        data-bs-slide-to="${st.index}"
                        class="${st.first ? 'active' : ''}"
                        aria-current="${st.first ? 'true' : 'false'}">
                </button>
            </c:forEach>
        </div>

        <!-- Prev / Next -->
        <button class="hero-nav hero-nav-prev" type="button"
                data-bs-target="#heroCarousel" data-bs-slide="prev">
            <i class="fas fa-chevron-left"></i>
        </button>
        <button class="hero-nav hero-nav-next" type="button"
                data-bs-target="#heroCarousel" data-bs-slide="next">
            <i class="fas fa-chevron-right"></i>
        </button>
    </div>


    <!-- ═══════════════════════════════════════════════════════
         FEATURED PRODUCTS
    ════════════════════════════════════════════════════════ -->
    <section class="featured-section">

        <%-- Họa tiết nền SVG --%>
        <div class="featured-bg-pattern" aria-hidden="true">
            <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
                <defs>
                    <pattern id="bakery-pattern" x="0" y="0" width="120" height="120" patternUnits="userSpaceOnUse">
                        <%-- Bông lúa mì --%>
                        <ellipse cx="20" cy="18" rx="3.5" ry="6" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.18" transform="rotate(-20 20 18)"/>
                        <ellipse cx="26" cy="14" rx="3" ry="5.5" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.18" transform="rotate(-35 26 14)"/>
                        <line x1="22" y1="22" x2="22" y2="36" stroke="#C9A96E" stroke-width="1" opacity="0.15"/>
                        <%-- Cây phết bột --%>
                        <rect x="72" y="60" width="4" height="18" rx="2" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.14" transform="rotate(30 74 69)"/>
                        <ellipse cx="74" cy="58" rx="5" ry="3" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.14" transform="rotate(30 74 58)"/>
                        <%-- Chiếc bánh nhỏ --%>
                        <ellipse cx="95" cy="20" rx="10" ry="6" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.13"/>
                        <path d="M85 20 Q95 12 105 20" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.13"/>
                        <%-- Ngôi sao nhỏ --%>
                        <circle cx="50" cy="90" r="1.5" fill="#C9A96E" opacity="0.15"/>
                        <circle cx="10" cy="75" r="1" fill="#C9A96E" opacity="0.12"/>
                        <circle cx="110" cy="100" r="1.5" fill="#C9A96E" opacity="0.13"/>
                    </pattern>
                </defs>
                <rect width="100%" height="100%" fill="url(#bakery-pattern)"/>
            </svg>
        </div>

        <div class="container featured-inner">

            <%-- Tiêu đề editorial: trái + phải --%>
            <div class="featured-header">
                <div class="featured-header-left">
                    <div class="featured-eyebrow">
                        <span class="featured-eyebrow-line"></span>
                        <span>Sweet Oven Bakery</span>
                    </div>
                    <h2 class="featured-title">SẢN PHẨM<br>NỔI BẬT</h2>
                </div>
                <div class="featured-header-right">
                    <p class="featured-subtitle">Những chiếc bánh được yêu thích nhất —<br>tươi mới từng buổi sáng, làm thủ công<br>từ nguyên liệu chất lượng.</p>
                    <span class="featured-header-divider"></span>
                </div>
            </div>

            <div class="products-grid">
                <c:forEach var="p" items="${featuredProducts}">
                    <div class="product-card"
                         onclick="location.href='${pageContext.request.contextPath}/product?id=${p.id}'">

                        <c:if test="${p.stockQuantity <= 0}">
                            <div class="product-badge">Hết hàng</div>
                        </c:if>
                        <c:if test="${p.discountPrice != null && p.discountPrice > 0}">
                            <div class="product-badge product-badge-sale">Sale</div>
                        </c:if>

                        <div class="product-img">
                            <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                <img src="${p.image}" alt="${p.name}"
                                     onerror="this.src='https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&q=80'">
                            </a>
                            <button type="button"
                                    class="btn-favorite ${not empty favoriteProductIds and favoriteProductIds.contains(p.id) ? 'active' : ''}"
                                    data-product-id="${p.id}"
                                    onclick="event.stopPropagation(); toggleFavorite(this, ${p.id});"
                                    title="Thêm vào yêu thích">
                                <i class="fas fa-heart"></i>
                            </button>
                        </div>

                        <div class="product-content">
                            <h3>${p.name}</h3>

                            <div class="product-price">
                                <c:choose>
                                    <c:when test="${p.discountPrice != null && p.discountPrice > 0}">
                                        <span class="price-original">
                                            <fmt:formatNumber value="${p.originalPrice}" type="number"/> VNĐ
                                        </span>
                                        <span class="price-sale">
                                            <fmt:formatNumber value="${p.discountPrice}" type="number"/> VNĐ
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price-normal">
                                            <fmt:formatNumber value="${p.originalPrice}" type="number"/> VNĐ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <button type="button"
                                    class="btn-add-to-cart"
                                    data-product-id="${p.id}"
                                    onclick="event.stopPropagation();"
                                ${p.stockQuantity <= 0 ? 'disabled' : ''}>
                                <c:choose>
                                    <c:when test="${p.stockQuantity <= 0}">
                                        <i class="fas fa-ban"></i> Hết hàng
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <%-- Nút xem thêm --%>
            <div class="featured-footer">
                <p class="featured-slogan">Mang hương vị ngọt ngào đến từng khoảnh khắc.</p>
                <a href="${pageContext.request.contextPath}/menu" class="btn-featured-all">
                    Xem Tất Cả Sản Phẩm
                </a>
            </div>

        </div>
    </section>


    <!-- ═══════════════════════════════════════════════════════
         CATEGORIES — Masonry editorial, image-first
    ════════════════════════════════════════════════════════ -->
    <section class="categories-section">
        <div class="cat-section-inner">

            <div class="cat-head">
                <div class="cat-head-left">
                    <div class="cat-eyebrow">Danh mục sản phẩm</div>
                    <h2 class="cat-title">Khám phá<br><span>từng dòng bánh</span></h2>
                    <p class="cat-subtitle">Từ những chiếc croissant giòn tan buổi sáng đến<br>
                        những chiếc bánh kem tinh xảo cho ngày đặc biệt.</p>
                </div>
                <a class="cat-cta" href="${pageContext.request.contextPath}/menu">
                    Xem tất cả danh mục
                    <svg width="14" height="14" viewBox="0 0 14 14" fill="none" aria-hidden="true">
                        <path d="M2 7h10M8 3l4 4-4 4" stroke="currentColor" stroke-width="1.5"
                              stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </a>
            </div>

            <div class="cat-grid">
                <c:forEach var="c" items="${categories}" varStatus="st">
                    <c:if test="${st.index < 5}">
                        <a href="${pageContext.request.contextPath}/menu?categoryId=${c.id}"
                           class="cat-tile cat-tile-${st.index + 1}">
                            <img class="cat-tile-img"
                                 src="${not empty c.thumbnail ? c.thumbnail :
                                        (st.index == 0 ? 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&q=85&fit=crop' :
                                         st.index == 1 ? 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600&q=85&fit=crop' :
                                         st.index == 2 ? 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600&q=85&fit=crop' :
                                         st.index == 3 ? 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600&q=85&fit=crop' :
                                                         'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=600&q=85&fit=crop')}"
                                 alt="${c.name}" loading="lazy">
                            <div class="cat-tile-overlay"></div>
                            <div class="cat-tile-body">
                                <span class="cat-tag">Sweet Oven</span>
                                <span class="cat-accent-line"></span>
                                <h3 class="cat-name">${c.name}</h3>
                            </div>
                        </a>
                    </c:if>
                </c:forEach>
            </div>

        </div>
    </section>


    <!-- VOUCHER -->
    <section id="promotions" class="promotions-section">

        <%-- Họa tiết nền --%>
        <div class="promo-bg-pattern" aria-hidden="true">
            <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
                <defs>
                    <pattern id="promo-pattern" x="0" y="0" width="140" height="140" patternUnits="userSpaceOnUse">
                        <ellipse cx="24" cy="22" rx="4" ry="7" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.13" transform="rotate(-20 24 22)"/>
                        <ellipse cx="31" cy="16" rx="3.5" ry="6" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.13" transform="rotate(-38 31 16)"/>
                        <line x1="27" y1="26" x2="27" y2="42" stroke="#C9A96E" stroke-width="1" opacity="0.10"/>
                        <ellipse cx="110" cy="24" rx="12" ry="7" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.10"/>
                        <path d="M98 24 Q110 14 122 24" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.10"/>
                        <rect x="82" y="72" width="5" height="20" rx="2.5" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.10" transform="rotate(28 84 82)"/>
                        <ellipse cx="84" cy="70" rx="6" ry="3.5" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.10" transform="rotate(28 84 70)"/>
                        <circle cx="58" cy="108" r="2" fill="#C9A96E" opacity="0.10"/>
                        <circle cx="12" cy="90" r="1.2" fill="#C9A96E" opacity="0.09"/>
                        <circle cx="128" cy="118" r="1.8" fill="#C9A96E" opacity="0.10"/>
                        <circle cx="70" cy="50" r="1" fill="#C9A96E" opacity="0.08"/>
                    </pattern>
                </defs>
                <rect width="100%" height="100%" fill="url(#promo-pattern)"/>
            </svg>
        </div>

        <div class="promo-inner">

            <%-- Header --%>
            <div class="promo-header">
                <div class="promo-eyebrow">
                    <span class="promo-eyebrow-line"></span>
                    <span>Sweet Oven Bakery</span>
                    <span class="promo-eyebrow-line"></span>
                </div>
                <h2 class="promo-title">Ưu Đãi Ngọt Ngào</h2>
                <p class="promo-desc">Ưu đãi thủ công — số lượng có hạn, áp dụng ngay khi thanh toán.</p>
                <div class="promo-header-deco">
                    <span class="promo-deco-line"></span>
                    <i class="fas fa-gift promo-deco-icon"></i>
                    <span class="promo-deco-line"></span>
                </div>
            </div>

            <%-- Voucher cards --%>
            <div class="promo-body">
                <c:choose>
                    <c:when test="${empty discounts}">
                        <div class="promo-empty">
                            <i class="fas fa-ticket-alt promo-empty-icon"></i>
                            <p>Hiện chưa có voucher nào. Hãy quay lại sau nhé!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="home-vc-scroll" id="homeVcScroll">
                            <c:forEach var="d" items="${discounts}">
                                <c:set var="isSaved" value="${savedDiscountIds != null && savedDiscountIds.contains(d.id)}"/>
                                <div class="home-vc-card ${isSaved ? 'home-vc-saved' : ''}">
                                    <div class="home-vc-logo-panel">
                                        <img src="${pageContext.request.contextPath}/assets/picture/logo-voucher.png"
                                             alt="Sweet Oven" class="home-vc-logo-img"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                        <i class="fas fa-bread-slice home-vc-logo-fallback"></i>
                                        <div class="home-vc-logo-name">Sweet Oven<br>Bakery</div>
                                    </div>
                                    <div class="home-vc-body">
                                        <div>
                                            <div class="home-vc-top">
                                                <span class="home-vc-code">${d.code}</span>
                                                <c:choose>
                                                    <c:when test="${isSaved}">
                                                        <span class="home-vc-badge home-vc-badge-saved"><i class="fa fa-check me-1"></i>Đã lưu</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="home-vc-badge home-vc-badge-new">✦ Mới</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="home-vc-desc">${d.description}</div>
                                            <div class="home-vc-meta">
                                                <span><i class="fa fa-receipt"></i> Đơn tối thiểu: <b>${d.displayMinOrder}</b></span>
                                            </div>
                                        </div>
                                        <div class="home-vc-footer">
                                            <span class="home-vc-expire"><i class="fa fa-clock"></i>&nbsp;HSD: <b style="color:#8B4513;">${d.formattedEndDate}</b></span>
                                            <c:choose>
                                                <c:when test="${isSaved}">
                                                    <a href="${pageContext.request.contextPath}/my-cart?pendingVoucher=${d.code}" class="home-vc-btn-use">
                                                        <i class="fa fa-cart-shopping"></i>Dùng ngay
                                                    </a>
                                                </c:when>
                                                <c:when test="${empty sessionScope.user}">
                                                    <a href="${pageContext.request.contextPath}/login?redirect=home" class="home-vc-btn-save">
                                                        <i class="fa fa-bookmark"></i>Lưu ngay
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="home-vc-btn-save"
                                                            onclick="saveVoucherHome(this, ${d.id})">
                                                        <i class="fa fa-bookmark"></i>Lưu ngay
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Footer --%>
            <div class="promo-footer">
                <a href="${pageContext.request.contextPath}/vouchers" class="btn-view-all">
                    <i class="fas fa-ticket-alt"></i>
                    Xem Tất Cả Ưu Đãi
                </a>
            </div>

        </div>
    </section>


    <!-- ABOUT -->
    <section class="about-section">
        <div class="about-inner">
            <div class="about-text">
                <p class="about-eyebrow">SWEET OVEN BAKERY — TIỆM BÁNH THỦ CÔNG TẠI TP.HCM</p>
                <h2 class="about-title">TIỆM BÁNH NGỌT &amp; ĐỒ NƯỚNG<br>THỦ CÔNG TỪNG CHIẾC</h2>
                <p class="about-desc">
                    Sweet Oven Bakery là tiệm bánh được nhiều khách hàng yêu thích nhờ sự kết hợp hài hòa giữa
                    bánh chất lượng, nguyên liệu tươi sạch và <strong>tâm huyết của người thợ bánh thủ công</strong>.
                    Mỗi chiếc bánh đều được làm mới trong ngày — không chất bảo quản, không phẩm màu nhân tạo.
                </p>
                <p class="about-desc">
                    Các dòng bánh nổi bật tại Sweet Oven gồm <strong>croissant bơ giòn tan, bánh kem tinh xảo
                    và bánh mì nguyên cám thơm lành</strong>. Bên cạnh đó, thực đơn phong phú với hàng chục
                    loại bánh ngọt theo mùa luôn mang đến trải nghiệm mới mẻ cho khách hàng.
                </p>
                <p class="about-desc">
                    Với hơn <strong>4 năm kinh nghiệm</strong> và hơn <strong>1.000 khách hàng mỗi ngày</strong>,
                    Sweet Oven Bakery không chỉ là nơi mua bánh mà còn là điểm hẹn quen thuộc cho gia đình
                    và những buổi gặp gỡ ấm áp.
                </p>
                <a href="${pageContext.request.contextPath}/about" class="about-cta">Về chúng tôi</a>
            </div>
            <div class="about-image">
                <img src="https://cdn.hstatic.net/themes/200000849803/1001437108/14/home_aboutus_img.jpg?v=63"
                     alt="Sweet Oven Bakery — Làm bánh thủ công">
            </div>
        </div>
    </section>


    <!-- ═══════════════════════════════════════════════════════
         STATISTICS
    ════════════════════════════════════════════════════════ -->
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

<%@ include file="/components/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    (function () {
        var contextPath = (document.querySelector('meta[name="contextPath"]') || {}).content || '';

        document.querySelectorAll('.btn-add-to-cart[data-product-id]').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                var productId = this.dataset.productId;
                var self = this;
                self.disabled = true;
                var originalHtml = self.innerHTML;
                self.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

                fetch(contextPath + '/add-cart', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'productId=' + encodeURIComponent(productId) + '&quantity=1'
                })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        if (typeof window.showGlobalToast === 'function') {
                            window.showGlobalToast(data.success ? 'success' : 'error', data.message);
                        }
                        if (data.success) {
                            var badge = document.getElementById('cart-badge');
                            if (badge) {
                                badge.textContent = data.cartTotalQuantity;
                                badge.style.display = 'inline-block';
                            }
                        }
                    })
                    .catch(function () {
                        if (typeof window.showGlobalToast === 'function') {
                            window.showGlobalToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
                        }
                    })
                    .finally(function () {
                        self.innerHTML = originalHtml;
                        self.disabled = false;
                    });
            });
        });
    })();

    // ── 1. Sync custom hero indicators với Bootstrap carousel ──
    (function () {
        var carouselEl = document.getElementById('heroCarousel');
        if (!carouselEl) return;
        var indicators = Array.from(carouselEl.querySelectorAll('.hero-indicators button'));
        indicators.forEach(function (btn, i) {
            btn.addEventListener('click', function () {
                bootstrap.Carousel.getOrCreateInstance(carouselEl).to(i);
            });
        });
        carouselEl.addEventListener('slide.bs.carousel', function (e) {
            indicators.forEach(function (btn) { btn.classList.remove('active'); });
            if (indicators[e.to]) indicators[e.to].classList.add('active');
        });
    })();

    // ── 2. Chỉ hiện random 3 voucher ──
    (function () {
        var grid = document.getElementById('homeVcScroll');
        if (!grid) return;
        var cards = Array.from(grid.querySelectorAll('.home-vc-card'));
        if (cards.length <= 3) return;
        // Fisher-Yates shuffle
        for (var i = cards.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var tmp = cards[i]; cards[i] = cards[j]; cards[j] = tmp;
        }
        // Sắp xếp lại DOM và ẩn từ card thứ 4 trở đi
        cards.forEach(function (c, idx) {
            grid.appendChild(c);
            c.style.display = idx >= 3 ? 'none' : '';
        });
    })();

    // ── Favorite toggle ──
    (function () {
        const contextPath = (document.querySelector('meta[name="contextPath"]') || {}).content || '';
        window.toggleFavorite = function (btn, productId) {
            event && event.stopPropagation();
            fetch(contextPath + '/toggle-favorite', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'productId=' + productId
            })
                .then(res => {
                    if (res.status === 401) { window.location.href = contextPath + '/login'; return null; }
                    return res.json();
                })
                .then(data => {
                    if (!data) return;
                    if (data.isFavorite) { btn.classList.add('active'); }
                    else { btn.classList.remove('active'); }
                    btn.classList.remove('heart-pop');
                    void btn.offsetWidth;
                    btn.classList.add('heart-pop');
                })
                .catch(err => console.error('Favorite error:', err));
        };
    })();

    var _vcContextPath = (document.querySelector('meta[name="contextPath"]') || {}).content || '';

    function saveVoucherHome(btn, discountId) {
        btn.disabled = true;
        var originalHtml = btn.innerHTML;
        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i>';

        fetch(_vcContextPath + '/save-voucher', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest'},
            body: 'discountId=' + encodeURIComponent(discountId)
        })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var card = btn.closest('.home-vc-card');
                if (data.status === 'ok') {
                    var badge = card.querySelector('.home-vc-badge');
                    if (badge) { badge.className = 'home-vc-badge home-vc-badge-saved'; badge.innerHTML = '<i class="fa fa-check me-1"></i>Đã lưu'; }
                    card.classList.add('home-vc-saved');
                    var code = card.querySelector('.home-vc-code').textContent.trim();
                    btn.outerHTML = '<a href="' + _vcContextPath + '/my-cart?pendingVoucher=' + encodeURIComponent(code) + '" class="home-vc-btn-use"><i class="fa fa-cart-shopping"></i>Dùng ngay</a>';
                    if (typeof window.showGlobalToast === 'function') window.showGlobalToast('success', data.message);
                } else {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                    if (typeof window.showGlobalToast === 'function') window.showGlobalToast('error', data.message);
                }
            })
            .catch(function() {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
                if (typeof window.showGlobalToast === 'function') window.showGlobalToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
            });
    }
</script>
</body>
</html>
