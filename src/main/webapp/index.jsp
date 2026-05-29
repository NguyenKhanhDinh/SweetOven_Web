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
              <a href="menu" class="btn btn-primary-custom">Khám phá ngay</a>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>

<section class="categories-modern-section">
    <div class="container">

        <div class="categories-header">
            <span class="categories-subtitle">DANH MỤC</span>
            <h2>Khám phá danh mục</h2>
        </div>

        <div class="categories-modern-grid">

            <c:forEach var="c" items="${categories}">

                <a href="menu?categoryId=${c.id}" class="category-modern-card">

                    <div class="category-modern-image">
                        <img src="${c.thumbnail}" alt="${c.name}">
                    </div>

                    <div class="category-modern-content">
                        <h3>${c.name}</h3>
                        <p>${c.productCount} sản phẩm</p>
                    </div>

                </a>

            </c:forEach>

        </div>

    </div>
</section>
    <section class="flash-sale-section">
      <div class="container">
        <div class="flash-sale-header">
          <div class="flash-sale-title">
            <div class="flash-badge"><i class="fas fa-bolt me-1"></i> FLASH SALE</div>
            <h2 style="margin: 0; color: var(--primary);">Siêu ưu đãi giới hạn</h2>
          </div>
          <div class="countdown-timer" id="flashSaleTimer">
            <div class="countdown-unit"><div class="countdown-number" id="days">00</div><div class="countdown-label">Ngày</div></div>
            <div class="countdown-unit"><div class="countdown-number" id="hours">00</div><div class="countdown-label">Giờ</div></div>
            <div class="countdown-unit"><div class="countdown-number" id="minutes">00</div><div class="countdown-label">Phút</div></div>
            <div class="countdown-unit"><div class="countdown-number" id="seconds">00</div><div class="countdown-label">Giây</div></div>
          </div>
        </div>

        <div class="row g-4">
          <c:forEach var="p" items="${featuredProducts}" varStatus="st">
            <c:if test="${st.index < 4}">
              <div class="col-lg-3 col-md-6">
                <div class="flash-product-card">
                  <div class="discount-badge">-${20 - st.index * 5}%</div>
                  <div class="product-image-wrapper">
                    <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                      <img src="${p.image}" alt="${p.name}">
                    </a>
                    <div class="product-actions">
                      <button class="quick-view-btn" onclick="quickView('${p.id}')"><i class="fas fa-eye"></i></button>
                      <button class="quick-view-btn btn-add-to-cart-flash" data-product-id="${p.id}"><i class="fas fa-shopping-cart"></i></button>
                    </div>
                  </div>
                  <div class="product-info">
                    <h5>${p.name}</h5>
                    <div class="product-price"><span class="old-price"><fmt:formatNumber value="${p.displayPrice * 1.2}" type="number" />đ</span> <span class="new-price"><fmt:formatNumber value="${p.displayPrice}" type="number" />đ</span></div>
                  </div>
                </div>
              </div>
            </c:if>
          </c:forEach>
        </div>
      </div>
    </section>

    <section class="featured-products-section">
      <div class="container">
              <div class="categories-header">
                  <span class="categories-subtitle">Những chiếc bánh được yêu thích nhất tại Sweet Oven Bakery</span>
                  <h2>Sản phẩm nổi bậc</h2>
              </div>

        <div class="row g-4">
          <c:forEach var="p" items="${featuredProducts}">
            <div class="col-md-6 col-lg-4 col-xl-3">
              <div class="product-card-modern">
                <c:if test="${p.stockQuantity <= 0}"><div class="product-badge">Hết hàng</div></c:if>
                <c:if test="${p.stockQuantity > 0 && p.stockQuantity < 10}"><div class="product-badge-sale">Sắp hết</div></c:if>
                <div class="product-image-wrapper">
                  <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                    <img src="${p.image}" alt="${p.name}">
                  </a>
                  <div class="product-actions">
                    <button class="quick-view-btn" onclick="quickView('${p.id}')"><i class="fas fa-eye"></i></button>
                    <button type="button" class="quick-view-btn btn-add-to-cart" data-product-id="${p.id}" ${p.stockQuantity <= 0 ? 'disabled' : ''}>
                      <i class="fas fa-shopping-cart"></i>
                    </button>
                  </div>
                </div>
                <div class="product-info">
                  <h5>${p.name}</h5>
                  <div class="product-price"><fmt:formatNumber value="${p.displayPrice}" type="number" /> VNĐ</div>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>

        <div class="text-center mt-5">
          <a href="menu" class="btn-view-all"><i class="fas fa-store me-2"></i> Xem Tất Cả Sản Phẩm <i class="fas fa-arrow-right ms-2"></i></a>
        </div>
      </div>
    </section>

    <div class="container">
      <div class="mid-banner">
        <div class="row align-items-center">
          <div class="col-lg-7">
            <div class="mid-banner-content">
              <span class="mid-banner-tag"> ƯU ĐÃI ĐẶC BIỆT</span>
              <h3>Nhận ngay <span style="color: var(--accent);">20%</span> giảm giá</h3>
              <p>Cho đơn hàng đầu tiên khi đăng ký thành viên. Không giới hạn số lượng!</p>
              <a href="register" class="btn-outline-light">Đăng ký ngay <i class="fas fa-arrow-right ms-2"></i></a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <section class="promotions-grid-section">
      <div class="container">
             <div class="categories-header">
                  <span class="categories-subtitle">Lưu ngay các mã giảm giá hấp dẫn cho đơn hàng của bạn</span>
                  <h2>Mã Giảm Giá</h2>
              </div>

        <div class="promo-grid">
          <c:forEach var="d" items="${discounts}">
            <div class="promo-card-luxury">
              <div class="promo-icon"><i class="fas ${d.discountType == 1 ? 'fa-percent' : 'fa-hand-holding-usd'}"></i></div>
              <div class="promo-discount">
                <c:choose>
                  <c:when test="${d.discountType == 1}"><fmt:formatNumber value="${d.value}" maxFractionDigits="0" />%</c:when>
                  <c:otherwise><fmt:formatNumber value="${d.value}" type="number" groupingUsed="true" maxFractionDigits="0" /> VNĐ</c:otherwise>
                </c:choose>
              </div>
              <h4><c:choose><c:when test="${d.discountType == 1}">Ưu Đãi Đặc Biệt</c:when><c:otherwise>Giảm Trực Tiếp</c:otherwise></c:choose></h4>
              <p>Cho đơn hàng từ <fmt:formatNumber value="${d.minValueOrder}" type="number" groupingUsed="true" maxFractionDigits="0" />đ</p>
              <div class="promo-code-copy" data-code="${d.code}"><i class="fas fa-tag"></i> ${d.code} <i class="fas fa-copy copy-icon"></i></div>
              <p class="promo-condition small">HSD: ${d.formattedEndDate}</p>
            </div>
          </c:forEach>
          <c:if test="${empty discounts}"><div class="col-12 text-center text-white"><p>Hiện tại chưa có mã giảm giá nào</p></div></c:if>
        </div>

        <div class="text-center mt-5">
          <a href="${pageContext.request.contextPath}/vouchers" class="btn-view-all btn-outline-white"><i class="fas fa-ticket-alt me-2"></i> Xem Tất Cả Mã Giảm Giá <i class="fas fa-arrow-right ms-2"></i></a>
        </div>
      </div>
    </section>

    <section class="reviews-enhanced-section">
      <div class="container">
             <div class="categories-header">
                  <span class="categories-subtitle">Những phản hồi chân thành là động lực để chúng tôi hoàn thiện hơn mỗi ngày</span>
                  <h2>Khách Hàng Nói Gì Về Chúng Tôi?</h2>
              </div>

        <div class="row g-4">
          <c:forEach var="fb" items="${feedbacks}">
            <div class="col-md-6 col-lg-4">
              <div class="review-card-enhanced">
                <div class="quote-icon">"</div>
                <div class="review-avatar"><i class="fas fa-user"></i></div>
                <div class="review-user-info"><h5>${fb.fullName}</h5><small>${fb.email}</small></div>
                <div class="rating-simple mb-2"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></div>
                <p class="review-content-simple">"${fb.content}"</p>
                <small class="text-muted"><i class="far fa-calendar-alt"></i> ${fb.createdAt}</small>
              </div>
            </div>
          </c:forEach>
          <c:if test="${empty feedbacks}"><div class="col-12 text-center"><div class="empty-reviews"><i class="fas fa-comment-dots fa-3x"></i><p>Chưa có đánh giá nào</p></div></div></c:if>
        </div>
      </div>
    </section>

    <section class="statistics-section">
      <div class="container">
        <div class="row">
          <div class="col-md-4"><div class="statistics-item"><span class="statistics-number">+120</span><div class="statistics-text">LOẠI BÁNH</div></div></div>
          <div class="col-md-4"><div class="statistics-item"><span class="statistics-number">+1000</span><div class="statistics-text">KHÁCH HÀNG MỖI NGÀY</div></div></div>
          <div class="col-md-4"><div class="statistics-item"><span class="statistics-number">+4</span><div class="statistics-text">NĂM KINH NGHIỆM</div></div></div>
        </div>
      </div>
    </section>
  </main>

  <%@ include file="/components/footer.jsp" %>

  <div class="toast-container-custom" id="toastContainer"></div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

  <script>
    function startFlashSaleCountdown() {
      var targetDate = new Date(); targetDate.setDate(targetDate.getDate() + 3); targetDate.setHours(23,59,59,999);
      function update() { var d = targetDate - new Date(); var days=Math.floor(d/(86400000)), hours=Math.floor((d%86400000)/3600000), mins=Math.floor((d%3600000)/60000), secs=Math.floor((d%60000)/1000); document.getElementById('days')&&(document.getElementById('days').innerHTML=String(days).padStart(2,'0')); document.getElementById('hours')&&(document.getElementById('hours').innerHTML=String(hours).padStart(2,'0')); document.getElementById('minutes')&&(document.getElementById('minutes').innerHTML=String(mins).padStart(2,'0')); document.getElementById('seconds')&&(document.getElementById('seconds').innerHTML=String(secs).padStart(2,'0')); if(d<0) clearInterval(interval); }
      update(); var interval = setInterval(update,1000);
    }
    startFlashSaleCountdown();

    function showToast(type, msg) { var c=document.getElementById('toastContainer'); var id='t'+Date.now(); var html='<div id="'+id+'" class="toast align-items-center '+(type==='success'?'bg-success':'bg-danger')+' text-white border-0 mb-2"><div class="d-flex"><div class="toast-body"><i class="fas '+(type==='success'?'fa-check-circle':'fa-exclamation-circle')+' me-2"></i>'+msg+'</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div></div>'; c.insertAdjacentHTML('beforeend',html); var el=document.getElementById(id); var t=new bootstrap.Toast(el,{delay:3000}); t.show(); el.addEventListener('hidden.bs.toast',function(){el.remove();}); }
    window.showGlobalToast = showToast;

    // Add to cart
    function addToCartAsync(pid, qty, btn) { if(!pid) return; var orig=btn.innerHTML; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i>'; btn.disabled=true; var ctx=document.querySelector('meta[name="contextPath"]').content; fetch(ctx+'/add-cart',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'productId='+encodeURIComponent(pid)+'&quantity='+(qty||1)}).then(r=>r.json()).then(d=>{if(d.success){btn.innerHTML='<i class="fas fa-check"></i>'; showToast('success',d.message); updateCartBadge(d.cartTotalQuantity); setTimeout(()=>{btn.innerHTML=orig; btn.disabled=false;},1500);}else{btn.innerHTML='<i class="fas fa-exclamation-triangle"></i>'; showToast('error',d.message||'Lỗi'); setTimeout(()=>{btn.innerHTML=orig; btn.disabled=false;},1500);}}).catch(e=>{btn.innerHTML='<i class="fas fa-exclamation-triangle"></i>'; showToast('error','Có lỗi xảy ra'); setTimeout(()=>{btn.innerHTML=orig; btn.disabled=false;},1500);}); }
    function updateCartBadge(q){ var b=document.getElementById('cart-badge'); if(b){ if(q>0){ b.textContent=q; b.style.display='inline-block'; }else{ b.style.display='none'; } } }

    // Quick view
    function quickView(pid){ var ctx=document.querySelector('meta[name="contextPath"]').content; fetch(ctx+'/product-detail?ajax=true&id='+pid).then(r=>r.json()).then(p=>{ showToast('info','Đang phát triển: '+p.name); }); }

    // Copy code
    function initCopyCode(){ document.querySelectorAll('.promo-code-copy').forEach(el=>{ el.addEventListener('click',function(){ var code=this.dataset.code; if(code){ navigator.clipboard.writeText(code).then(()=>{ showToast('success','Đã copy: '+code); var html=this.innerHTML; this.innerHTML='<i class="fas fa-check"></i> Đã copy!'; setTimeout(()=>{this.innerHTML=html;},2000); }); } }); }); }

    // Back to top
    function initBackToTop(){ var btn=document.createElement('button'); btn.className='btn-back-top'; btn.innerHTML='<i class="fas fa-arrow-up"></i>'; document.body.appendChild(btn); window.addEventListener('scroll',function(){ if(window.scrollY>300) btn.classList.add('show'); else btn.classList.remove('show'); }); btn.addEventListener('click',function(){ window.scrollTo({top:0,behavior:'smooth'}); }); }

    // Event binding
    document.addEventListener('DOMContentLoaded',function(){ initBackToTop(); initCopyCode(); var carousel=document.querySelector('#heroCarousel'); if(carousel) new bootstrap.Carousel(carousel,{interval:5000,ride:'carousel'}); document.querySelectorAll('.btn-add-to-cart[data-product-id]').forEach(btn=>{ btn.addEventListener('click',function(e){ e.stopPropagation(); addToCartAsync(this.dataset.productId,1,this); }); }); document.querySelectorAll('.btn-add-to-cart-flash[data-product-id]').forEach(btn=>{ btn.addEventListener('click',function(e){ e.stopPropagation(); addToCartAsync(this.dataset.productId,1,this); }); }); });
  </script>
</body>
</html>