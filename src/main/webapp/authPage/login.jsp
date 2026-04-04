<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | Sweet Oven Bakery</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Đã thêm font Fredoka cho tiêu đề tròn trịa, chắc nét -->
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #8B4513;      /* Nâu sẫm */
            --primary-hover: #6d360f;
            --accent: #D4A76A;       /* Vàng nâu */
            --bg-color: #F9F6F0;     /* Màu nền sáng trơn */
            --text-main: #333;
            --white: #ffffff;
            --facebook: #1877f2;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Quicksand", sans-serif;
        }

        body.login-page {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: var(--bg-color); /* Nền trơn 1 màu */
            padding: 20px;
        }

        /* Container chính */
        .login-container {
            width: 900px;
            max-width: 100%;
            height: 600px;
            background: var(--white);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(139, 69, 19, 0.08);
            display: flex;
            overflow: hidden;
            position: relative;
        }

        /* --- Cột trái: Nền trơn một màu --- */
        .sidebar {
            width: 50%;
            background-color: var(--primary); /* Sử dụng màu nâu sẫm trơn, không họa tiết */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: var(--white);
            position: relative;
        }

        .sidebar-content {
            text-align: center;
            padding: 40px;
            z-index: 2;
        }

        .sidebar-content h1 {
            font-family: 'Quicksand', sans-serif;
            font-size: 2.5rem;
            font-weight: 600;
            margin-bottom: 15px;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.15);
            letter-spacing: 1px;
        }

        .sidebar-content p {
            font-size: 1.15rem;
            margin-bottom: 30px;
            font-weight: 500;
            line-height: 1.5;
        }

        .btn-outline {
            border: 2px solid var(--white);
            padding: 12px 35px;
            border-radius: 30px;
            color: var(--white);
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .btn-outline:hover {
            background: var(--white);
            color: var(--primary);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        /* --- Cột phải: Form Đăng nhập --- */
        .form-box {
            width: 50%;
            padding: 50px 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--white);
        }

        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .login-header h2 {
            font-size: 28px;
            color: var(--primary);
            font-weight: 800;
            letter-spacing: 1px;
            margin-top: 10px;
        }

        .input-group {
            position: relative;
            margin-bottom: 22px;
        }

        .input-group i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: 0.3s;
            font-size: 1.1rem;
        }

        .input-group input {
            width: 100%;
            padding: 16px 15px 16px 55px;
            border: 1.5px solid #eaeaea;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 500;
            color: var(--text-main);
            background: #fafafa;
            transition: all 0.3s;
        }

        .input-group input::placeholder {
            color: #999;
            font-weight: 400;
        }

        .input-group input:focus {
            outline: none;
            border-color: var(--accent);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(212, 167, 106, 0.15);
        }

        .input-group input:focus + i {
            color: var(--primary);
        }

        .error-message {
            background-color: #fff0f0;
            color: #d63031;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
            margin-bottom: 20px;
            border: 1px solid #ffcccc;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 30px;
        }

        .actions a {
            color: #777;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
        }

        .actions a:hover {
            color: var(--primary);
            text-decoration: underline;
        }

        .login-btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 12px;
            background: var(--primary);
            color: white;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.2);
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.35);
            background: var(--primary-hover);
        }

        .divider {
            text-align: center;
            margin: 30px 0 25px;
            position: relative;
        }

        .divider span {
            background: var(--white);
            padding: 0 15px;
            color: #999;
            font-size: 13px;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        .divider::after {
            content: "";
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: #eee;
            z-index: 0;
        }

        .social-icons {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .social-btn {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s ease;
            font-size: 20px;
            border: 1px solid transparent;
        }

        /* Facebook Button */
        .social-btn.facebook {
            background: var(--facebook);
            color: white;
            box-shadow: 0 4px 10px rgba(24, 119, 242, 0.2);
        }
        .social-btn.facebook:hover {
            background: #166fe5;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(24, 119, 242, 0.4);
        }

        /* Google Button - SVG với viền xám nhẹ để nổi bật trên nền trắng */
        .social-btn.google {
            background: #ffffff;
            border-color: #ddd;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }
        .social-btn.google svg {
            width: 22px;
            height: 22px;
        }
        .social-btn.google:hover {
            background: #fdfdfd;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        .back-home {
            margin-top: 35px;
            text-align: center;
        }

        .back-home a {
            color: #888;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }

        .back-home a:hover {
            color: var(--primary);
            transform: translateX(-5px);
        }

        /* --- RESPONSIVE MOBILE --- */
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                height: auto;
                width: 100%;
                border-radius: 20px;
            }

            .sidebar {
                width: 100%;
                padding: 40px 20px;
            }

            .sidebar-content {
                padding: 0;
            }

            .sidebar-content h1 { font-size: 3rem; margin-bottom: 5px; }
            .sidebar-content p { display: none; }

            .sidebar-content .btn-outline {
                padding: 8px 25px;
                font-size: 0.9rem;
                margin-top: 10px;
            }

            .form-box {
                width: 100%;
                padding: 40px 25px;
            }
        }
    </style>
</head>
<body class="login-page">

<div class="login-container">
    <div class="sidebar">
        <div class="sidebar-content">
            <h1>Sweet Oven</h1>
            <p>Bánh tươi mỗi ngày, ngọt ngào trọn vị.<br>Cùng khám phá những hương vị tuyệt vời!</p>
            <p style="font-size: 0.95rem; margin-bottom: 15px; opacity: 0.9; font-weight: 400;">Bạn chưa có tài khoản?</p>
            <a href="register" class="btn-outline">ĐĂNG KÝ NGAY</a>
        </div>
    </div>

    <div class="form-box">
        <div class="login-header">
            <h2>ĐĂNG NHẬP</h2>
        </div>

        <form action="login" method="post">

            <div class="input-group">
                <input type="text" name="username" placeholder="Tên đăng nhập" required autocomplete="off">
                <i class="fa-regular fa-user"></i>
            </div>

            <div class="input-group">
                <input type="password" name="password" placeholder="Mật khẩu" required>
                <i class="fa-solid fa-lock"></i>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <div class="actions">
                <a href="/forgot-password">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="login-btn">ĐĂNG NHẬP</button>
        </form>

        <div class="divider">
            <span>Hoặc đăng nhập với</span>
        </div>

        <div class="social-icons">
            <a href="#" class="social-btn facebook" title="Đăng nhập bằng Facebook">
                <i class="fa-brands fa-facebook-f"></i>
            </a>
            <a href="#" class="social-btn google" title="Đăng nhập bằng Google">
                <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
                    <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
                    <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
                    <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
                    <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
                    <path fill="none" d="M0 0h48v48H0z"></path>
                </svg>
            </a>
        </div>

        <div class="back-home">
            <a href="${pageContext.request.contextPath}/">
                <i class="fa-solid fa-arrow-left-long"></i> Quay về trang chủ
            </a>
        </div>
    </div>
</div>

</body>