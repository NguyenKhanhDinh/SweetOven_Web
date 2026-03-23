<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sweet Oven Bakery</title>

    <!-- CSS -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- QUAN TRỌNG -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>

<body>

<header>
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-oven me-2"></i> Sweet Oven
            </a>

            <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/">TRANG CHỦ</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/menu">SẢN PHẨM</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/introduce">GIỚI THIỆU</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact">LIÊN HỆ</a></li>
                </ul>

                <div class="nav-icons d-flex">
                    <a href="${pageContext.request.contextPath}/my-cart" class="btn">
                        <i class="fas fa-shopping-cart"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/profile" class="btn">
                        <i class="fas fa-user"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>
</header>

<main>