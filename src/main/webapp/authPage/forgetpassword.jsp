<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu | Sweet Oven Bakery</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3C2F27;      /* Nâu sẫm */
            --primary-hover: #6d360f;
            --accent: #D4A76A;       /* Vàng nâu */
            --bg-color: #F9F6F0;     /* Màu nền sáng trơn */
            --text-main: #333;
            --white: #ffffff;
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
            background-color: var(--bg-color);
            padding: 20px;
        }

        .login-container {
            width: 900px;
            max-width: 100%;
            min-height: 560px;
            background: var(--white);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(139, 69, 19, 0.08);
            display: flex;
            overflow: hidden;
            position: relative;
        }

        /* --- Cột trái: Sidebar --- */
        .sidebar {
            width: 45%;
            background-color: var(--primary);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: var(--white);
            position: relative;
        }

        .sidebar-content {
            text-align: center;
            padding: 30px;
            z-index: 2;
        }

        .sidebar-content h1 {
            font-size: 2.3rem;
            font-weight: 600;
            margin-bottom: 12px;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.15);
            letter-spacing: 1px;
        }

        .sidebar-content p {
            font-size: 1.1rem;
            margin-bottom: 25px;
            font-weight: 500;
            line-height: 1.5;
        }

        .btn-outline {
            border: 2px solid var(--white);
            padding: 10px 30px;
            border-radius: 30px;
            color: var(--white);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
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

        /* --- Cột phải: Form --- */
        .form-box {
            width: 55%;
            padding: 35px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--white);
        }

        .login-header {
            text-align: center;
            margin-bottom: 15px;
        }

        .login-header h2 {
            font-size: 26px;
            color: var(--primary);
            font-weight: 800;
            letter-spacing: 1px;
            margin-top: 10px;
        }

        .form-description {
            text-align: center;
            color: #666;
            font-size: 14px;
            margin-bottom: 25px;
            line-height: 1.6;
            padding: 0 10px;
        }

        .input-group {
            position: relative;
            margin-bottom: 20px;
        }

        .input-group i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: 0.3s;
            font-size: 1.05rem;
        }

        .input-group input {
            width: 100%;
            padding: 14px 15px 14px 50px;
            border: 1.5px solid #eaeaea;
            border-radius: 12px;
            font-size: 14px;
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

        /* Styles cho thông báo lỗi và thành công */
        .error-message {
            background-color: #fff0f0;
            color: #d63031;
            padding: 12px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 500;
            text-align: center;
            margin-bottom: 15px;
            border: 1px solid #ffcccc;
        }

        .success-message {
            background-color: #f0fff4;
            color: #27ae60;
            padding: 12px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 500;
            text-align: center;
            margin-bottom: 15px;
            border: 1px solid #c3e6cb;
        }

        .login-btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 12px;
            background: var(--primary);
            color: white;
            font-size: 15px;
            font-weight: 700;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.2);
            margin-top: 10px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.35);
            background: var(--primary-hover);
        }

        .back-home {
            margin-top: 30px;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 20px;
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
            transform: translateX(-3px);
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

            .sidebar-content { padding: 0; }
            .sidebar-content h1 { font-size: 2.5rem; margin-bottom: 5px; }
            .sidebar-content p { display: none; }
            .sidebar-content .btn-outline {
                padding: 8px 25px;
                font-size: 0.9rem;
                margin-top: 10px;
            }

            .form-box {
                width: 100%;
                padding: 30px 20px;
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
            <p style="font-size: 0.95rem; margin-bottom: 15px; opacity: 0.9; font-weight: 400;">Bạn đã nhớ lại mật khẩu?</p>
            <a href="${pageContext.request.contextPath}/authPage/login.jsp" class="btn-outline">ĐĂNG NHẬP NGAY</a>
        </div>
    </div>

    <div class="form-box">
        <div class="login-header">
            <h2>QUÊN MẬT KHẨU</h2>
        </div>

        <p class="form-description">
            Vui lòng nhập địa chỉ email bạn đã sử dụng để đăng ký. Chúng tôi sẽ gửi một liên kết để giúp bạn đặt lại mật khẩu.
        </p>

        <form action="${pageContext.request.contextPath}/forget-password" method="post">

            <div class="input-group">
                <input type="email" name="email" placeholder="Nhập địa chỉ email của bạn" required autocomplete="email">
                <i class="fa-regular fa-envelope"></i>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="success-message">
                    <i class="fa-solid fa-circle-check"></i> ${message}
                </div>
            </c:if>

            <button type="submit" class="login-btn">GỬI YÊU CẦU</button>
        </form>

        <div class="back-home">
            <a href="${pageContext.request.contextPath}/">
                Trang chủ <i class="fa-solid fa-house"></i>
            </a>
        </div>
    </div>
</div>

</body>
</html>