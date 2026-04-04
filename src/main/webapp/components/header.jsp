<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sweet Oven Bakery</title>

    <!-- Thư viện ngoài -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

    <!-- File CSS tổng hợp (Chứa phần Header và Footer CSS đã sửa) -->
    <link rel="stylesheet" href="${contextPath}/components/css/header.css"/>
</head>
<body>
<header>
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container-fluid px-4 px-lg-5">

            <!-- LOGO -->
            <a class="navbar-brand d-flex align-items-center" href="${contextPath}/">
                <i class="fas fa-fire-burner logo-icon"></i>
                <div class="brand-text d-flex flex-column">
                    <span class="brand-name">Sweet Oven</span>
                    <span class="slogan">Fresh baked daily</span>
                </div>
            </a>

            <!-- Nút Toggle cho Mobile -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Danh mục Menu (Sẽ căn giữa nhờ CSS) -->
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'home' ? 'active' : ''}" href="${contextPath}/">TRANG CHỦ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'menu' ? 'active' : ''}" href="${contextPath}/menu">SẢN PHẨM</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'introduce' ? 'active' : ''}" href="${contextPath}/introduce.jsp">GIỚI THIỆU</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'blog' ? 'active' : ''}" href="${contextPath}/blog.jsp">BLOG</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.activePage == 'contact' ? 'active' : ''}" href="${contextPath}/contact.jsp">LIÊN HỆ</a>
                    </li>
                </ul>

                <!-- Nhóm Icon: Tìm kiếm, Giỏ hàng, User -->
                <div class="nav-icons d-flex align-items-center">
                    <!-- Form tìm kiếm -->
                    <form action="${contextPath}/search.jsp" method="get" class="search-form me-3 d-none d-lg-flex">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm...">
                        <button class="search-btn" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>

                    <!-- Icon Giỏ hàng -->
                    <a href="${contextPath}/cart.jsp" class="btn icon-action position-relative me-3">
                        <i class="fas fa-shopping-cart"></i>
                        <span id="cart-badge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill">
                            3
                        </span>
                    </a>

                    <!-- Icon Thành viên / Avatar -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${contextPath}/profile.jsp" class="user-avatar-link" title="Xin chào, ${sessionScope.user.fullName}">
                                <div class="avatar-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.avatar}">
                                            <img src="${contextPath}/${sessionScope.user.avatar}" alt="Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user-circle"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
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
    </nav>
</header>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>