<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
<link rel="stylesheet" href="${contextPath}/components/css/header.css"/>

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

                <div class="nav-icons d-flex align-items-center">
                    <div id="search-wrapper" class="d-inline-block">
                        <button class="btn icon-action me-3" id="search-toggle">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>

                    <a href="${contextPath}/my-cart" class="btn icon-action position-relative me-3" title="Giỏ hàng">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${sessionScope.cart.totalQuantity > 0}">
                            <span id="cart-badge"
                                  class="position-absolute top-0 start-100 translate-middle badge rounded-pill"
                                  style="display: inline-block;">
                                    ${sessionScope.cart.totalQuantity}
                            </span>
                        </c:if>
                    </a>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${contextPath}/profile" class="btn icon-action d-flex align-items-center" title="Xin chào, ${sessionScope.user.fullName}">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar}">
                                        <c:choose>
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
                <form action="${contextPath}/menu" method="get" class="search-form-full">
                    <div class="search-input-wrapper">
                        <i class="fas fa-search search-input-icon"></i>
                        <input type="text" name="keyword" id="search-input"
                               class="form-control search-input-field"
                               placeholder="Bạn muốn tìm bánh gì hôm nay?..."
                               autocomplete="off">
                        <div id="search-suggestions" class="search-suggestions-box"></div>
                    </div>
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
    document.addEventListener('DOMContentLoaded', function () {
        const searchWrapper  = document.getElementById('search-wrapper');
        const searchDropdown = document.getElementById('search-dropdown');
        const searchInput    = document.getElementById('search-input');
        const searchToggle   = document.getElementById('search-toggle');
        const suggestionsBox = document.getElementById('search-suggestions');
        const contextPath    = '${contextPath}';

        let closeTimer, debounceTimer, isPinned = false;

        const showSearch = () => { clearTimeout(closeTimer); searchDropdown.classList.add('active'); setTimeout(() => searchInput.focus(), 300); };
        const hideSearch = () => { if (!isPinned) { closeTimer = setTimeout(() => { searchDropdown.classList.remove('active'); hideSuggestions(); }, 300); } };

        searchWrapper.addEventListener('mouseenter', showSearch);
        searchWrapper.addEventListener('mouseleave', hideSearch);
        searchDropdown.addEventListener('mouseenter', () => clearTimeout(closeTimer));
        searchDropdown.addEventListener('mouseleave', hideSearch);

        searchToggle.addEventListener('click', function (e) {
            e.preventDefault();
            isPinned = !isPinned;
            isPinned ? (searchDropdown.classList.add('active'), searchToggle.classList.add('pinned'), searchInput.focus())
                : (searchDropdown.classList.remove('active'), searchToggle.classList.remove('pinned'), hideSuggestions());
        });

        document.addEventListener('click', function (e) {
            if (isPinned && !searchWrapper.contains(e.target) && !searchDropdown.contains(e.target)) {
                isPinned = false;
                searchDropdown.classList.remove('active');
                searchToggle.classList.remove('pinned');
                hideSuggestions();
            }
        });

        function hideSuggestions() {
            suggestionsBox.classList.remove('open');
            suggestionsBox.innerHTML = '';
        }

        function formatPrice(price) {
            if (!price) return '';
            return Number(price).toLocaleString('vi-VN') + '₫';
        }

        // Đánh dấu khi người dùng đang click vào suggestion để tránh blur ẩn mất
        let isClickingSuggestion = false;
        suggestionsBox.addEventListener('mousedown', function () { isClickingSuggestion = true; });
        suggestionsBox.addEventListener('mouseup',   function () { isClickingSuggestion = false; });

        function escapeHtml(str) {
            return String(str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;');
        }

        function renderSuggestions(products) {
            if (!products || products.length === 0) {
                suggestionsBox.innerHTML = '<div class="suggest-empty"><i class="fas fa-search-minus me-2"></i>Không tìm thấy sản phẩm</div>';
                suggestionsBox.classList.add('open');
                return;
            }
            suggestionsBox.innerHTML = products.map(function(p) {
                var imgSrc = p.image
                    ? (p.image.startsWith('http') ? p.image : contextPath + '/' + p.image)
                    : contextPath + '/assets/picture/logo.png';
                var hasDiscount = p.discountPrice && Number(p.discountPrice) > 0;
                var priceHtml = hasDiscount
                    ? '<span class="suggest-price">' + formatPrice(p.discountPrice) + '</span>'
                    + '<span class="suggest-price-original">' + formatPrice(p.originalPrice) + '</span>'
                    : '<span class="suggest-price">' + formatPrice(p.originalPrice) + '</span>';
                return '<a href="' + contextPath + '/product?id=' + p.id + '" class="suggest-item">'
                    + '<div class="suggest-img-wrap">'
                    + '<img src="' + imgSrc + '" alt="' + escapeHtml(p.name) + '" class="suggest-img" loading="lazy"'
                    + ' onerror="this.src=\'' + contextPath + '/assets/picture/logo.png\'">'
                    + '</div>'
                    + '<div class="suggest-info">'
                    + '<div class="suggest-name">' + escapeHtml(p.name) + '</div>'
                    + '<div class="suggest-price-wrap">' + priceHtml + '</div>'
                    + '</div>'
                    + '<i class="fas fa-chevron-right suggest-arrow"></i>'
                    + '</a>';
            }).join('');
            suggestionsBox.classList.add('open');
        }

        searchInput.addEventListener('input', function () {
            var keyword = this.value.trim();
            clearTimeout(debounceTimer);
            if (keyword.length < 2) { hideSuggestions(); return; }
            suggestionsBox.innerHTML = '<div class="suggest-loading"><span class="spinner"></span> Đang tìm kiếm...</div>';
            suggestionsBox.classList.add('open');
            debounceTimer = setTimeout(function() {
                fetch(contextPath + '/search-suggestions?keyword=' + encodeURIComponent(keyword))
                    .then(function(res) { return res.json(); })
                    .then(function(data) { renderSuggestions(data); })
                    .catch(function() { hideSuggestions(); });
            }, 300);
        });

        searchInput.addEventListener('blur', function () {
            if (!isClickingSuggestion) {
                setTimeout(hideSuggestions, 200);
            }
        });

        document.addEventListener('keydown', e => {
            if (e.key === 'Escape') {
                hideSuggestions();
                if (isPinned) { isPinned = false; searchDropdown.classList.remove('active'); searchToggle.classList.remove('pinned'); }
            }
        });
    });
</script>