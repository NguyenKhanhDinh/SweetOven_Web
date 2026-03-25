<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header>
  <nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
      <a class="navbar-brand" href="/">
        <i class="fas fa-oven me-2"></i>
        Sweet Oven
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav mx-auto">
          <li class="nav-item">
            <a class="nav-link active" href="/">TRANG CHỦ</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="menu">SẢN PHẨM</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="introduce">GIỚI THIỆU</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="contact">LIÊN HỆ</a>
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
          </form>
          <a href="my-cart" class="btn position-relative">
            <i class="fas fa-shopping-cart"></i>
            <c:if test="${sessionScope.cart != null && sessionScope.cart.totalItems > 0}">
              <span id="cart-badge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                ${sessionScope.cart.totalItems}
              </span>
            </c:if>
          </a>
          <a href="${pageContext.request.contextPath}/profile" class="btn user-icon" id="userIcon">
            <i class="fas fa-user"></i>
          </a>
        </div>
      </div>
    </div>
  </nav>
</header>