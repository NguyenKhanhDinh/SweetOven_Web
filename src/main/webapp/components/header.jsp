<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sweet Oven Bakery - Header</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
    />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
            rel="stylesheet"
    />

    <link rel="stylesheet" href="${contextPath}/components/css/header.css" />
</head>
<body>
<header>
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
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
          </form>
          <a href="${pageContext.request.contextPath}/cart.jsp" class="btn position-relative">
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
    </nav>
</header>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>