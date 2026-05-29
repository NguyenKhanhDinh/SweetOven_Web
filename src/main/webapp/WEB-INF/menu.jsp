<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="contextPath" content="${pageContext.request.contextPath}">
    <title>Sản phẩm | Sweet Oven Bakery</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/menu.css">

    <!-- Google Font: Quicksand (đồng bộ với login/register) -->
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

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

            <aside class="col-lg-3">
                <div class="sidebar">
                    <div class="sidebar-category">
                        <h3>DANH MỤC</h3>
                        <ul class="category-list">
                            <li>
                                <a href="${pageContext.request.contextPath}/menu?categoryId=&keyword=${keyword != null ? keyword : ''}&sort=${sort != null ? sort : 'default'}"
                                   class="${currentCategory == null ? 'active' : ''}">TẤT CẢ SẢN
                                    PHẨM</a>
                            </li>
                            <c:forEach var="c" items="${categoryList}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/menu?categoryId=${c.id}&keyword=${keyword != null ? keyword : ''}&sort=${sort != null ? sort : 'default'}"
                                       class="${currentCategory != null && currentCategory.id == c.id ? 'active' : ''}">
                                            ${c.name.toUpperCase()}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </aside>


            <section class="col-lg-9 products-area">
                <div class="products-header">
                    <div class="section-title">
                        <h2 id="category-title">TẤT CẢ SẢN PHẨM</h2>
                        <div class="results-count" id="results-count"></div>
                    </div>
                    <div class="filter-section">
                        <div class="price-filter">
                            <form action="${pageContext.request.contextPath}/menu" method="get">
                                <input type="hidden" name="keyword"
                                       value="${keyword != null ? keyword : ''}">
                                <input type="hidden" name="categoryId"
                                       value="${currentCategory != null ? currentCategory.id : ''}">
                                <select name="sort" class="form-select" onchange="this.form.submit()">
                                    <option value="default" ${sort == null || sort == 'default' ? 'selected' : ''}>Mặc định</option>
                                    <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá: Thấp → Cao</option>
                                    <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá: Cao → Thấp</option>
                                    <option value="name_asc" ${sort == 'name_asc' ? 'selected' : ''}>Tên: A → Z</option>
                                    <option value="name_desc" ${sort == 'name_desc' ? 'selected' : ''}>Tên: Z → A</option>
                                </select>
                            </form>

                        </div>
                    </div>
                </div>

                <div id="products-container">
                    <div class="products-grid">

                        <c:forEach var="p" items="${products}">

                            <div class="product-card" data-product-id="${p.id}" data-name="${p.name}"
                                 data-price="${p.displayPrice}" data-category="${p.categoryId}">
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
                                        <c:choose>
                                            <c:when test="${p.discountPrice != null && p.discountPrice > 0}">
                                                <span class="price-original">
                                                    <fmt:formatNumber value="${p.originalPrice}" type="number" /> VNĐ
                                                </span>
                                                <span class="price-sale">
                                                    <fmt:formatNumber value="${p.discountPrice}" type="number" /> VNĐ
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="price-normal">
                                                    <fmt:formatNumber value="${p.originalPrice}" type="number" /> VNĐ
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <form method="get"
                                          action="${pageContext.request.contextPath}/add-cart">
                                        <input type="hidden" name="productId" value="${p.id}">
                                        <input type="hidden" name="quantity" value="1">
                                        <input type="hidden" name="returnUrl"
                                               value="${pageContext.request.contextPath}/menu">
                                        <button type="submit" class="btn-add-to-cart" ${p.stockQuantity
                                                <=0 ? 'disabled' : '' }>
                                            <c:choose>
                                                <c:when test="${p.stockQuantity <= 0}">Hết hàng</c:when>
                                                <c:otherwise>Thêm vào giỏ</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>

                                </div>
                            </div>
                        </c:forEach>


                    </div>


                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">

                            <!-- PREV -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/menu?page=${currentPage - 1}&keyword=${keyword != null ? keyword : ''}&sort=${sort != null ? sort : ''}&categoryId=${currentCategory != null ? currentCategory.id : ''}">
                                    «
                                </a>
                            </li>

                            <!-- PAGE NUMBERS -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/menu?page=${i}&keyword=${keyword != null ? keyword : ''}&sort=${sort != null ? sort : ''}&categoryId=${currentCategory != null ? currentCategory.id : ''}">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <!-- NEXT -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/menu?page=${currentPage + 1}&keyword=${keyword != null ? keyword : ''}&sort=${sort != null ? sort : ''}&categoryId=${currentCategory != null ? currentCategory.id : ''}">
                                    »
                                </a>
                            </li>

                        </ul>
                    </nav>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="/components/footer.jsp" />

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/menu.js"></script>

</body>
</html>