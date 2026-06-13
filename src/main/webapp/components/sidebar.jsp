<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar" id="sidebar">
    <button class="sidebar-toggle" id="sidebarToggle" title="Thu/mở menu">
        <span class="toggle-icon"><i class="fas fa-chevron-left"></i></span>
    </button>
    <div class="sidebar-inner">

        <div class="sidebar-logo">
            <span class="brand-name">Sweet Oven</span>
        </div>

        <nav class="sidebar-nav">
            <ul>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="nav-link ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}"
                       data-tooltip="Dashboard">
                        <i class="fas fa-chart-pie"></i>
                        <span class="nav-label">Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/products"
                       class="nav-link ${pageContext.request.requestURI.contains('products') ? 'active' : ''}"
                       data-tooltip="Sản phẩm">
                        <i class="fas fa-cookie-bite"></i>
                        <span class="nav-label">Sản phẩm</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/categories"
                       class="nav-link ${pageContext.request.requestURI.contains('categories') ? 'active' : ''}"
                       data-tooltip="Danh mục">
                        <i class="fas fa-layer-group"></i>
                        <span class="nav-label">Danh mục</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/orders"
                       class="nav-link ${pageContext.request.requestURI.contains('orders') ? 'active' : ''}"
                       data-tooltip="Đơn hàng">
                        <i class="fas fa-clipboard-list"></i>
                        <span class="nav-label">Đơn hàng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="nav-link ${pageContext.request.requestURI.contains('users') ? 'active' : ''}"
                       data-tooltip="Khách hàng">
                        <i class="fas fa-users"></i>
                        <span class="nav-label">Người dùng</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/banners"
                       class="nav-link ${pageContext.request.requestURI.contains('banners') ? 'active' : ''}"
                       data-tooltip="Banner">
                        <i class="fas fa-image"></i>
                        <span class="nav-label">Banner</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/discounts"
                       class="nav-link ${pageContext.request.requestURI.contains('discounts') ? 'active' : ''}"
                       data-tooltip="Khuyến mãi">
                        <i class="fas fa-tags"></i>
                        <span class="nav-label">Khuyến mãi</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/feedback"
                       class="nav-link ${pageContext.request.requestURI.contains('feedback') ? 'active' : ''}"
                       data-tooltip="Phản hồi">
                        <i class="fas fa-comment-alt"></i>
                        <span class="nav-label">Phản hồi</span>
                    </a>
                </li>
            </ul>
        </nav>

        <div class="sidebar-footer">
            <div class="admin-profile">
                <div class="admin-avatar-icon"><i class="fas fa-user-shield"></i></div>
                <div class="admin-profile-info">
                    <div class="admin-name">${sessionScope.user.fullName}</div>
                    <div class="admin-role">Quản trị viên</div>
                </div>
            </div>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-form">
                <button type="submit" class="nav-link logout-link" data-tooltip="Đăng xuất">
                    <i class="fas fa-sign-out-alt"></i>
                    <span class="nav-label">Đăng xuất</span>
                </button>
            </form>
        </div>

    </div>
</aside>
