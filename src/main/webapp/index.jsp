<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sweet Oven Bakery - Bánh ngọt & Đồ nướng</title>
  <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery" />
  <meta name="contextPath" content="${pageContext.request.contextPath}">
  <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">

  <!-- External Libraries -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
                    <fmt:formatNumber value="${p.displayPrice}" type="number" /> VNĐ
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
                  <h2>Mã Giảm Giá</h2>
                  <p>Lưu ngay các mã giảm giá hấp dẫn cho đơn hàng của bạn</p>
              </div>

              <div class="promo-row-scroll">
                  <c:forEach var="d" items="${discounts}">
                      <div class="promo-item">
                          <div class="promo-card w-100">
                              <div class="promo-icon">
                                      <%-- discountType là int: 1 = %, 0 = số tiền --%>
                                  <i class="fas ${d.discountType == 1 ? 'fa-percent' : 'fa-hand-holding-usd'}"></i>
                              </div>
                              <div class="promo-discount">
                                  <c:choose>
                                      <c:when test="${d.discountType == 1}">
                                          <fmt:formatNumber value="${d.value}" maxFractionDigits="0" />%
                                      </c:when>
                                      <c:otherwise>
                                          <fmt:formatNumber value="${d.value}" type="number" groupingUsed="true"
                                                            maxFractionDigits="0" /> VNĐ
                                      </c:otherwise>
                                  </c:choose>
                              </div>
                              <h4>
                                  <c:choose>
                                      <c:when test="${d.discountType == 1}">Ưu Đãi Đặc Biệt</c:when>
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
                                  HSD: ${d.formattedEndDate}
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
          <div class="text-center mt-5">
              <a href="${pageContext.request.contextPath}/vouchers" class="btn-view-all">
                  <i class="fas fa-store me-2"></i>
                  Xem Tất Cả Mã Giảm Giá
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
                <c:forEach var="fb" items="${feedbacks}">
                    <div class="col-md-6 col-lg-4">
                        <div class="review-card-simple">
                            <div class="review-header-simple">
                                <div class="avatar-simple">
                                    <i class="fas fa-user-circle fa-3x" style="color: var(--secondary);"></i>
                                </div>
                                <div class="review-user-info">
                                    <h5 class="mb-0">${fb.fullName}</h5>
                                    <small class="text-muted">${fb.email}</small>
                                </div>
                            </div>
                            <div class="rating-simple mb-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <p class="review-content-simple">"${fb.content}"</p>
                            <small class="text-muted">
                                <i class="far fa-calendar-alt"></i>
                                ${fb.createdAt}
                            </small>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty feedbacks}">
                    <div class="col-12 text-center">
                        <p class="text-muted">Chưa có đánh giá nào. Hãy là khách hàng đầu tiên gửi đánh giá!</p>
                    </div>
                </c:if>
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
                      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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
  </script>
</body>
</html>