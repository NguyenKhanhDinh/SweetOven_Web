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
                  <a href="discount" class="btn-view-all">
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
</body>
</html>