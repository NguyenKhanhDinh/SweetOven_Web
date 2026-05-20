<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven Bakery</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${contextPath}/components/css/header.css"/>
</head>
<body>
<header>
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container-fluid px-4 px-lg-5">

            <a class="navbar-brand d-flex align-items-center" href="${contextPath}/">
                <i class="fas fa-fire-burner logo-icon"></i>
                <div class="brand-text d-flex flex-column">
                    <span class="brand-name">Sweet Oven</span>
                    <span class="slogan">Fresh baked daily</span>
                </div>
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-4 me-auto">
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'home' ? 'active' : ''}" href="${contextPath}/">TRANG CHỦ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'menu' ? 'active' : ''}" href="${contextPath}/menu">SẢN PHẨM</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'introduce' ? 'active' : ''}" href="${contextPath}/introduce">GIỚI THIỆU</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'blog' ? 'active' : ''}" href="${contextPath}/blog.jsp">BLOG</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'contact' ? 'active' : ''}" href="${contextPath}/contact">LIÊN HỆ</a>
                    </li>
                </ul>

                <!-- Nhóm Icon: Tìm kiếm, Giỏ hàng, User -->
                <div class="nav-icons d-flex align-items-center">

                    <div id="search-wrapper" class="d-inline-block">
                        <button class="btn icon-action me-3" id="search-toggle">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>

                    <a href="${contextPath}my-cart" class="btn icon-action position-relative me-3" title="Giỏ hàng">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${sessionScope.cart.totalQuantity > 0}">
                            <span id="cart-badge"
                                  class="position-absolute top-0 start-100 translate-middle badge rounded-pill"
                                  style="display: inline-block;">
                                    ${sessionScope.cart.totalQuantity}
                            </span>
                        </c:if>
                    </a>

                    <!-- Icon Thành viên / Avatar -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <%-- Dùng class 'btn icon-action' của đồng nghiệp để đẹp, nhưng dùng logic Cloudinary của bạn --%>
                            <a href="${contextPath}/profile" class="btn icon-action d-flex align-items-center" title="Xin chào, ${sessionScope.user.fullName}">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar}">
                                        <c:choose>
                                            <%-- Logic Cloudinary của bạn --%>
                                            <c:when test="${sessionScope.user.avatar.startsWith('http')}">
                                                <img src="${sessionScope.user.avatar}" alt="Avatar" width="28" height="28" class="user-avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${contextPath}/${sessionScope.user.avatar}" alt="Avatar" width="28" height="28" class="user-avatar">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-circle fs-4"></i>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </c:when>

                        <c:otherwise>
                            <a href="${contextPath}/login" class="btn icon-action" title="Đăng nhập">
                                <i class="fas fa-user"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div id="search-dropdown" class="search-dropdown">
            <div class="container py-3">
                <form action="${contextPath}/search.jsp" method="get" class="search-form-full">
                    <input type="text" name="keyword" id="search-input" class="form-control" placeholder="Bạn muốn tìm bánh gì hôm nay?..." autocomplete="off">
                    <button type="submit" class="btn-submit-search">
                        <i class="fas fa-search me-2"></i> TÌM KIẾM
                    </button>
                </form>
            </div>
        </div>
    </nav>
</header>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchWrapper = document.getElementById('search-wrapper');
        const searchDropdown = document.getElementById('search-dropdown');
        const searchInput = document.getElementById('search-input');
        const searchToggle = document.getElementById('search-toggle');

        let timeout;
        let isPinned = false; // Biến kiểm tra xem có đang bấm để giữ hay không

        // Hàm hiện
        const showSearch = () => {
            clearTimeout(timeout);
            searchDropdown.classList.add('active');
            setTimeout(() => searchInput.focus(), 300);
        };

        // Hàm ẩn
        const hideSearch = () => {
            // Chỉ ẩn nếu không ở trạng thái "Pinned" (đã click)
            if (!isPinned) {
                timeout = setTimeout(() => {
                    searchDropdown.classList.remove('active');
                }, 300);
            }
        };

        // --- SỰ KIỆN HOVER ---
        searchWrapper.addEventListener('mouseenter', showSearch);
        searchWrapper.addEventListener('mouseleave', hideSearch);
        searchDropdown.addEventListener('mouseenter', () => clearTimeout(timeout));
        searchDropdown.addEventListener('mouseleave', hideSearch);

        // --- SỰ KIỆN CLICK (ĐỂ GIỮ CỐ ĐỊNH) ---
        searchToggle.addEventListener('click', function(e) {
            e.preventDefault();
            isPinned = !isPinned; // Đảo ngược trạng thái Pin

            if (isPinned) {
                searchDropdown.classList.add('active');
                searchToggle.classList.add('pinned'); // Thêm class để đổi màu icon nếu muốn
                searchInput.focus();
            } else {
                searchDropdown.classList.remove('active');
                searchToggle.classList.remove('pinned');
            }
        });

        // Đóng khi nhấn Esc hoặc Click ra ngoài (nếu đang Pin)
        document.addEventListener('click', function(e) {
            if (isPinned && !searchWrapper.contains(e.target) && !searchDropdown.contains(e.target)) {
                isPinned = false;
                searchDropdown.classList.remove('active');
                searchToggle.classList.remove('pinned');
            }
        });
    });
</script>
</body>
</html>