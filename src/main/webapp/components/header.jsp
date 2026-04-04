<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header>
  <nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/">
        <i class="fas fa-oven me-2"></i>
        Sweet Oven
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav mx-auto">
          <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/">TRANG CHỦ</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/menu">SẢN PHẨM</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/introduce">GIỚI THIỆU</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/contact">LIÊN HỆ</a>
          </li>
        </ul>
        <div class="nav-icons d-flex">
          <form action="${pageContext.request.contextPath}/menu" method="get" class="d-flex me-3">
            <input type="hidden" name="categoryId" value="${currentCategory != null ? currentCategory.id : ''}">
            <input type="hidden" name="sort" value="${sort != null ? sort : 'default'}">
            <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm..." value="${keyword != null ? keyword : ''}">
            <button class="btn" type="submit">
              <i class="fas fa-search"></i>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">

                <ul class="navbar-nav">
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

                <div class="nav-icons d-flex align-items-center">
                    <form action="${contextPath}/search.jsp" method="get" class="search-form me-4">
                        <input type="text" name="keyword" class="form-control rounded-pill" placeholder="Tìm kiếm...">
                        <button class="search-btn" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>

                    <a href="${contextPath}/my-cart.jsp" class="btn icon-action position-relative me-2">
                        <i class="fas fa-shopping-cart"></i>
                        <span id="cart-badge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill">
                        3
                    </span>
                    </a>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${contextPath}/profile.jsp" class="btn icon-action p-0 d-flex align-items-center justify-content-center" id="userIcon" title="Xin chào, ${sessionScope.user.fullName}" style="width: 40px; height: 40px; border-radius: 50%; overflow: hidden; border: 2px solid #D4A76A;">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar}">
                                        <img src="${contextPath}/${sessionScope.user.avatar}" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-circle" style="font-size: 24px; color: #8B4513;"></i>
                                    </c:otherwise>
                                </c:choose>

                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${contextPath}/login" class="btn icon-action" id="userIcon" title="Đăng nhập">
                                <i class="fas fa-user"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>
      </div>
    </div>
  </nav>
</header>