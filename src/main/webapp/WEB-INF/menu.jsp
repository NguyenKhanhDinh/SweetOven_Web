<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm | Sweet Oven Bakery</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/menu.css">

    <!-- Library -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="menu" />
</jsp:include>

<main class="main-content">
    <div class="container">
        <div class="row">

            <!-- SIDEBAR -->
            <aside class="col-lg-3">
                <div class="sidebar">
                    <div class="sidebar-category">
                        <h3>DANH MỤC</h3>
                        <ul class="category-list">
                            <li>
                                <a href="${pageContext.request.contextPath}/menu"
                                   class="${currentCategory == null ? 'active' : ''}">
                                    TẤT CẢ SẢN PHẨM
                                </a>
                            </li>

                            <c:forEach var="c" items="${categoryList}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/menu?categoryId=${c.id}"
                                       class="${currentCategory != null && currentCategory.id == c.id ? 'active' : ''}">
                                        ${c.name}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </aside>

            <!-- PRODUCTS -->
            <section class="col-lg-9 products-area">
                <div class="products-header">
                    <div class="section-title">
                        <h2>
                            ${currentCategory != null ? currentCategory.name : 'TẤT CẢ SẢN PHẨM'}
                        </h2>
                        <div class="results-count" id="results-count"></div>
                    </div>
                </div>

                <div class="products-grid">

                    <c:forEach var="p" items="${products}">
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
                                    <fmt:formatNumber value="${p.price}" /> VNĐ
                                </div>

                                <form action="${pageContext.request.contextPath}/add-cart">
                                    <input type="hidden" name="productId" value="${p.id}">
                                    <button class="btn-add-to-cart" ${p.stockQuantity <=0 ? 'disabled' : ''}>
                                        ${p.stockQuantity <= 0 ? 'Hết hàng' : 'Thêm vào giỏ'}
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </section>

        </div>
    </div>
</main>

<!-- Toast -->
<div class="toast-notification" id="toast">
    <i class="fas fa-check-circle"></i>
    <span id="toast-message"></span>
</div>

<jsp:include page="/components/footer.jsp" />

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/menu.js"></script>

</body>
</html>