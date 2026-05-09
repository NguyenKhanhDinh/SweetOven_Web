<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sweet Oven - Quản lý Banner</title>
    <link rel="icon" href="/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        /* --- CSS HỆ THỐNG (ĐÃ ĐỒNG BỘ) --- */
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

        .btn-secondary-custom {
            background-color: var(--secondary);
            border-color: var(--secondary);
            color: var(--dark);
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
        }

        .table tbody tr:hover {
            background-color: rgba(212, 167, 106, 0.1);
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
        }

        .badge-active {
            background-color: var(--success);
        }

        .badge-inactive {
            background-color: var(--danger);
        }

        /* Form Styles */
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

        /* Search Box */
        .search-box {
            position: relative;
        }

        .search-box .form-control {
            padding-left: 40px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 12px;
            color: var(--accent);
        }

        /* Modal styles fix */
        .modal-header {
            background-color: var(--primary);
            color: white;
        }

        .modal-header .btn-close {
            filter: invert(1);
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
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
                        <a href="${pageContext.request.contextPath}/admin/products" class="nav-link">
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
                        <a href="${pageContext.request.contextPath}/admin/banners" class="nav-link active">
                            <i class="fas fa-images"></i> <span>Banner</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link">
                            <i class="fas fa-envelope"></i> <span>Phản hồi</span>
                        </a>
                    </li>
                </ul>

                <div class="dropdown mt-auto pt-3">
                    <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                       id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle fa-2x me-2"></i>
                        <strong>Quản trị viên</strong>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-dark text-small shadow" aria-labelledby="dropdownUser">
                        <li><a class="dropdown-item" href="login.html"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-md-10 col-lg-10 main-content">

            <div class="admin-header d-flex justify-content-between align-items-center">
                <h1 class="h3 mb-0 text-primary">QUẢN LÝ BANNER</h1>
                <div class="d-flex align-items-center">
                    <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addBannerModal">
                        <i class="fas fa-plus me-1"></i> Thêm banner
                    </button>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${param.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Tiêu đề banner</th>
                            <th>Mô tả</th>

                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty banners}">
                                <tr>
                                    <td colspan="5" class="text-center py-4">Chưa có banner nào.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="banner" items="${banners}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td class="fw-bold text-primary">${banner.title}</td>
                                        <td>${banner.description}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${banner.is_active}">
                                                    <span class="badge bg-success badge-active">Đang hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger badge-inactive">Ngừng hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1" onclick="editBanner(${banner.id})">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger"
                                                    onclick="deleteBanner(${banner.id}, '${banner.title}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Modal Thêm -->
<div class="modal fade" id="addBannerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm banner mới</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="addBannerForm" action="${pageContext.request.contextPath}/admin/banners" method="post"
                      enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="form-section mb-4">
                        <h6 class="form-section-title">Thông tin cơ bản</h6>
                        <div class="mb-3">
                            <label class="form-label required">Tiêu đề banner</label>
                            <input type="text" class="form-control" name="title" placeholder="Nhập tiêu đề banner" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="3"
                                      placeholder="Mô tả ngắn về banner"></textarea>
                        </div>
                    </div>

                    <div class="form-section mb-4">
                        <h6 class="form-section-title">Hình ảnh banner</h6>
                        <div class="mb-3">
                            <label class="form-label">Chọn ảnh banner</label>
                            <input type="file" class="form-control" id="add-img-file" name="imageFile" accept="image/*"
                                   onchange="previewImage(this, 'add-preview', 'add-preview-box')">
                        </div>
                        <div class="w-100 text-center" id="add-preview-box" style="display: none; margin-top: 10px;">
                            <img id="add-preview" src="" class="img-fluid rounded border shadow-sm d-block mx-auto"
                                 style="max-height: 200px;">
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">Trạng thái</h6>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="add-active" name="isActive" checked>
                            <label class="form-check-label" for="add-active">Kích hoạt ngay</label>
                        </div>
                    </div>

                    <div class="text-end mt-3">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary-custom">Thêm banner</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Sửa -->
<div class="modal fade" id="editBannerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập nhật banner</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editBannerForm" action="${pageContext.request.contextPath}/admin/banners" method="post"
                      enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" id="edit-id" name="id">
                    <input type="hidden" id="edit-img-url-hidden" name="imageUrl">

                    <div class="form-section mb-4">
                        <h6 class="form-section-title">Thông tin cơ bản</h6>
                        <div class="mb-3">
                            <label class="form-label required">Tiêu đề banner</label>
                            <input type="text" class="form-control" id="edit-title" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" id="edit-description" name="description" rows="3"></textarea>
                        </div>
                    </div>

                    <div class="form-section mb-4">
                        <h6 class="form-section-title">Hình ảnh banner</h6>
                        <div class="mb-3">
                            <label class="form-label">Thay đổi ảnh banner</label>
                            <input type="file" class="form-control" id="edit-img-file" name="imageFile" accept="image/*"
                                   onchange="previewImage(this, 'edit-preview', 'edit-preview-box')">
                            <small class="text-muted">Để trống nếu không muốn thay đổi ảnh.</small>
                        </div>

                        <div class="w-100 text-center" id="edit-preview-box" style="display: none; margin-top: 10px;">
                            <img id="edit-preview" src="" class="img-fluid rounded border shadow-sm d-block mx-auto"
                                 style="max-height: 200px;">
                        </div>
                    </div>

                    <div class="form-section">
                        <h6 class="form-section-title">Trạng thái</h6>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="edit-isActive" name="isActive">
                            <label class="form-check-label" for="edit-isActive">Đang hoạt động</label>
                        </div>
                    </div>

                    <div class="text-end mt-3">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary-custom">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function previewImage(inputElement, imgId, boxId) {
        const file = inputElement.files[0];
        const img = document.getElementById(imgId);
        const box = document.getElementById(boxId);

        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                img.src = e.target.result;
                if (box) {
                    box.style.display = 'block';
                    box.style.marginBottom = '15px';
                }
                img.style.display = 'block';
            }
            reader.readAsDataURL(file);
        } else {
            // If no file is selected, hide the preview box
            if (box) box.style.display = 'none';
            img.src = ''; // Clear the image source
        }
    }

    // Helper to show image from URL (used when editing)
    function showImagePreview(url, imgId, boxId) {
        const img = document.getElementById(imgId);
        const box = document.getElementById(boxId);

        if (url) {
            img.src = url;
            if (box) {
                box.style.display = 'block';
                box.style.marginBottom = '15px';
            }
            img.style.display = 'block';
        } else {
            if (box) box.style.display = 'none';
            img.src = ''; // Clear the image source
        }
    }

    function deleteBanner(id, title) {
        if (confirm('Bạn có chắc chắn muốn xóa banner "' + title + '" không?')) {
            window.location.href = '${pageContext.request.contextPath}/admin/banners?action=delete&id=' + id;
        }
    }

    function editBanner(id) {
        const modal = new bootstrap.Modal(document.getElementById('editBannerModal'));
        modal.show();

        // Clear previous file input selection
        document.getElementById('edit-img-file').value = "";

        fetch('${pageContext.request.contextPath}/admin/banners?action=get-detail&id=' + id)
            .then(response => response.json())
            .then(data => {
                document.getElementById('edit-id').value = data.id;
                document.getElementById('edit-title').value = data.title;
                document.getElementById('edit-description').value = data.description;
                document.getElementById('edit-isActive').checked = data.is_active;

                // Store old URL and preview it
                document.getElementById('edit-img-url-hidden').value = data.bannerImageUrl;
                showImagePreview(data.bannerImageUrl, 'edit-preview', 'edit-preview-box');
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể tải thông tin banner');
            });
    }
</script>
</body>

</html>