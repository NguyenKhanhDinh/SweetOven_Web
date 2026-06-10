<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} | Sweet Oven Bakery</title>
    <meta name="description" content="${product.description}">
    <meta name="contextPath" content="${pageContext.request.contextPath}">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product_detail.css">
</head>
<body>
<%@ include file="/components/header.jsp" %>

<main>
    <div class="pd-wrapper">

        <%-- ── Main 2-col Layout ── --%>
        <div class="pd-main">

            <%-- LEFT: Gallery --%>
            <div class="pd-gallery">
                <div class="pd-image-main" id="pdMainImage">
                    <c:choose>
                        <c:when test="${not empty product.listImages}">
                            <c:forEach var="img" items="${product.listImages}" varStatus="st">
                                <img src="${img.imageUrl}"
                                     class="slide-img ${st.index == 0 ? 'active' : ''}"
                                     alt="${product.name}"
                                     data-index="${st.index}">
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/picture/placeholder.png"
                                 class="slide-img active" alt="${product.name}">
                        </c:otherwise>
                    </c:choose>

                </div>

                <%-- Thumbnails — chỉ hiện nếu có nhiều hơn 1 ảnh --%>
                <c:if test="${not empty product.listImages}">
                    <c:set var="imgCount" value="0"/>
                    <c:forEach var="img" items="${product.listImages}">
                        <c:set var="imgCount" value="${imgCount + 1}"/>
                    </c:forEach>
                    <c:if test="${imgCount > 1}">
                        <div class="pd-thumbs" id="pdThumbs">
                            <c:forEach var="img" items="${product.listImages}" varStatus="st">
                                <div class="pd-thumb ${st.index == 0 ? 'active' : ''}"
                                     onclick="goToImage(${st.index})">
                                    <img src="${img.imageUrl}" alt="${product.name} ${st.index + 1}">
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:if>
            </div>

            <%-- RIGHT: Info Panel --%>
            <div class="pd-info">

                <div class="pd-name-row">
                    <h1 class="pd-name">${product.name}</h1>
                    <button type="button"
                            class="btn-favorite pd-fav-btn ${not empty favoriteProductIds and favoriteProductIds.contains(product.id) ? 'active' : ''}"
                            data-product-id="${product.id}"
                            onclick="toggleFavorite(this, ${product.id});"
                            title="Thêm vào yêu thích">
                        <i class="fas fa-heart"></i>
                    </button>
                </div>

                <%-- Price --%>
                <div class="pd-price-block">
                    <c:choose>
                        <c:when test="${product.discountPrice != null && product.discountPrice > 0}">
              <span class="pd-price-sale">
                <fmt:formatNumber value="${product.discountPrice}" type="number" groupingUsed="true"/>
              </span>
                            <span class="pd-price-original">
                <fmt:formatNumber value="${product.originalPrice}" type="number" groupingUsed="true"/>
              </span>
                            <span class="pd-price-currency">VNĐ</span>
                        </c:when>
                        <c:otherwise>
              <span class="pd-price-normal">
                <fmt:formatNumber value="${product.originalPrice}" type="number" groupingUsed="true"/>
              </span>
                            <span class="pd-price-currency">VNĐ</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Stock status --%>
                <div class="pd-stock ${product.stockQuantity > 0 ? 'in-stock' : 'out-stock'}">
                    <span class="pd-stock-dot"></span>
                    <c:choose>
                        <c:when test="${product.stockQuantity > 0}">
                            <span>Còn hàng &mdash; ${product.stockQuantity} sản phẩm</span>
                        </c:when>
                        <c:otherwise>
                            <span>Hết hàng</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="pd-divider"></div>

                <%-- Ingredients snippet --%>
                <c:if test="${not empty product.ingredients}">
                    <div class="pd-snippet">
                        <strong>Thành phần</strong>
                            ${product.ingredients}
                    </div>
                    <div class="pd-divider"></div>
                </c:if>

                <%-- Action box --%>
                <div class="pd-action-box">
                    <input type="hidden" name="productId" value="${product.id}">
                    <input type="hidden" name="returnUrl"
                           value="${pageContext.request.contextPath}/product?id=${product.id}">

                    <div class="pd-qty-row">
                        <span class="pd-qty-label">Số lượng</span>
                        <div class="pd-qty-ctrl">
                            <button class="pd-qty-btn" type="button" onclick="changeQty(-1)"
                            ${product.stockQuantity <= 0 ? 'disabled' : ''}>&#8722;</button>
                            <input class="pd-qty-input" type="number" id="pdQty" name="quantity"
                                   value="1" min="1" max="${product.stockQuantity}"
                            ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                            <button class="pd-qty-btn" type="button" onclick="changeQty(1)"
                            ${product.stockQuantity <= 0 ? 'disabled' : ''}>&#43;</button>
                        </div>
                    </div>

                    <button type="button"
                            class="pd-btn-cart btn-add"
                            data-product-id="${product.id}"
                    ${product.stockQuantity <= 0 ? 'disabled' : ''}>
                        <c:choose>
                            <c:when test="${product.stockQuantity <= 0}">
                                <i class="fa-solid fa-ban"></i> Hết hàng
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-basket-shopping"></i> Thêm vào giỏ
                            </c:otherwise>
                        </c:choose>
                    </button>
                </div>


            </div><%-- /.pd-info --%>
        </div><%-- /.pd-main --%>

        <%-- ── Description Section ── --%>
        <section class="pd-desc-section">
            <div class="pd-section-head">
                <div>
                    <p class="pd-section-eyebrow">Chi tiết</p>
                    <h2 class="pd-section-title">Thông tin sản phẩm</h2>
                </div>
                <div class="pd-section-divider"></div>
            </div>

            <div class="pd-tab-nav">
                <button class="pd-tab-btn active" onclick="switchTab('pd-desc', this)">Mô tả chung</button>
                <button class="pd-tab-btn"        onclick="switchTab('pd-comment', this)">Bình luận</button>
            </div>

            <div id="pd-desc" class="pd-tab-pane active">
                <p class="pd-desc-text">${product.description}</p>
                <c:if test="${not empty product.ingredients}">
                    <div class="pd-ingredients">
                        <strong>Thành phần chính</strong>
                        <p>${product.ingredients}</p>
                    </div>
                </c:if>
            </div>

            <div id="pd-comment" class="pd-tab-pane">
                <div class="pd-comment-empty">
                    <span class="pd-comment-empty-icon">&#128172;</span>
                    <p>Chưa có bình luận nào. Hãy là người đầu tiên chia sẻ cảm nhận!</p>
                </div>
            </div>
        </section>

        <%-- ── Related Products ── --%>
        <c:if test="${not empty relatedProducts}">
            <section class="pd-related-section">
                <div class="pd-related-head">
                    <div class="pd-related-heading">
                        <p class="pd-related-eyebrow">Khám phá thêm</p>
                        <h2 class="pd-related-title">Sản phẩm liên quan</h2>
                    </div>
                </div>

                <div class="pd-related-grid">
                    <c:forEach var="rp" items="${relatedProducts}">
                        <div class="pd-related-card" onclick="goToProductDetail(${rp.id})">
                            <c:if test="${rp.stockQuantity <= 0}">
                                <span class="pd-related-badge">Hết hàng</span>
                            </c:if>

                            <div class="pd-related-img">
                                <c:if test="${not empty rp.listImages}">
                                    <img src="${rp.listImages[0].imageUrl}" alt="${rp.name}">
                                </c:if>
                                <button type="button"
                                        class="btn-favorite ${not empty favoriteProductIds and favoriteProductIds.contains(rp.id) ? 'active' : ''}"
                                        data-product-id="${rp.id}"
                                        onclick="event.stopPropagation(); toggleFavorite(this, ${rp.id});"
                                        title="Thêm vào yêu thích">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>

                            <div class="pd-related-body">
                                <h3 class="pd-related-name">${rp.name}</h3>

                                <div class="pd-related-price">
                                    <c:choose>
                                        <c:when test="${rp.discountPrice != null && rp.discountPrice > 0}">
                      <span class="price-sale">
                        <fmt:formatNumber value="${rp.discountPrice}" type="number" groupingUsed="true"/> đ
                      </span>
                                            <span class="price-original">
                        <fmt:formatNumber value="${rp.originalPrice}" type="number" groupingUsed="true"/> đ
                      </span>
                                        </c:when>
                                        <c:otherwise>
                      <span class="price-normal">
                        <fmt:formatNumber value="${rp.originalPrice}" type="number" groupingUsed="true"/> đ
                      </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <input type="hidden" name="productId" value="${rp.id}">
                                <input type="hidden" name="quantity" value="1">
                                <input type="hidden" name="returnUrl"
                                       value="${pageContext.request.contextPath}/product?id=${product.id}">

                                <button type="button"
                                        class="pd-related-btn btn-related-cart"
                                        data-product-id="${rp.id}"
                                    ${rp.stockQuantity <= 0 ? 'disabled' : ''}>
                                    <c:choose>
                                        <c:when test="${rp.stockQuantity <= 0}">Hết hàng</c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-basket-shopping"></i> Thêm vào giỏ
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

    </div><%-- /.pd-wrapper --%>

    <%-- Image Zoom Modal --%>
    <div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content bg-transparent border-0">
                <div class="modal-body p-0 text-center">
                    <img src="" id="modalImage" class="img-fluid" alt="Phóng to"
                         style="max-height:90vh; object-fit:contain; border-radius:8px;">
                </div>
            </div>
        </div>
    </div>

