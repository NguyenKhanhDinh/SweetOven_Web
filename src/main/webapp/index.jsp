<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="/components/header.jsp" %>

<div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel">
    <div class="carousel-inner">
        <c:forEach var="b" items="${banners}" varStatus="st">
            <div class="carousel-item ${st.first ? 'active' : ''}"
                 style="background-image: url('${pageContext.request.contextPath}${b.bannerImageUrl}')">

                <div class="carousel-content text-center text-white">
                    <h1>${b.title}</h1>
                    <p>${b.description}</p>
                    <a href="menu" class="btn btn-primary">Khám phá ngay</a>
                </div>

            </div>
        </c:forEach>
    </div>
</div>

<section class="container mt-5">
    <h2>Sản phẩm nổi bật</h2>

    <div class="row">
        <c:forEach var="p" items="${featuredProducts}">
            <div class="col-md-3">
                <div class="product-card" onclick="goToProductDetail(${p.id})">
                    <img src="${p.image}" class="img-fluid">
                    <h5>${p.name}</h5>
                    <p><fmt:formatNumber value="${p.price}" /> VNĐ</p>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<%@ include file="/components/footer.jsp" %>