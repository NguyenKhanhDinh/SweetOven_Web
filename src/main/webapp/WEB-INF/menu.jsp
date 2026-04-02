<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm | Sweet Oven Bakery</title>
    <meta name="description" content="Khám phá các sản phẩm bánh ngọt & đồ nướng tại Sweet Oven Bakery" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">


    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --primary: #8B4513;
            --secondary: #D4A76A;
            --light: #FFF9F0;
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        .main-content {
            min-height: auto;
            padding-top: 80px;
        }


        .sidebar {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: var(--shadow);
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .sidebar-category h3 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            font-weight: 600;
            border-bottom: 2px solid var(--secondary);
            padding-bottom: 0.5rem;
        }

        .category-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .category-list li {
            margin-bottom: 0.8rem;
        }

        .category-list a {
            text-decoration: none;
            color: var(--primary);
            padding: 0.8rem 1rem;
            display: block;
            border-radius: 10px;
            font-size: 1rem;
            transition: var(--transition);
            font-weight: 500;
        }

        .category-list a:hover,
        .category-list a.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            transform: translateX(5px);
        }


        .products-area {
            padding-left: 2rem;
        }

        .products-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .section-title h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 0;
        }

        .results-count {
            color: var(--primary);
            font-size: 0.9rem;
        }

        .filter-section {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .price-filter select {
            padding: 0.6rem 1rem;
            border: 2px solid var(--secondary);
            border-radius: 10px;
            background: white;
            color: var(--primary);
            font-weight: 500;
        }


        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
            min-height: 400px;
        }

        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: var(--transition);
            height: 380px;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(139, 69, 19, 0.1);
            cursor: pointer;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .product-img {
            height: 200px;
            overflow: hidden;
            position: relative;
        }

        .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }

        .product-card:hover .product-img img {
            transform: scale(1.05);
        }

        .product-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background: #FF6B6B;
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            z-index: 2;
        }

        .product-content {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            justify-content: space-between;
        }

        .product-content h3 {
            font-size: 1.1rem;
            margin-bottom: 0.8rem;
            font-weight: 600;
            color: var(--primary);
            display: -webkit-box;
            line-clamp: 2;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.4;
            min-height: 3rem;
        }

        .product-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .btn-add-to-cart {
            background: linear-gradient(135deg, var(--primary), #A0522D);
            color: white;
            border: none;
            width: 100%;
            padding: 0.8rem;
            border-radius: 12px;
            font-weight: 600;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            z-index: 3;
            position: relative;
        }

        .btn-add-to-cart:hover {
            background: linear-gradient(135deg, var(--secondary), #E6B17E);
            color: var(--primary);
            transform: translateY(-2px);
        }

        .product-link-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            cursor: pointer;
        }

        .product-template {
            display: none;
        }


        .pagination {
            margin-top: 3rem;
            justify-content: center;
        }

        .page-link {
            color: var(--primary);
            border: 1px solid var(--secondary);
            padding: 0.5rem 1rem;
        }

        .page-link:hover {
            background: var(--secondary);
            color: white;
            border-color: var(--secondary);
        }

        .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
        }


        .loading {
            text-align: center;
            padding: 2rem;
            color: var(--primary);
        }

        .loading-spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        .no-results {
            text-align: center;
            padding: 3rem;
            color: var(--primary);
        }

        .no-results i {
            font-size: 3rem;
            color: var(--secondary);
            margin-bottom: 1rem;
        }

        .toast-notification {
            position: fixed;
            top: 100px;
            right: 20px;
            background: var(--primary);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            z-index: 9999;
            transform: translateX(400px);
            transition: transform 0.3s ease;
        }
        .pagination {
            gap: 5px;
        }

        .page-link {
            border-radius: 8px;
            transition: 0.3s;
            font-weight: 500;
        }

        .page-link:hover {
            transform: translateY(-2px);
        }

        .page-item.active .page-link {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            color: white;
        }

        .page-item.disabled .page-link {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .toast-notification.show {
            transform: translateX(0);
        }

        @media (max-width: 768px) {
            .navbar .container {
                padding: 0 1rem !important;
            }

            .products-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 1.5rem;
            }

            .products-area {
                padding-left: 0;
            }

            .toast-notification {
                top: 80px;
                right: 10px;
                left: 10px;
            }
        }
    </style>
