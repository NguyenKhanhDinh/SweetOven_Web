<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm | Sweet Oven Bakery</title>
    <meta name="description" content="Bánh kem dâu tươi thơm ngon - Sweet Oven Bakery" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product_detail.css">
</head>

<body>
  <%@ include file="/components/header.jsp" %>

<main>
    <section class="product-detail">
        <div class="product-image-slider">
            <button class="nav-btn left" onclick="prevImage()">&#10094;</button>

            <c:if test="${not empty product.listImages}">
                <c:forEach var="img" items="${product.listImages}" varStatus="st">
                    <img src="${img.imageUrl}" class="slide-img ${st.index == 0 ? 'active' : ''}" alt="${product.name}">
                </c:forEach>
            </c:if>

            <button class="nav-btn right" onclick="nextImage()">&#10095;</button>
        </div>

        <div class="product-info">
            <h2>${product.name}</h2>
            <p class="product-price">
                <c:choose>
                    <c:when test="${product.discountPrice != null && product.discountPrice > 0}">
                        <span class="price-discount">
                            <fmt:formatNumber value="${product.discountPrice}" type="number" groupingUsed="true"/>
                        </span>
                        <span class="price-original">
                            <fmt:formatNumber value="${product.originalPrice}" type="number" groupingUsed="true"/>
                        </span>
                        VNĐ
                    </c:when>

                    <c:otherwise>
                        <span class="price-normal">
                            <fmt:formatNumber value="${product.originalPrice}" type="number" groupingUsed="true"/>
                        </span>
                        VNĐ
                    </c:otherwise>
                </c:choose>
            </p>


            <div class="product-actions">
                <form method="get" action="${pageContext.request.contextPath}/add-cart">
                    <input type="hidden" name="productId" value="${product.id}">
                    <input type="hidden" name="quantity" value="1">
                    <input type="hidden" name="returnUrl"
                           value="${pageContext.request.contextPath}/product?id=${product.id}">

                    <div class="product-status mb-2">
                        <strong>Trạng thái: </strong>
                        <c:choose>
                            <c:when test="${product.stockQuantity > 0}">
                                <span class="text-success">Còn hàng (${product.stockQuantity})</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-danger">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <button type="submit" class="btn-add" ${product.stockQuantity <=0 ? 'disabled' : '' }>
                        <c:choose>
                            <c:when test="${product.stockQuantity <= 0}">Hết hàng</c:when>
                            <c:otherwise>Thêm vào giỏ</c:otherwise>
                        </c:choose>
                    </button>

                </form>

            </div>

            <div class="product-features">
                <div class="feature-item">
                    <div class="feature-icon">⏰</div>
                    <p><strong>Giao hàng nhanh</strong><br>Trong 2 giờ</p>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">🍰</div>
                    <p><strong>Làm tươi mỗi ngày</strong><br>Đảm bảo chất lượng</p>
                </div>
            </div>
        </div>
    </section>
        <section class="product-description">
            <div class="product-tabs">
                <div class="tab-btn active" onclick="switchTab('desc', this)">MÔ TẢ CHUNG</div>
                <div class="tab-btn" onclick="switchTab('comment', this)">BÌNH LUẬN</div>
            </div>

            <div class="desc-container">
                <div id="desc" class="tab-content active">
                    <p class="desc-text">${product.description}</p>

                    <div class="desc-ingredients">
                        <strong>Thành phần chính:</strong>
                        <p>${product.ingredients}</p>
                    </div>
                </div>

                <div id="comment" class="tab-content">
                    <p>Chưa có bình luận nào.</p>
                </div>
            </div>

        </section>

    <section class="related-products">
        <div class="section-title">
            <h3>Sản phẩm liên quan</h3>
        </div>

        <div class="related-list">
            <c:forEach var="rp" items="${relatedProducts}">
                <div class="related-item" data-product-id="${rp.id}" onclick="goToProductDetail(${rp.id})">
                    <c:if test="${rp.stockQuantity <= 0}">
                        <div class="related-badge">Hết hàng</div>
                    </c:if>

                    <div class="related-img">
                        <c:if test="${not empty rp.listImages}">
                            <img src="${rp.listImages[0].imageUrl}" alt="${rp.name}">
                        </c:if>
                    </div>

                    <div class="related-content">
                        <h4>${rp.name}</h4>

                        <div class="related-price">
                            <c:choose>
                                <c:when test="${rp.discountPrice != null && rp.discountPrice > 0}">
                                    <span class="price-discount">
                                        <fmt:formatNumber value="${rp.discountPrice}" type="number" groupingUsed="true"/>
                                    </span>
                                    <span class="price-original">
                                        <fmt:formatNumber value="${rp.originalPrice}" type="number" groupingUsed="true"/>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="price-normal">
                                        <fmt:formatNumber value="${rp.originalPrice}" type="number" groupingUsed="true"/>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <form method="get" action="${pageContext.request.contextPath}/add-cart"
                              onclick="event.stopPropagation();">
                            <input type="hidden" name="productId" value="${rp.id}">
                            <input type="hidden" name="quantity" value="1">
                            <input type="hidden" name="returnUrl"
                                   value="${pageContext.request.contextPath}/product?id=${product.id}">

                            <button type="submit" class="btn-related-cart" ${rp.stockQuantity <=0 ? 'disabled' : '' }>
                                <c:choose>
                                    <c:when test="${rp.stockQuantity <= 0}">Hết hàng</c:when>
                                    <c:otherwise>Thêm vào giỏ</c:otherwise>
                                </c:choose>
                            </button>
                        </form>

                    </div>
                </div>
            </c:forEach>

        </div>
    </section>
    <div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
          <div class="modal-body p-0">
            <img src="" id="modalImage" class="img-fluid w-100" alt="Phóng to">
          </div>
        </div>
      </div>
    </div>

</main>
  <%@ include file="/components/footer.jsp" %>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/product_detail.js"></script>
</body>

</html>