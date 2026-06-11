<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.util.List, model.ProductReview" %>
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

    <style>
        /* ── Review Section ── */
        .review-summary { display:flex; align-items:center; gap:24px; padding:20px 0 24px; border-bottom:1px solid rgba(201,169,110,.25); margin-bottom:20px; }
        .review-avg-score { font-size:52px; font-weight:800; color:#3C2F27; line-height:1; }
        .review-avg-stars { font-size:22px; color:#f5a623; margin:4px 0; }
        .review-avg-count { font-size:13px; color:#888; font-weight:500; }
        .review-card { background:#fff; border:1px solid rgba(201,169,110,.25); border-radius:12px; padding:16px 18px; margin-bottom:12px; }
        .review-card-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:6px; }
        .review-author { font-weight:700; font-size:14px; color:#3C2F27; }
        .review-date   { font-size:12px; color:#888; }
        .review-stars  { color:#f5a623; font-size:14px; margin-bottom:6px; }
        .review-stars .empty { color:#ddd; }
        .review-text   { font-size:14px; color:#555; line-height:1.6; }
        .btn-show-all  { display:block; width:100%; margin-top:16px; padding:10px; background:transparent; border:1.5px solid #C9A96E; border-radius:8px; color:#c97b21; font-weight:700; font-size:14px; cursor:pointer; transition:all .2s; }
        .btn-show-all:hover { background:#C9A96E; color:#fff; }
        .review-toast  { position:fixed; bottom:24px; right:24px; background:#2e7d32; color:#fff; padding:12px 20px; border-radius:10px; font-size:14px; font-weight:600; z-index:9999; box-shadow:0 4px 16px rgba(0,0,0,.2); opacity:0; transform:translateY(20px); transition:all .3s; pointer-events:none; }
        .review-toast.show  { opacity:1; transform:translateY(0); }
        .review-toast.error { background:#c62828; }
        .review-form-wrap   { background:#fffbf5; border:1.5px solid #e8d5b0; border-radius:14px; padding:20px 22px; margin-bottom:24px; }
        .review-form-wrap h4 { font-size:16px; font-weight:700; color:#3C2F27; margin-bottom:14px; }
        .star-selector { display:flex; gap:6px; margin-bottom:14px; cursor:pointer; }
        .star-selector i { font-size:28px; color:#ddd; transition:color .15s; }
        .star-selector i.selected, .star-selector i.hover { color:#f5a623; }
        .review-textarea { width:100%; min-height:90px; border:1px solid #ddd; border-radius:8px; padding:10px 12px; font-family:inherit; font-size:14px; resize:vertical; outline:none; transition:border-color .2s; }
        .review-textarea:focus { border-color:#C9A96E; }
        .btn-submit-review { margin-top:12px; padding:9px 24px; background:#C9A96E; border:none; border-radius:8px; color:#fff; font-weight:700; font-size:14px; cursor:pointer; transition:background .2s; }
        .btn-submit-review:hover { background:#c97b21; }
        .star-error { color:#e53935; font-size:12px; display:none; margin-top:-10px; margin-bottom:10px; }
        .already-reviewed-note { display:flex; align-items:center; gap:8px; background:#e8f5e9; border:1px solid #a5d6a7; border-radius:10px; padding:12px 16px; font-size:14px; color:#2e7d32; font-weight:600; margin-bottom:20px; }
        .already-reviewed-note i { font-size:18px; }
    </style>
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

            <%-- ── CSS (dán vào trong thẻ <style> hoặc file product_detail.css) ── --%>

            <%-- ── Tab content ── --%>
            <div id="pd-comment" class="pd-tab-pane">

                <%-- ── TOAST thông báo ── --%>
                <div id="reviewToast" class="review-toast"></div>

                <%-- ── Tóm tắt đánh giá ── --%>
                <c:choose>
                    <c:when test="${totalReviews > 0}">
                        <div class="review-summary">
                            <div>
                                <div class="review-avg-score"><fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/></div>
                                <div class="review-avg-stars">
                                    <c:forEach begin="1" end="5" var="s">
                                        <i class="fa${averageRating >= s ? 's' : 'r'} fa-star"></i>
                                    </c:forEach>
                                </div>
                                <div class="review-avg-count">${totalReviews} đánh giá</div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="color:var(--text-muted);font-size:14px;margin-bottom:16px;">
                            Chưa có đánh giá nào. Hãy là người đầu tiên chia sẻ cảm nhận!
                        </p>
                    </c:otherwise>
                </c:choose>

                <%-- ── Form viết đánh giá (chỉ hiện khi vào từ đơn hàng) ── --%>
                <c:if test="${showReviewForm}">
                    <c:choose>
                        <c:when test="${alreadyReviewed}">
                            <div class="already-reviewed-note">
                                <i class="fa fa-check-circle"></i>
                                Bạn đã đánh giá sản phẩm này trong đơn hàng này rồi.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="review-form-wrap">
                                <h4><i class="fa fa-star" style="color:#f5a623;"></i> Viết đánh giá của bạn</h4>
                                <form id="reviewForm" action="${pageContext.request.contextPath}/submit-review" method="post">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="hidden" name="orderId"   value="${reviewOrderId}">
                                    <input type="hidden" name="rating"    id="ratingInput" value="0">

                                    <div class="star-selector" id="starSelector">
                                        <i class="far fa-star" data-val="1"></i>
                                        <i class="far fa-star" data-val="2"></i>
                                        <i class="far fa-star" data-val="3"></i>
                                        <i class="far fa-star" data-val="4"></i>
                                        <i class="far fa-star" data-val="5"></i>
                                    </div>
                                    <div class="star-error" id="starError">Vui lòng chọn số sao.</div>

                                    <textarea class="review-textarea" name="comment"
                                              placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..." maxlength="1000"></textarea>

                                    <button type="submit" class="btn-submit-review">
                                        <i class="fa fa-paper-plane"></i> Gửi đánh giá
                                    </button>
                                </form>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <%-- ── Danh sách đánh giá thu gọn ── --%>
                <c:if test="${not empty topReviews}">
                    <div id="reviewsShort">
                        <c:forEach var="rv" items="${topReviews}">
                            <div class="review-card">
                                <div class="review-card-header">
                                    <span class="review-author">${rv.userName}</span>
                                    <span class="review-date">${rv.createdAtFormatted}</span>
                                </div>
                                <div class="review-stars">
                                    <c:forEach begin="1" end="5" var="s">
                                        <i class="fa${rv.rating >= s ? 's' : 'r'} fa-star${rv.rating < s ? ' empty' : ''}"></i>
                                    </c:forEach>
                                </div>
                                <c:if test="${not empty rv.comment}">
                                    <p class="review-text">${rv.comment}</p>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- Danh sách đầy đủ (ẩn ban đầu) --%>
                    <c:if test="${totalReviews > 5}">
                        <div id="reviewsFull" style="display:none;">
                            <c:forEach var="rv" items="${allReviews}">
                                <div class="review-card">
                                    <div class="review-card-header">
                                        <span class="review-author">${rv.userName}</span>
                                        <span class="review-date">${rv.createdAtFormatted}</span>
                                    </div>
                                    <div class="review-stars">
                                        <c:forEach begin="1" end="5" var="s">
                                            <i class="fa${rv.rating >= s ? 's' : 'r'} fa-star${rv.rating < s ? ' empty' : ''}"></i>
                                        </c:forEach>
                                    </div>
                                    <c:if test="${not empty rv.comment}">
                                        <p class="review-text">${rv.comment}</p>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>

                        <button class="btn-show-all" id="btnShowAll"
                                onclick="toggleAllReviews(this)">
                            Xem tất cả ${totalReviews} đánh giá <i class="fa fa-chevron-down"></i>
                        </button>
                    </c:if>
                </c:if>

            </div><%-- /#pd-comment --%>

            <%-- ── JavaScript ── --%>
            <script>
                /* ---- Chọn sao ---- */
                (function () {
                    var stars   = document.querySelectorAll('#starSelector i');
                    var input   = document.getElementById('ratingInput');
                    if (!stars.length) return;

                    function paint(val, cls) {
                        stars.forEach(function (s) {
                            var v = parseInt(s.dataset.val);
                            s.classList.toggle(cls, v <= val);
                        });
                    }

                    stars.forEach(function (s) {
                        s.addEventListener('mouseenter', function () {
                            paint(parseInt(s.dataset.val), 'hover');
                        });
                        s.addEventListener('mouseleave', function () {
                            paint(0, 'hover');
                        });
                        s.addEventListener('click', function () {
                            var val = parseInt(s.dataset.val);
                            input.value = val;
                            stars.forEach(function (x) {
                                var xv = parseInt(x.dataset.val);
                                x.classList.toggle('selected', xv <= val);
                                x.classList.remove('far');
                                x.classList.add(xv <= val ? 'fas' : 'far');
                            });
                            document.getElementById('starError').style.display = 'none';
                        });
                    });

                    /* Validate trước khi submit */
                    var form = document.getElementById('reviewForm');
                    if (form) {
                        form.addEventListener('submit', function (e) {
                            if (!input.value || input.value === '0') {
                                e.preventDefault();
                                document.getElementById('starError').style.display = 'block';
                            }
                        });
                    }
                })();

                /* ---- Toggle xem tất cả / thu gọn ---- */
                function toggleAllReviews(btn) {
                    var full  = document.getElementById('reviewsFull');
                    var short = document.getElementById('reviewsShort');
                    if (!full) return;
                    if (full.style.display === 'none') {
                        full.style.display  = 'block';
                        short.style.display = 'none';
                        btn.innerHTML = 'Thu gọn <i class="fa fa-chevron-up"></i>';
                    } else {
                        full.style.display  = 'none';
                        short.style.display = 'block';
                        btn.innerHTML = 'Xem tất cả <i class="fa fa-chevron-down"></i>';
                    }
                }

                /* ---- Toast thông báo từ redirect param ---- */
                (function () {
                    var params = new URLSearchParams(window.location.search);
                    var msg    = params.get('reviewMsg');
                    var toast  = document.getElementById('reviewToast');
                    if (!msg || !toast) return;

                    var texts = {
                        success: '✓ Đánh giá của bạn đã được gửi thành công!',
                        already: 'Bạn đã đánh giá sản phẩm này trong đơn hàng này rồi.',
                        error:   '✕ Có lỗi xảy ra. Vui lòng thử lại.'
                    };
                    var text = texts[msg];
                    if (!text) return;

                    toast.textContent = text;
                    if (msg === 'error') toast.classList.add('error');
                    toast.classList.add('show');

                    // Tự ẩn sau 4 giây
                    setTimeout(function () { toast.classList.remove('show'); }, 4000);

                    // Scroll tới tab bình luận nếu chưa active
                    if (msg === 'success' || msg === 'already') {
                        var commentTab = document.getElementById('pd-comment');
                        var tabBtn = document.querySelector('.pd-tab-btn:nth-child(2)');
                        if (commentTab && !commentTab.classList.contains('active')) {
                            document.querySelectorAll('.pd-tab-pane').forEach(function(p){ p.classList.remove('active'); });
                            document.querySelectorAll('.pd-tab-btn').forEach(function(b){ b.classList.remove('active'); });
                            commentTab.classList.add('active');
                            if (tabBtn) tabBtn.classList.add('active');
                        }
                    }
                })();
            </script>
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
