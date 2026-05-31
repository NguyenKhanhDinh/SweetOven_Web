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

    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">
</head>
<body>
<%@ include file="/components/header.jsp" %>

<main>
    <!-- Hero Carousel Section -->
    <div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel">
        <div class="carousel-inner">
            <c:forEach var="b" items="${banners}" varStatus="st">
                <div class="carousel-item ${st.first ? 'active' : ''}"
                     style="background-image: url('${pageContext.request.contextPath}${b.imageUrl}')">
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

    <!-- Featured Products Section -->
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
                            <div class="product-img">
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                    <img src="${p.image}" alt="${p.name}">
                                </a>
                            </div>
                            <div class="product-content">
                                <h3>${p.name}</h3>
                                <div class="product-price">
                                    <fmt:formatNumber value="${p.displayPrice}" type="number"/> VNĐ
                                </div>
                                <button type="button"
                                        class="btn-add-to-cart"
                                        data-product-id="${p.id}"
                                        onclick="event.stopPropagation();"
                                    ${p.stockQuantity <= 0 ? 'disabled' : ''}>
                                    <c:choose>
                                        <c:when test="${p.stockQuantity <= 0}">Hết hàng</c:when>
                                        <c:otherwise>Thêm vào giỏ</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="text-center mt-5">
                <a href="menu" class="btn-view-all">
                    <i class="fas fa-store me-2"></i>
                    Xem Tất Cả Sản Phẩm
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <section id="promotions" class="promotions-section">
        <div class="container">
            <div class="section-title">
                <h2>Voucher Ưu Đãi</h2>
                <p>Lưu và sử dụng voucher để tiết kiệm cho đơn hàng của bạn</p>
            </div>

            <c:choose>
                <c:when test="${empty discounts}">
                    <div class="text-center py-4" style="opacity:.6; color: var(--primary);">
                        <i class="fas fa-tag fa-2x mb-3 d-block"></i>
                        <p>Hiện chưa có voucher nào. Hãy quay lại sau nhé!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="home-vc-scroll">
                        <c:forEach var="d" items="${discounts}">
                            <c:set var="isSaved"
                                   value="${savedDiscountIds != null && savedDiscountIds.contains(d.id)}"/>
                            <div class="home-vc-card ${isSaved ? 'home-vc-saved' : ''}">

                                    <%-- LEFT: Logo panel --%>
                                <div class="home-vc-logo-panel">
                                    <img src="${pageContext.request.contextPath}/assets/picture/logo-voucher.png"
                                         alt="Sweet Oven" class="home-vc-logo-img"
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                    <div class="home-vc-logo-name">Sweet Oven<br>Bakery</div>
                                </div>

                                    <%-- RIGHT: Body --%>
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
                                                <a href="${pageContext.request.contextPath}/my-cart?pendingVoucher=${d.code}"
                                                   class="home-vc-btn-use">
                                                    <i class="fa fa-cart-shopping"></i>Dùng ngay
                                                </a>
                                            </c:when>
                                            <c:when test="${empty sessionScope.user}">
                                                <a href="${pageContext.request.contextPath}/login?redirect=home"
                                                   class="home-vc-btn-save">
                                                    <i class="fa fa-bookmark"></i>Lưu ngay
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button"
                                                        class="home-vc-btn-save"
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
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/vouchers" class="btn-view-all">
                <i class="fas fa-ticket-alt me-2"></i>
                Xem Tất Cả Voucher
                <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </section>


    <!-- Categories Section -->
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
                <a href="menu" class="btn-view-all">
                    <i class="fas fa-store me-2"></i>
                    Xem Tất Cả Sản Phẩm
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- Reviews Section -->
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
                            Bánh ở đây ngon tuyệt! Đặc biệt là bánh tiramisu, mềm mịn và không quá ngọt. Giao hàng
                            nhanh, đóng gói cẩn thận. Mình sẽ ủng hộ dài lâu!
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
                            Mình rất ấn tượng với bánh mì nguyên cám ở đây. Thơm ngon, bổ dưỡng và giá cả hợp lý. Nhân
                            viên tư vấn nhiệt tình, giao hàng đúng hẹn.
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
                            Bánh croissant giòn tan, bơ thơm đúng chuẩn Pháp. Mình rất thích nhưng mong cửa hàng có thêm
                            nhiều lựa chọn không đường cho người ăn kiêng.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
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
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
    // Gắn AJAX cho tất cả nút thêm vào giỏ ở trang chủ
    (function () {
        var contextPath = document.querySelector('meta[name="contextPath"]')
            ? document.querySelector('meta[name="contextPath"]').content
            : '';

        document.querySelectorAll('.btn-add-to-cart[data-product-id]').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                var productId = this.dataset.productId;
                var self = this;

                self.disabled = true;
                var originalText = self.innerHTML;
                self.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

                fetch(contextPath + '/add-cart', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'productId=' + encodeURIComponent(productId) + '&quantity=1'
                })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (typeof window.showGlobalToast === 'function') {
                            window.showGlobalToast(data.success ? 'success' : 'error', data.message);
                        }
                        if (data.success) {
                            var badge = document.getElementById('cart-badge');
                            if (badge) {
                                badge.textContent = data.cartTotalQuantity;
                                badge.style.display = 'inline-block';
                            } else if (data.cartTotalQuantity > 0) {
                                var cartLink = document.querySelector('a[href*="my-cart"]');
                                if (cartLink) {
                                    var newBadge = document.createElement('span');
                                    newBadge.id = 'cart-badge';
                                    newBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill';
                                    newBadge.style.display = 'inline-block';
                                    newBadge.textContent = data.cartTotalQuantity;
                                    cartLink.appendChild(newBadge);
                                }
                            }
                        }
                    })
                    .catch(function () {
                        if (typeof window.showGlobalToast === 'function') {
                            window.showGlobalToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
                        }
                    })
                    .finally(function () {
                        self.innerHTML = originalText;
                        self.disabled = false;
                    });
            });
        });
    })();
    var _vcContextPath = (document.querySelector('meta[name="contextPath"]') || {}).content || '';

    function saveVoucherHome(btn, discountId) {
        btn.disabled = true;
        var originalHtml = btn.innerHTML;
        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i>';

        fetch(_vcContextPath + '/save-voucher', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'discountId=' + encodeURIComponent(discountId)
        })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var card = btn.closest('.home-vc-card');
                if (data.status === 'ok') {
                    // Đổi badge → Đã lưu
                    var badge = card.querySelector('.home-vc-badge');
                    if (badge) {
                        badge.className = 'home-vc-badge home-vc-badge-saved';
                        badge.innerHTML = '<i class="fa fa-check me-1"></i>Đã lưu';
                    }
                    // Đổi card style → saved
                    card.classList.add('home-vc-saved');
                    // Đổi nút → Dùng ngay
                    var code = card.querySelector('.home-vc-code').textContent.trim();
                    var footer = btn.closest('.home-vc-footer');
                    btn.outerHTML = '<a href="' + _vcContextPath + '/my-cart?pendingVoucher=' + encodeURIComponent(code) + '" class="home-vc-btn-use"><i class="fa fa-cart-shopping"></i>Dùng ngay</a>';
                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('success', data.message);
                    }
                } else if (data.status === 'already') {
                    card.classList.add('home-vc-saved');
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('error', data.message);
                    }
                } else {
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast('error', data.message);
                    }
                }
            })
            .catch(function() {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
                if (typeof window.showGlobalToast === 'function') {
                    window.showGlobalToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
                }
            });
    }
</script>
</body>
</html>