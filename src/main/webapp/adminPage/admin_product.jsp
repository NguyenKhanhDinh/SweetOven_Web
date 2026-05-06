<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Sweet Oven - Quản lý sản phẩm</title>
                <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">

                <style>
                    /* --- CSS HỆ THỐNG --- */
                    :root {
                        --primary: #8B4513;
                        --primary-light: #A05A2B;
                        --secondary: #D4A76A;
                        --secondary-light: #E0B878;
                        --accent: #C19A6B;
                        --light: #FFF9F0;
                        --dark: #333333;
                        --success: #28a745;
                        --danger: #dc3545;
                        --shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                        --transition: all 0.3s ease;
                    }

                    body {
                        font-family: 'Quicksand', sans-serif;
                        background-color: #f8f9fa;
                        color: var(--dark);
                        overflow-x: hidden;
                    }

                    .text-primary {
                        color: var(--primary) !important;
                    }

                    /* Sidebar Styles */
                    .sidebar {
                        background: linear-gradient(to bottom, var(--primary), var(--primary-light));
                        min-height: 100vh;
                        box-shadow: var(--shadow);
                        position: fixed;
                        z-index: 100;
                        left: 0;
                        top: 0;
                        width: 200px;
                    }

                    .sidebar .nav-link {
                        color: rgba(255, 255, 255, 0.8);
                        padding: 8px 15px;
                        margin: 2px 0;
                        border-radius: 6px;
                        font-size: 0.9rem;
                        transition: var(--transition);
                        font-weight: 400;
                    }

                    .sidebar .nav-link:hover {
                        background-color: rgba(255, 255, 255, 0.15);
                        color: white;
                    }

                    .sidebar .nav-link.active {
                        background-color: rgba(255, 255, 255, 0.15);
                        color: white;
                        font-weight: 400;
                    }

                    .sidebar .nav-link i {
                        width: 24px;
                        text-align: center;
                        margin-right: 10px;
                    }

                    .sidebar-header h3 {
                        font-size: 1.5rem;
                    }

                    /* Main Content */
                    .main-content {
                        margin-left: 205px;
                        padding: 20px;
                        min-height: 100vh;
                        transition: var(--transition);
                    }

                    /* Header */
                    .admin-header {
                        background-color: white;
                        border-radius: 10px;
                        box-shadow: var(--shadow);
                        padding: 15px 25px;
                        margin-bottom: 25px;
                    }

                    /* Cards */
                    .dashboard-card {
                        border-radius: 10px;
                        border: none;
                        box-shadow: var(--shadow);
                        transition: var(--transition);
                        margin-bottom: 20px;
                        height: 120px;
                        display: flex;
                        align-items: center;
                    }

                    .dashboard-card:hover {
                        transform: translateY(-5px);
                    }

                    .card-primary {
                        background: linear-gradient(135deg, var(--primary), var(--primary-light));
                        color: white;
                    }

                    .card-secondary {
                        background: linear-gradient(135deg, var(--accent), var(--secondary));
                        color: white;
                    }

                    .card-accent {
                        background: linear-gradient(135deg, var(--secondary-light), var(--accent));
                        color: white;
                    }

                    /* Table */
                    .table-container {
                        background-color: white;
                        border-radius: 10px;
                        box-shadow: var(--shadow);
                        overflow: hidden;
                    }

                    .table thead th {
                        background-color: var(--primary);
                        color: white;
                        border: none;
                        padding: 15px;
                        font-weight: 600;
                        white-space: nowrap;
                    }

                    .table tbody tr:hover {
                        background-color: rgba(212, 167, 106, 0.1);
                    }

                    .table tbody td {
                        padding: 15px;
                        vertical-align: middle;
                    }

                    /* Table Image */
                    .product-thumb {
                        width: 45px;
                        height: 45px;
                        object-fit: cover;
                        border-radius: 6px;
                        margin-right: 10px;
                        border: 1px solid #eee;
                    }

                    /* SKU Style */
                    .sku-code {
                        font-weight: 600;
                        color: var(--dark);
                        letter-spacing: 0.5px;
                        font-size: 0.9rem;
                    }

                    .id-col {
                        color: #888;
                        font-size: 0.9em;
                    }

                    /* Buttons */
                    .btn-primary-custom {
                        background-color: var(--primary);
                        border-color: var(--primary);
                        color: white;
                    }

                    .btn-primary-custom:hover {
                        background-color: var(--primary-light);
                        border-color: var(--primary-light);
                    }

                    /* Status badges */
                    .badge-available {
                        background-color: var(--success);
                    }

                    .badge-unavailable {
                        background-color: var(--danger);
                    }

                    /* Modal */
                    .modal-header {
                        background-color: var(--primary);
                        color: white;
                    }

                    .modal-header .btn-close {
                        filter: invert(1);
                    }

                    /* Search box */
                    .search-box {
                        position: relative;
                    }

                    .search-box .form-control {
                        padding-left: 40px;
                        border-radius: 20px;
                    }

                    .search-box i {
                        position: absolute;
                        left: 15px;
                        top: 12px;
                        color: var(--accent);
                    }

                    /* Form Sections */
                    .form-section {
                        border-left: 3px solid var(--secondary);
                        padding-left: 15px;
                        margin-bottom: 25px;
                    }

                    .form-section-title {
                        font-weight: 600;
                        color: var(--primary);
                        margin-bottom: 15px;
                        font-size: 1.1rem;
                    }

                    .required::after {
                        content: " *";
                        color: var(--danger);
                    }

                    /* Responsive */
                    @media (max-width: 768px) {
                        .sidebar {
                            width: 100%;
                            height: auto;
                            position: relative;
                            min-height: auto;
                        }

                        .main-content {
                            margin-left: 0;
                        }

                        .dashboard-card {
                            height: auto;
                            min-height: 100px;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-2 col-lg-2 sidebar p-0">
                            <div class="d-flex flex-column p-3">
                                <div class="sidebar-header text-center mb-3 mt-2">
                                    <h3 class="text-white fw-bold mb-0">ADMIN</h3>
                                    <p class="text-white-50 small">Quản lý hệ thống</p>
                                </div>

                                <ul class="nav nav-pills flex-column mb-auto">
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/admin/products"
                                            class="nav-link active">
                                            <i class="fas fa-box"></i> <span>Sản phẩm</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/admin/categories" class="nav-link">
                                            <i class="fas fa-list"></i> <span>Danh mục</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                                            <i class="fas fa-users"></i> <span>Người dùng</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link">
                                            <i class="fas fa-shopping-cart"></i> <span>Đơn hàng</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/admin/promotions" class="nav-link">
                                            <i class="fas fa-tag"></i> <span>Khuyến mãi</span>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="${pageContext.request.contextPath}/admin/banners" class="nav-link">
                                            <i class="fas fa-images"></i> <span>Banner</span>
                                        </a>
                                    </li>
                                    <li class="nav-item"><a href="${pageContext.request.contextPath}/admin/feedback"
                                            class="nav-link"><i class="fas fa-envelope"></i>
                                            <span>Phản hồi</span></a></li>
                                </ul>

                                <div class="dropdown mt-auto pt-3">
                                    <a href="#"
                                        class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                                        id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-user-circle fa-2x me-2"></i>
                                        <strong>Quản trị viên</strong>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-dark text-small shadow"
                                        aria-labelledby="dropdownUser">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i
                                                    class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-10 col-lg-10 main-content">
                            <div class="admin-header d-flex justify-content-between align-items-center">
                                <h1 class="h3 mb-0 text-primary">QUẢN LÝ SẢN PHẨM</h1>
                                <div class="d-flex align-items-center">
                                    <button class="btn btn-primary-custom" data-bs-toggle="modal"
                                        data-bs-target="#addProductModal">
                                        <i class="fas fa-plus me-1"></i> Thêm sản phẩm
                                    </button>
                                </div>
                            </div>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty success}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i> ${success}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <form action="${pageContext.request.contextPath}/admin/products" method="get"
                                        class="search-box">
                                        <i class="fas fa-search"></i>
                                        <input type="text" class="form-control" name="search" value="${searchKeyword}"
                                            placeholder="Tìm kiếm theo mã sản phẩm, tên, mô tả...">
                                    </form>
                                </div>
                            </div>

                            <div class="table-container">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th style="width: 50px;">ID</th>
                                                <th style="width: 120px;">Mã SP</th>
                                                <th>Tên sản phẩm</th>
                                                <th>Danh mục</th>
                                                <th>Giá</th>
                                                <th>Tồn kho</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty products}">
                                                <tr>
                                                    <td colspan="8" class="text-center py-4">
                                                        <div class="text-muted">Chưa có sản phẩm nào. Hãy thêm sản phẩm
                                                            mới!</div>
                                                    </td>
                                                </tr>
                                            </c:if>

                                            <c:forEach items="${products}" var="p">
                                                <tr>
                                                    <td class="id-col">${p.id}</td>
                                                    <td class="sku-code">${p.productCode}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">

                                                            <div>
                                                                <div class="fw-bold text-primary">${p.name}</div>
                                                                <c:if test="${p.featured}">
                                                                    <small class="text-warning"><i
                                                                            class="fas fa-star"></i> Nổi bật</small>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${p.categoryId == 1}">Bánh ngọt</c:when>
                                                            <c:when test="${p.categoryId == 2}">Bánh mặn</c:when>
                                                            <c:when test="${p.categoryId == 3}">Đồ nướng</c:when>
                                                            <c:when test="${p.categoryId == 4}">Combo</c:when>
                                                            <c:otherwise>Khác</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <strong>
                                                            <fmt:formatNumber value="${p.price}" type="number"
                                                                groupingUsed="true" /> VNĐ
                                                        </strong>
                                                    </td>
                                                    <td>${p.stockQuantity}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${p.stockQuantity > 0}">
                                                                <span class="badge badge-available">Còn hàng</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-unavailable">Hết hàng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="#" onclick="openEditModal(${p.id}); return false;"
                                                            class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="#"
                                                            onclick="if(confirm('Bạn có chắc muốn xóa sản phẩm này?')) window.location.href='${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}'"
                                                            class="btn btn-sm btn-outline-danger" title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="d-flex justify-content-between align-items-center p-3">
                                    <div class="text-muted small">
                                        <c:choose>
                                            <c:when test="${totalProducts == 0}">
                                                Không có sản phẩm nào
                                            </c:when>
                                            <c:otherwise>
                                                Hiển thị ${(currentPage - 1) * pageSize + 1}-${(currentPage * pageSize)
                                                > totalProducts ? totalProducts : (currentPage * pageSize)} trên tổng số
                                                ${totalProducts} sản phẩm
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:if test="${totalProducts > 0}">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination pagination-sm mb-0">
                                                <!-- First Page Button -->
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="${pageContext.request.contextPath}/admin/products?page=1<c:if test="
                                                        ${not empty searchKeyword}">&search=${searchKeyword}
                                    </c:if>"
                                    title="Trang đầu">
                                    <i class="fas fa-angle-double-left"></i>
                                    </a>
                                    </li>

                                    <!-- Previous Button -->
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="${pageContext.request.contextPath}/admin/products?page=${currentPage - 1}<c:if test="
                                            ${not empty searchKeyword}">&search=${searchKeyword}</c:if>"
                                            title="Trang trước">
                                            <i class="fas fa-angle-left"></i>
                                        </a>
                                    </li>

                                    <!-- Smart Page Numbers with Ellipsis -->
                                    <c:choose>
                                        <%-- Show all pages if 7 or fewer --%>
                                            <c:when test="${totalPages <= 7}">
                                                <c:forEach var="i" begin="1" end="${totalPages}">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/admin/products?page=${i}<c:if test="
                                                            ${not empty searchKeyword}">&search=${searchKeyword}</c:if>
                                                            ">${i}</a>
                                                    </li>
                                                </c:forEach>
                                            </c:when>

                                            <%-- Smart ellipsis for many pages --%>
                                                <c:otherwise>
                                                    <%-- Always show page 1 --%>
                                                        <li class="page-item ${currentPage == 1 ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/admin/products?page=1<c:if test="
                                                                ${not empty searchKeyword}">&search=${searchKeyword}
                                                                </c:if>">1</a>
                                                        </li>

                                                        <%-- Left ellipsis if current page is far from start --%>
                                                            <c:if test="${currentPage > 4}">
                                                                <li class="page-item disabled">
                                                                    <span class="page-link">...</span>
                                                                </li>
                                                            </c:if>

                                                            <%-- Middle pages: calculate range around current page --%>
                                                                <c:set var="startPage"
                                                                    value="${currentPage > 3 ? currentPage - 1 : 2}" />
                                                                <c:set var="endPage"
                                                                    value="${currentPage < totalPages - 2 ? currentPage + 1 : totalPages - 1}" />

                                                                <c:forEach var="i" begin="${startPage}"
                                                                    end="${endPage}">
                                                                    <c:if test="${i > 1 and i < totalPages}">
                                                                        <li
                                                                            class="page-item ${currentPage == i ? 'active' : ''}">
                                                                            <a class="page-link"
                                                                                href="${pageContext.request.contextPath}/admin/products?page=${i}<c:if test="
                                                                                ${not empty
                                                                                searchKeyword}">&search=${searchKeyword}
                                                                    </c:if>">${i}</a>
                                                                    </li>
                                                                    </c:if>
                                                                </c:forEach>

                                                                <%-- Right ellipsis if current page is far from end --%>
                                                                    <c:if test="${currentPage < totalPages - 3}">
                                                                        <li class="page-item disabled">
                                                                            <span class="page-link">...</span>
                                                                        </li>
                                                                    </c:if>

                                                                    <%-- Always show last page --%>
                                                                        <li
                                                                            class="page-item ${currentPage == totalPages ? 'active' : ''}">
                                                                            <a class="page-link"
                                                                                href="${pageContext.request.contextPath}/admin/products?page=${totalPages}<c:if test="
                                                                                ${not empty
                                                                                searchKeyword}">&search=${searchKeyword}
                                                                                </c:if>">${totalPages}</a>
                                                                        </li>
                                                </c:otherwise>
                                    </c:choose>

                                    <!-- Next Button -->
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="${pageContext.request.contextPath}/admin/products?page=${currentPage + 1}<c:if test="
                                            ${not empty searchKeyword}">&search=${searchKeyword}</c:if>"
                                            title="Trang tiếp">
                                            <i class="fas fa-angle-right"></i>
                                        </a>
                                    </li>

                                    <!-- Last Page Button -->
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="${pageContext.request.contextPath}/admin/products?page=${totalPages}<c:if test="
                                            ${not empty searchKeyword}">&search=${searchKeyword}</c:if>"
                                            title="Trang cuối">
                                            <i class="fas fa-angle-double-right"></i>
                                        </a>
                                    </li>
                                    </ul>
                                    </nav>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addProductModalLabel">Thêm sản phẩm mới</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>

                            <form action="${pageContext.request.contextPath}/admin/products" method="post"
                                enctype="multipart/form-data">
                                <input type="hidden" name="action" value="add">
                                <div class="modal-body">

                                    <div class="form-section">
                                        <h6 class="form-section-title">Thông tin cơ bản</h6>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="productCode" class="form-label required">Mã sản phẩm
                                                    (SKU)</label>
                                                <input type="text" class="form-control" name="productCode"
                                                    id="productCode" placeholder="VD: SP-BN-001" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="productName" class="form-label required">Tên sản
                                                    phẩm</label>
                                                <input type="text" class="form-control" name="name" id="productName"
                                                    placeholder="Nhập tên sản phẩm" required>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label for="productCategory" class="form-label required">Danh
                                                    mục</label>
                                                <select class="form-select" name="categoryId" id="productCategory"
                                                    required>
                                                    <option value="" selected disabled>Chọn danh mục</option>
                                                    <c:forEach items="${categories}" var="c">
                                                        <option value="${c.id}">${c.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label for="productPrice" class="form-label required">Giá (VNĐ)</label>
                                                <input type="number" class="form-control" name="price" id="productPrice"
                                                    min="0" step="1000" placeholder="VD: 50000" required>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label for="productStock" class="form-label required">Tồn kho</label>
                                                <input type="number" class="form-control" name="stockQuantity"
                                                    id="productStock" min="0" value="0" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <h6 class="form-section-title">Hình ảnh sản phẩm</h6>
                                        <div class="bg-light p-3 border rounded">
                                            <div class="mb-3">
                                                <label for="imageFileMain" class="form-label required">Ảnh đại diện
                                                    (Chính)</label>
                                                <input type="file" class="form-control" name="imageFileMain"
                                                    id="imageFileMain" accept="image/*" required>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="imageFileSub1" class="form-label">Ảnh phụ 1</label>
                                                    <input type="file" class="form-control" name="imageFileSub1"
                                                        id="imageFileSub1" accept="image/*">
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="imageFileSub2" class="form-label">Ảnh phụ 2</label>
                                                    <input type="file" class="form-control" name="imageFileSub2"
                                                        id="imageFileSub2" accept="image/*">
                                                </div>
                                            </div>
                                            <div class="form-text text-muted">Định dạng .jpg, .png. Dung lượng tối đa
                                                10MB/ảnh.</div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <h6 class="form-section-title">Thông tin bổ sung</h6>
                                        <div class="mb-3">
                                            <label for="productDescription" class="form-label">Mô tả sản phẩm</label>
                                            <textarea class="form-control" name="description" id="productDescription"
                                                rows="3"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="productIngredients" class="form-label">Thành phần</label>
                                            <textarea class="form-control" name="ingredients" id="productIngredients"
                                                rows="2"></textarea>
                                        </div>
                                        <div class="form-check form-switch mb-3">
                                            <input class="form-check-input" type="checkbox" name="isFeatured"
                                                id="productFeatured" value="true">
                                            <label class="form-check-label" for="productFeatured">Sản phẩm nổi bật (Hiển
                                                thị trang chủ)</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary-custom px-4">Lưu sản phẩm</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script
                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Tự động mở lại modal nếu có lỗi khi thêm mới (Server trả về biến error)
                    <c:if test="${not empty error}">
                        var myModal = new bootstrap.Modal(document.getElementById('addProductModal'));
                        myModal.show();
                    </c:if>

                    // Helper function to resolve Image URL
                    function resolveImageUrl(url) {
                        if (!url) return '';
                        if (url.startsWith('http://') || url.startsWith('https://')) {
                            return url;
                        }
                        // If path starts with /, prepend context path without adding another /
                        if (url.startsWith('/')) {
                            return '${pageContext.request.contextPath}' + url;
                        }
                        // If path is relative, prepend context path + /
                        return '${pageContext.request.contextPath}/' + url;
                    }

                    // --- JS Xử lý Edit Modal ---
                    function openEditModal(productId) {
                        // 1. Reset form
                        document.getElementById('editProductForm').reset();
                        document.getElementById('currentImagesContainer').innerHTML = 'Đang tải...';

                        // 2. Fetch data
                        fetch('${pageContext.request.contextPath}/admin/products?action=get-detail&id=' + productId)
                            .then(response => {
                                if (!response.ok) throw new Error("Network response was not ok");
                                return response.json();
                            })
                            .then(data => {
                                // 3. Fill data to form
                                document.getElementById('editId').value = data.id;
                                document.getElementById('editProductCode').value = data.productCode;
                                document.getElementById('editName').value = data.name;
                                document.getElementById('editCategoryId').value = data.categoryId;
                                document.getElementById('editPrice').value = data.price;
                                document.getElementById('editStockQuantity').value = data.stockQuantity;
                                document.getElementById('editDescription').value = data.description;
                                document.getElementById('editIngredients').value = data.ingredients;
                                document.getElementById('editIsFeatured').checked = data.isFeatured;

                                // 4. Show current images
                                let imgsHtml = '';
                                if (data.images && data.images.length > 0) {
                                    // Phân loại slot để hiển thị (tương đối)
                                    // Logic Service: Primary=Main, Others=Sub
                                    let mainImg = data.images.find(i => i.isPrimary);
                                    let subImgs = data.images.filter(i => !i.isPrimary);

                                    if (mainImg) {
                                        imgsHtml += '<div class="me-3 text-center"><img src="' + resolveImageUrl(mainImg.imageUrl) + '" height="50" class="border d-block mb-1"><small class="text-primary fw-bold">Hiện tại (Main)</small></div>';
                                    }
                                    subImgs.forEach((img, index) => {
                                        imgsHtml += '<div class="me-3 text-center"><img src="' + resolveImageUrl(img.imageUrl) + '" height="50" class="border d-block mb-1"><small>Chưa phân loại (' + (index + 1) + ')</small></div>';
                                    });
                                } else {
                                    imgsHtml = '<span class="text-muted fst-italic">Chưa có ảnh</span>';
                                }
                                document.getElementById('currentImagesContainer').innerHTML = imgsHtml;

                                // 5. Open Modal
                                var editModal = new bootstrap.Modal(document.getElementById('editProductModal'));
                                editModal.show();
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Không thể lấy thông tin sản phẩm. Vui lòng thử lại!');
                            });
                    }
                </script>

                <!-- Edit Product Modal -->
                <div class="modal fade" id="editProductModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Chỉnh sửa sản phẩm</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="editProductForm" action="${pageContext.request.contextPath}/admin/products"
                                method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" id="editId">
                                <div class="modal-body">
                                    <div class="form-section">
                                        <h6 class="form-section-title">Thông tin cơ bản</h6>
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label required">Mã sản phẩm</label>
                                                <input type="text" class="form-control" name="productCode"
                                                    id="editProductCode" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label required">Tên sản phẩm</label>
                                                <input type="text" class="form-control" name="name" id="editName"
                                                    required>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label required">Danh mục</label>
                                                <select class="form-select" name="categoryId" id="editCategoryId"
                                                    required>
                                                    <c:forEach items="${categories}" var="c">
                                                        <option value="${c.id}">${c.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label required">Giá (VNĐ)</label>
                                                <input type="number" class="form-control" name="price" id="editPrice"
                                                    required>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label required">Tồn kho</label>
                                                <input type="number" class="form-control" name="stockQuantity"
                                                    id="editStockQuantity" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <h6 class="form-section-title">Hình ảnh (Cố định 3 slot)</h6>
                                        <div class="bg-light p-3 border rounded mb-3">
                                            <div class="d-flex mb-3" id="currentImagesContainer">
                                                <!-- Images inserted via JS -->
                                            </div>
                                            <div class="alert alert-info py-2 small">
                                                <i class="fas fa-info-circle"></i> Upload ảnh mới vào slot tương ứng sẽ
                                                <strong>THAY THẾ</strong> ảnh cũ (nếu có).
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="form-label small fw-bold">Slot 1: Ảnh Chính (Main)</label>
                                                <input type="file" class="form-control form-control-sm"
                                                    name="imageFileMain" accept="image/*">
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label small fw-bold">Slot 2: Ảnh Phụ 1</label>
                                                <input type="file" class="form-control form-control-sm"
                                                    name="imageFileSub1" accept="image/*">
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label small fw-bold">Slot 3: Ảnh Phụ 2</label>
                                                <input type="file" class="form-control form-control-sm"
                                                    name="imageFileSub2" accept="image/*">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <h6 class="form-section-title">Thông tin khác</h6>
                                        <div class="mb-3">
                                            <label class="form-label">Mô tả</label>
                                            <textarea class="form-control" name="description" id="editDescription"
                                                rows="2"></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Thành phần</label>
                                            <textarea class="form-control" name="ingredients" id="editIngredients"
                                                rows="2"></textarea>
                                        </div>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" name="isFeatured"
                                                id="editIsFeatured" value="true">
                                            <label class="form-check-label" for="editIsFeatured">Sản phẩm nổi
                                                bật</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-primary-custom px-4">Cập
                                        nhật</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </body>

            </html>