</main>

<%@ include file="/components/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/product_detail.js"></script>

<script>
    // ── Gallery ──────────────────────────────────────────────
    var currentIndex = 0;
    var slides = document.querySelectorAll('.slide-img');
    var thumbs  = document.querySelectorAll('.pd-thumb');

    function showImage(idx) {
        if (!slides.length) return;
        currentIndex = (idx + slides.length) % slides.length;
        slides.forEach(function(s, i) { s.classList.toggle('active', i === currentIndex); });
        thumbs.forEach(function(t, i) { t.classList.toggle('active', i === currentIndex); });
    }
    function prevImage() { showImage(currentIndex - 1); }
    function nextImage() { showImage(currentIndex + 1); }
    function goToImage(idx) { showImage(idx); }

    // ── Quantity ─────────────────────────────────────────────
    function changeQty(delta) {
        var input = document.getElementById('pdQty');
        if (!input) return;
        var max = parseInt(input.max) || 99;
        var v = parseInt(input.value) + delta;
        input.value = Math.max(1, Math.min(max, v));
    }

    // ── Tabs ─────────────────────────────────────────────────
    function switchTab(id, btn) {
        document.querySelectorAll('.pd-tab-pane').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.pd-tab-btn').forEach(function(b)  { b.classList.remove('active'); });
        document.getElementById(id).classList.add('active');
        btn.classList.add('active');
    }

    // ── Zoom: click ảnh chính → mở modal ─────────────────────
    slides.forEach(function(img) {
        img.addEventListener('click', function() {
            document.getElementById('modalImage').src = img.src;
            new bootstrap.Modal(document.getElementById('imageModal')).show();
        });
    });
</script>
</body>
</html>