</head>

<body>
<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="menu" /> </jsp:include>

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
                            <c:forEach var="c" items="${categories}">
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
                                    <option value="default" ${sort==null || sort=='default' ? 'selected'
                                            : '' }>Mặc định</option>
                                    <option value="price_asc" ${sort=='price_asc' ? 'selected' : '' }>
                                        Giá: Thấp → Cao</option>
                                    <option value="price_desc" ${sort=='price_desc' ? 'selected' : '' }>
                                        Giá: Cao → Thấp</option>
                                    <option value="name_asc" ${sort=='name_asc' ? 'selected' : '' }>Tên:
                                        A → Z</option>
                                    <option value="name_desc" ${sort=='name_desc' ? 'selected' : '' }>
                                        Tên: Z → A</option>
                                </select>
                            </form>

                        </div>
                    </div>
                </div>

                <div id="products-container">
                    <div class="products-grid">

                        <c:forEach var="p" items="${products}">

                            <div class="product-card" data-product-id="${p.id}" data-name="${p.name}"
                                 data-price="${p.price}" data-category="${p.categoryId}">
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
                                   href="${pageContext.request.contextPath}/menu?page=${currentPage - 1}&keyword=${keyword}&sort=${sort}">
                                    «
                                </a>
                            </li>


                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/menu?page=${i}&keyword=${keyword}&sort=${sort}">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/menu?page=${currentPage + 1}&keyword=${keyword}&sort=${sort}">
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

<div class="toast-notification" id="toast">
    <div class="d-flex align-items-center">
        <i class="fas fa-check-circle me-2"></i>
        <span id="toast-message">Đã thêm vào giỏ hàng!</span>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let currentPage = 1;
    let currentCategory = 'all';
    let currentSort = 'default';

    // Get all product cards from the DOM
    function getAllProducts() {
        const productsGrid = document.querySelector('.products-grid');
        if (!productsGrid) return [];
        return Array.from(productsGrid.querySelectorAll('.product-card'));
    }
    function showEmptyState(container) {
        const existingEmptyState = container.querySelector('.no-results');
        if (existingEmptyState) {
            existingEmptyState.remove();
        }

        const noResultsDiv = document.createElement('div');
        noResultsDiv.className = 'no-results';

        const icon = document.createElement('i');
        icon.className = 'fas fa-search';

        const heading = document.createElement('h4');
        heading.textContent = 'Không tìm thấy sản phẩm nào';

        const paragraph = document.createElement('p');
        paragraph.textContent = 'Hãy thử tìm kiếm với danh mục khác';

        noResultsDiv.appendChild(icon);
        noResultsDiv.appendChild(heading);
        noResultsDiv.appendChild(paragraph);
        container.appendChild(noResultsDiv);
    }

    function updateResultsCount(count) {
        const resultsCount = document.getElementById('results-count');
        resultsCount.textContent = count + ' sản phẩm';
    }


    function goToProductDetail(productId) {
        sessionStorage.setItem('selectedProductId', productId);
        window.location.href = '${pageContext.request.contextPath}/product?id=' + productId;
    }

    // Hiển thị toast nếu có thông báo từ session
    window.onload = function () {
        const message = "${sessionScope.message}";
        const error = "${sessionScope.error}";

        if (message || error) {
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toast-message');
            const toastIcon = toast.querySelector('i');

            if (error) {
                toast.style.background = '#e74c3c'; // Màu đỏ cho lỗi
                toastIcon.className = 'fas fa-exclamation-circle me-2';
                toastMessage.textContent = error;
            } else {
                toast.style.background = 'var(--primary)'; // Màu chính cho thành công
                toastIcon.className = 'fas fa-check-circle me-2';
                toastMessage.textContent = message;
            }

            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);

            // Xóa session attribute sau khi hiển thị
            <% session.removeAttribute("message"); %>
            <% session.removeAttribute("error"); %>
        }
    };



</script>
</body>

</html>
