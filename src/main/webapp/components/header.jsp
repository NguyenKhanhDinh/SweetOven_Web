<%@ page contentType="text/html; charset=UTF-8" %>
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