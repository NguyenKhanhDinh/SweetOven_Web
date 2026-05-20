<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sweet Oven - Quản lý Phản hồi</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        /* --- CSS HỆ THỐNG (GIỮ NGUYÊN TỪ TRANG USER) --- */
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
            --warning: #ffc107;
            --info: #17a2b8;
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

        /* Header & Cards */
        .admin-header {
            background-color: white;
            border-radius: 10px;
            box-shadow: var(--shadow);
            padding: 15px 25px;
            margin-bottom: 25px;
        }

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

        /* Card Colors */
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

        /* Custom for Feedback Table */
        .message-preview {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #666;
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

        /* Modal */
        .modal-header {
            background-color: var(--primary);
            color: white;
        }

        .modal-header .btn-close {
            filter: invert(1);
        }

        .form-section-title {
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 15px;
            font-size: 1.1rem;
            border-left: 3px solid var(--secondary);
            padding-left: 10px;
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
                        <a href="${pageContext.request.contextPath}/admin/banners" class="nav-link">
                            <i class="fas fa-images"></i> <span>Banner</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/feedback" class="nav-link active">
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
                    <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i
                                class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-md-10 col-lg-10 main-content">
            <div class="admin-header d-flex justify-content-between align-items-center">
                <h1 class="h3 mb-0 text-primary">QUẢN LÝ PHẢN HỒI</h1>
                <div class="d-flex align-items-center">
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i> Xóa phản hồi thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row mb-4">
                <div class="col-md-12">
                    <form action="${pageContext.request.contextPath}/admin/feedback" method="get" class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" class="form-control" name="search" value="${searchKeyword}"
                               placeholder="Tìm kiếm theo tên khách, email hoặc nội dung...">
                    </form>
                </div>
            </div>

            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Người gửi</th>
                            <th>Nội dung tóm tắt</th>
                            <th>Ngày gửi</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty feedbacks}">
                            <tr>
                                <td colspan="5" class="text-center py-4">
                                    <div class="text-muted">Chưa có phản hồi nào.</div>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach items="${feedbacks}" var="feedback" varStatus="status">
                            <tr>
                                <td>${status.count}</td>
                                <td>
                                    <div class="fw-bold">${feedback.fullName}</div>
                                    <small class="text-muted">${feedback.email}</small>
                                </td>
                                <td>
                                    <div class="message-preview">${feedback.content}</div>
                                </td>
                                <td>
                                    <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1 view-feedback-btn"
                                            onclick="openViewModal(${feedback.id}); return false;">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <a href="#"
                                       onclick="if(confirm('Bạn có chắc muốn xóa phản hồi này?')) window.location.href='${pageContext.request.contextPath}/admin/feedback?action=delete&id=${feedback.id}'"
                                       class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-between align-items-center p-3">
                    <div class="text-muted">Hiển thị ${feedbacks.size()} phản hồi</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="viewFeedbackModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chi tiết phản hồi</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row">
                        <div class="col-md-5 border-end">
                            <h6 class="form-section-title">Thông tin người gửi</h6>
                            <div class="mb-3">
                                <label class="fw-bold small text-secondary">Họ và tên:</label>
                                <p id="modal-name" class="mb-1">...</p>
                            </div>
                            <div class="mb-3">
                                <label class="fw-bold small text-secondary">Email:</label>
                                <p id="modal-email" class="mb-1">...</p>
                            </div>
                            <div class="mb-3">
                                <label class="fw-bold small text-secondary">Số điện thoại:</label>
                                <p id="modal-phone" class="mb-1">...</p>
                            </div>
                            <div class="mb-3">
                                <label class="fw-bold small text-secondary">Thời gian gửi:</label>
                                <p id="modal-time" class="mb-1">...</p>
                            </div>
                        </div>

                        <div class="col-md-7">
                            <h6 class="form-section-title">Nội dung tin nhắn</h6>
                            <div class="p-3 bg-light rounded border">
                                <p id="modal-content" class="mb-0" style="white-space: pre-line;">...</p>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <a id="btn-reply-email" href="#" class="btn btn-primary-custom">
                    <i class="fas fa-reply me-1"></i> Trả lời qua Email
                </a>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function openViewModal(feedbackId) {
        // Fetch feedback details via AJAX
        fetch('${pageContext.request.contextPath}/admin/feedback?action=get-detail&id=' + feedbackId)
            .then(response => {
                if (!response.ok) throw new Error("Network response was not ok");
                return response.json();
            })
            .then(data => {
                // Fill modal with data
                document.getElementById('modal-name').textContent = data.fullName;
                document.getElementById('modal-email').textContent = data.email;
                document.getElementById('modal-phone').textContent = data.phoneNumber;
                document.getElementById('modal-time').textContent = data.createdAt;
                document.getElementById('modal-content').textContent = data.content;
                document.getElementById('btn-reply-email').href = "mailto:" + data.email;

                // Show modal
                var modal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể lấy thông tin phản hồi. Vui lòng thử lại!');
            });
    }
</script>
</body>

</html>