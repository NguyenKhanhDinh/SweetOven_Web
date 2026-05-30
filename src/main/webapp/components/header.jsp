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
                    <li class="nav-item nav-item-dropdown" id="category-nav-item">
                        <a class="nav-link ${param.activePage == 'menu' ? 'active' : ''}"
                           href="${contextPath}/menu"
                           id="category-nav-link"
                           aria-haspopup="true"
                           aria-expanded="false">
                           SẢN PHẨM
                            <i class="fas fa-chevron-down nav-chevron" id="category-chevron"></i>
                        </a>
                        <div class="category-dropdown" id="category-dropdown" role="menu">
                            <ul class="category-dropdown-list">
                                <li class="category-dropdown-item skeleton" aria-hidden="true"></li>
                                <li class="category-dropdown-item skeleton" aria-hidden="true"></li>
                                <li class="category-dropdown-item skeleton" aria-hidden="true"></li>
                            </ul>
                        </div>
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
                    <div class="nav-phone me-3 d-none d-lg-flex flex-column align-items-center">
                        <span class="nav-phone-label">Liên hệ</span>
                        <a href="tel:0909123456" class="nav-phone-number">
                            <i class="fas fa-phone-alt me-1"></i>0909 123 456
                        </a>
                    </div>

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
<div id="global-toast-container"></div>

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

        function hideSuggestions() {
            suggestionsBox.classList.remove('open');
            setTimeout(() => { suggestionsBox.innerHTML = ''; }, 200);
        }

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

        function formatPrice(price) {
            return Number(price).toLocaleString('vi-VN') + 'đ';
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

    window.showGlobalToast = function(type, msg, duration) {
        duration = duration || 2000;
        var container = document.getElementById('global-toast-container');
        if (!container || !msg) return;
        var icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle' };
        var icon  = icons[type] || icons.info;
        var toast = document.createElement('div');
        toast.className = 'global-toast ' + type;
        toast.style.position = 'relative';
        toast.innerHTML =
            '<span class="gt-icon"><i class="fas ' + icon + '"></i></span>' +
            '<span class="gt-msg">' + msg + '</span>' +
            '<button class="gt-close" onclick="this.closest(\'.global-toast\').remove()"><i class="fas fa-times"></i></button>' +
            '<div class="gt-bar"></div>';
        container.appendChild(toast);
        requestAnimationFrame(function() {
            requestAnimationFrame(function() { toast.classList.add('show'); });
        });
        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() { if (toast.parentNode) toast.remove(); }, 400);
        }, duration);
    };

    // ==================== CATEGORY DROPDOWN ====================
    (function () {
        var navItem  = document.getElementById('category-nav-item');
        var dropdown = document.getElementById('category-dropdown');
        var chevron  = document.getElementById('category-chevron');
        var navLink  = document.getElementById('category-nav-link');
        var ctxPath  = '${contextPath}';
        var loaded   = false;
        var closeTimer = null;
        var isDesktop = function () { return window.innerWidth >= 992; };

        function openDropdown() {
            clearTimeout(closeTimer);
            dropdown.classList.add('active');
            chevron.style.transform = 'rotate(180deg)';
            navLink.setAttribute('aria-expanded', 'true');
            if (!loaded) loadCategories();
        }
        function closeDropdown() {
            dropdown.classList.remove('active');
            chevron.style.transform = '';
            navLink.setAttribute('aria-expanded', 'false');
        }
        function scheduleClose() { closeTimer = setTimeout(closeDropdown, 150); }

        // Desktop: hover
        navItem.addEventListener('mouseenter', function () { if (isDesktop()) openDropdown(); });
        navItem.addEventListener('mouseleave', function () { if (isDesktop()) scheduleClose(); });
        dropdown.addEventListener('mouseenter', function () { if (isDesktop()) clearTimeout(closeTimer); });
        dropdown.addEventListener('mouseleave', function () { if (isDesktop()) scheduleClose(); });

        // Mobile: click toggle
        navLink.addEventListener('click', function (e) {
            if (!isDesktop()) {
                e.preventDefault();
                dropdown.classList.contains('active') ? closeDropdown() : openDropdown();
            }
        });

        // Close on outside click
        document.addEventListener('click', function (e) {
            if (navItem && !navItem.contains(e.target)) closeDropdown();
        });

        // Load categories via API
        function loadCategories() {
            loaded = true;
            fetch(ctxPath + '/api/categories')
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    var list = dropdown.querySelector('.category-dropdown-list');
                    list.querySelectorAll('.skeleton, .category-dropdown-divider').forEach(function (el) { el.remove(); });
                    if (!data || data.length === 0) return;
                    data.forEach(function (cat) {
                        var li = document.createElement('li');
                        li.className = 'category-dropdown-item';
                        var a = document.createElement('a');
                        a.className = 'category-dropdown-link';
                        a.href = ctxPath + '/menu?categoryId=' + cat.id;
                        a.setAttribute('role', 'menuitem');
                        a.innerHTML = '<span>' + cat.name + '</span>';
                        li.appendChild(a);
                        list.appendChild(li);
                    });
                })
                .catch(function () { /* silent fail */ });
        }
    })();

    (function() {
        var msg = '<c:out value="${sessionScope.message}" escapeXml="true"/>';
        var err = '<c:out value="${sessionScope.error}"   escapeXml="true"/>';
        <c:if test="${not empty sessionScope.message}">
        if (msg && msg.trim()) window.showGlobalToast('success', msg);
        <% session.removeAttribute("message"); %>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
        if (err && err.trim()) window.showGlobalToast('error', err);
        <% session.removeAttribute("error"); %>
        </c:if>
    })();
</script>
