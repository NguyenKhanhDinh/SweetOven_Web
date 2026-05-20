<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3C2F27;
            --primary-hover: #6d360f;
            --accent: #D4A76A;
            --bg-color: #F9F6F0;
            --text-main: #333;
            --white: #ffffff;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Quicksand", sans-serif; }
        body.login-page {
            min-height: 100vh; display: flex; justify-content: center;
            align-items: center; background-color: var(--bg-color); padding: 20px;
        }
        .login-container {
            width: 900px; max-width: 100%; min-height: 560px; background: var(--white);
            border-radius: 24px; box-shadow: 0 20px 40px rgba(139,69,19,0.08);
            display: flex; overflow: hidden;
        }
        .sidebar {
            width: 45%; background-color: var(--primary);
            display: flex; flex-direction: column; justify-content: center;
            align-items: center; color: var(--white);
        }
        .sidebar-content { text-align: center; padding: 30px; }
        .sidebar-content h1 { font-size: 2.3rem; font-weight: 600; margin-bottom: 12px; letter-spacing: 1px; }
        .sidebar-content p { font-size: 1.05rem; margin-bottom: 25px; font-weight: 500; line-height: 1.5; }
        .btn-outline {
            border: 2px solid var(--white); padding: 10px 30px; border-radius: 30px;
            color: var(--white); text-decoration: none; font-weight: 600;
            font-size: 0.95rem; letter-spacing: 1px; transition: all 0.3s; display: inline-block;
        }
        .btn-outline:hover { background: var(--white); color: var(--primary); transform: translateY(-2px); }
        .form-box {
            width: 55%; padding: 35px 40px; display: flex;
            flex-direction: column; justify-content: center; background: var(--white);
        }
        .login-header { text-align: center; margin-bottom: 12px; }
        .login-header h2 { font-size: 26px; color: var(--primary); font-weight: 800; letter-spacing: 1px; margin-top: 10px; }
        .form-description { text-align: center; color: #666; font-size: 14px; margin-bottom: 22px; line-height: 1.6; padding: 0 10px; }
        .input-group { position: relative; margin-bottom: 18px; }
        .input-group i.icon-left {
            position: absolute; left: 18px; top: 50%; transform: translateY(-50%);
            color: #aaa; font-size: 1.05rem; pointer-events: none;
        }
        .input-group input {
            width: 100%; padding: 14px 48px 14px 50px; border: 1.5px solid #eaeaea;
            border-radius: 12px; font-size: 14px; font-weight: 500;
            color: var(--text-main); background: #fafafa; transition: all 0.3s;
        }
        .input-group input::placeholder { color: #999; font-weight: 400; }
        .input-group input:focus {
            outline: none; border-color: var(--accent); background: var(--white);
            box-shadow: 0 0 0 4px rgba(212,167,106,0.15);
        }
        .toggle-password {
            position: absolute; right: 16px; top: 50%; transform: translateY(-50%);
            color: #aaa; cursor: pointer; font-size: 1rem; transition: color 0.2s;
        }
        .toggle-password:hover { color: var(--primary); }
        .hint { font-size: 12px; color: #999; margin-top: -10px; margin-bottom: 12px; padding-left: 4px; }
        .error-message {
            background-color: #fff0f0; color: #d63031; padding: 12px; border-radius: 10px;
            font-size: 13.5px; font-weight: 500; text-align: center;
            margin-bottom: 15px; border: 1px solid #ffcccc;
        }
        .success-message {
            background-color: #f0fff4; color: #27ae60; padding: 14px; border-radius: 10px;
            font-size: 13.5px; font-weight: 500; text-align: center;
            margin-bottom: 15px; border: 1px solid #c3e6cb; line-height: 1.6;
        }
        .warning-message {
            background-color: #fffbf0; color: #e67e22; padding: 14px; border-radius: 10px;
            font-size: 13.5px; font-weight: 500; text-align: center;
            margin-bottom: 15px; border: 1px solid #fde8c0; line-height: 1.6;
        }
        .login-btn {
            width: 100%; padding: 14px; border: none; border-radius: 12px;
            background: var(--primary); color: white; font-size: 15px; font-weight: 700;
            letter-spacing: 1px; cursor: pointer; transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(139,69,19,0.2); margin-top: 8px;
        }
        .login-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(139,69,19,0.35); background: var(--primary-hover); }
        .back-home {
            margin-top: 28px; text-align: center; display: flex;
            justify-content: center; gap: 20px;
        }
        .back-home a {
            color: #888; text-decoration: none; font-size: 14px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.3s;
        }
        .back-home a:hover { color: var(--primary); }
        @media (max-width: 768px) {
            .login-container { flex-direction: column; width: 100%; border-radius: 20px; }
            .sidebar { width: 100%; padding: 35px 20px; }
            .sidebar-content p { display: none; }
            .form-box { width: 100%; padding: 28px 20px; }
        }
    </style>
</head>
<body class="login-page">
<div class="login-container">
    <div class="sidebar">
        <div class="sidebar-content">
            <h1>Sweet Oven</h1>
            <p>Bánh tươi mỗi ngày, ngọt ngào trọn vị.<br>Cùng khám phá những hương vị tuyệt vời!</p>
            <p style="font-size:0.95rem;margin-bottom:15px;opacity:0.9;font-weight:400;">Bạn đã nhớ lại mật khẩu?</p>
            <a href="${pageContext.request.contextPath}/authPage/login.jsp" class="btn-outline">ĐĂNG NHẬP NGAY</a>
        </div>
    </div>

    <div class="form-box">
        <div class="login-header">
            <h2>ĐẶT LẠI MẬT KHẨU</h2>
        </div>

        <%-- Token lỗi hoặc hết hạn --%>
        <c:if test="${not empty tokenError}">
            <div class="warning-message">
                <i class="fa-solid fa-triangle-exclamation"></i> ${tokenError}
            </div>
            <div class="back-home" style="margin-top:10px;">
                <a href="${pageContext.request.contextPath}/forget-password">
                    <i class="fa-solid fa-rotate-left"></i> Yêu cầu lại liên kết
                </a>
            </div>
        </c:if>

        <%-- Đổi mật khẩu thành công --%>
        <c:if test="${not empty success}">
            <div class="success-message">
                <i class="fa-solid fa-circle-check"></i> ${success}
            </div>
            <div class="back-home" style="margin-top:10px;">
                <a href="${pageContext.request.contextPath}/authPage/login.jsp">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i> Đăng nhập ngay
                </a>
            </div>
        </c:if>

        <%-- Form đặt mật khẩu mới --%>
        <c:if test="${empty tokenError and empty success}">
            <p class="form-description">
                Tạo mật khẩu mới. Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.
            </p>
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/reset-password" method="post">
                <input type="hidden" name="token" value="${token}">
                <div class="input-group">
                    <input type="password" id="newPassword" name="newPassword"
                           placeholder="Mật khẩu mới" required autocomplete="new-password">
                    <i class="fa-solid fa-lock icon-left"></i>
                    <i class="fa-regular fa-eye toggle-password" onclick="togglePassword('newPassword', this)"></i>
                </div>
                <p class="hint">Ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</p>
                <div class="input-group">
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Xác nhận mật khẩu mới" required autocomplete="new-password">
                    <i class="fa-solid fa-lock-open icon-left"></i>
                    <i class="fa-regular fa-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                </div>
                <button type="submit" class="login-btn">XÁC NHẬN ĐỔI MẬT KHẨU</button>
            </form>
        </c:if>

        <div class="back-home">
            <a href="${pageContext.request.contextPath}/authPage/login.jsp">
                <i class="fa-solid fa-arrow-left-long"></i> Quay lại Đăng nhập
            </a>
            <a href="${pageContext.request.contextPath}/">
                Trang chủ <i class="fa-solid fa-house"></i>
            </a>
        </div>
    </div>
</div>
<script>
    function togglePassword(inputId, icon) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }
</script>
</body>
</html>