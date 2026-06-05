<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký | Sweet Oven Bakery</title>

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

        body.signup-page {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: var(--bg-color);
            padding: 20px;
        }

        /* Container chính đã được thu nhỏ */
        .signup-container {
            width: 900px; /* Thu nhỏ từ 1000px xuống 900px */
            max-width: 100%;
            min-height: 560px; /* Thu nhỏ chiều cao tương ứng */
            background: var(--white);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(139, 69, 19, 0.08);
            display: flex;
            overflow: hidden;
            position: relative;
        }

        /* --- Cột trái: Form Đăng ký --- */
        .form-box {
            width: 55%;
            padding: 35px 40px; /* Giảm padding để fit với khung nhỏ hơn */
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--white);
        }

        .header-title {
            text-align: center;
            margin-bottom: 20px; /* Căn chỉnh lại margin */
        }

        .header-title h2 {
            font-size: 26px; /* Giảm nhẹ font size */
            color: var(--primary);
            font-weight: 800;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 15px; /* Thu hẹp khoảng cách giữa các ô */
            margin-bottom: 12px;
        }

        .full-width {
            grid-column: span 2;
        }

        .input-group {
            position: relative;
        }

        .input-group i:not(.toggle-password) {
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
            padding: 14px 15px 14px 50px; /* Làm cho ô nhập liệu thanh mảnh hơn */
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

        .input-group input:focus + i:not(.toggle-password) {
            color: var(--primary);
        }

        /* --- Nút ẩn/hiện mật khẩu --- */
        .input-group .toggle-password {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            cursor: pointer;
            font-size: 1.05rem;
            transition: 0.3s;
        }

        .input-group .toggle-password:hover {
            color: var(--primary);
        }

        .input-group input#password,
        .input-group input#confirmPassword {
            padding-right: 45px;
        }

        /* --- CSS CHO BẢNG ĐIỀU KIỆN MẬT KHẨU --- */
        .password-requirements {
            background: #fdfdfd;
            padding: 12px 15px;
            border-radius: 12px;
            border: 1px solid #eaeaea;
            display: block;
            transition: all 0.3s ease;
            grid-column: span 2;
        }

        .req-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 8px;
        }

        .req-list {
            list-style: none;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .req-list li {
            font-size: 12.5px;
            color: #999;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
        }

        .req-list li.valid {
            color: #27ae60;
            font-weight: 600;
        }

        .req-list li i {
            font-size: 13px;
            transition: 0.3s;
        }

        .req-list li.valid i {
            color: #27ae60;
        }
        /* -------------------------------------- */

        .terms {
            margin-bottom: 20px;
            font-size: 13.5px;
            color: #555;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }

        .terms a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
            transition: 0.3s;
        }

        .terms a:hover {
            text-decoration: underline;
        }

        .terms input[type="checkbox"] {
            accent-color: var(--primary);
            width: 15px;
            height: 15px;
            cursor: pointer;
        }

        .signup-btn {
            width: 100%;
            padding: 14px; /* Thu nhỏ nút bấm */
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
        }

        .signup-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.35);
            background: var(--primary-hover);
        }

        /* --- Cột phải: Sidebar trơn --- */
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

        /* Thông báo trạng thái */
        .error-message {
            background-color: #fff0f0;
            color: #d63031;
            padding: 10px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 500;
            text-align: center;
            margin-bottom: 15px;
            border: 1px solid #ffcccc;
        }

        .success-message {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 15px;
            font-size: 13.5px;
            font-weight: 600;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .signup-container {
                flex-direction: column-reverse;
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

            .form-box {
                width: 100%;
                padding: 30px 20px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: span 1;
            }

            .req-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body class="signup-page">

<div class="signup-container">

    <div class="form-box">
        <div class="header-title">
            <h2>ĐĂNG KÝ</h2>
        </div>

        <form id="signupForm" action="register" method="post">

            <div id="js-error" class="error-message" style="display: none;">
                <i class="fa-solid fa-circle-exclamation"></i> <span id="js-error-text"></span>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="success-message">
                    <i class="fa-solid fa-circle-check"></i> ${successMessage}
                </div>
            </c:if>

            <div class="form-grid">
                <div class="input-group full-width">
                    <input type="text" name="fullName" value="${fullName}" id="fullName" placeholder="Họ và tên của bạn" required autocomplete="off">
                    <i class="fa-regular fa-address-card"></i>
                </div>

                <div class="input-group">
                    <input type="email" name="email" value="${email}" id="email" placeholder="Email" required autocomplete="off">
                    <i class="fa-regular fa-envelope"></i>
                </div>

                <div class="input-group">
                    <input type="tel" name="phone" value="${phone}" id="phone" placeholder="Số điện thoại" required autocomplete="off">
                    <i class="fa-solid fa-phone"></i>
                </div>

                <div class="input-group full-width">
                    <input type="text" name="username" value="${username}" id="username" placeholder="Tên đăng nhập" required autocomplete="off">
                    <i class="fa-regular fa-user"></i>
                </div>

                <div class="input-group">
                    <input type="password" name="password" id="password" placeholder="Mật khẩu" required>
                    <i class="fa-solid fa-lock"></i>
                    <i class="fa-regular fa-eye toggle-password" data-target="password"></i>
                </div>

                <div class="input-group">
                    <input type="password" id="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    <i class="fa-solid fa-check-double"></i>
                    <i class="fa-regular fa-eye toggle-password" data-target="confirmPassword"></i>
                </div>

                <div class="password-requirements" id="password-reqs">
                    <p class="req-title">Mật khẩu của bạn phải có:</p>
                    <ul class="req-list">
                        <li id="req-length"><i class="fa-regular fa-circle-xmark"></i> Ít nhất 8 ký tự</li>
                        <li id="req-upper"><i class="fa-regular fa-circle-xmark"></i> 1 chữ cái in hoa</li>
                        <li id="req-lower"><i class="fa-regular fa-circle-xmark"></i> 1 chữ cái in thường</li>
                        <li id="req-number"><i class="fa-regular fa-circle-xmark"></i> 1 chữ số</li>
                        <li id="req-special"><i class="fa-regular fa-circle-xmark"></i> 1 ký tự đặc biệt (@, #, $...)</li>
                    </ul>
                </div>
            </div>

            <div class="terms">
                <input type="checkbox" id="terms" required>
                <label for="terms">Tôi đồng ý với <a href="#">Điều khoản sử dụng</a></label>
            </div>

            <button type="submit" class="signup-btn">TẠO TÀI KHOẢN</button>
        </form>
    </div>

    <div class="sidebar">
        <div class="sidebar-content">
            <h1>Sweet Oven</h1>
            <p>Bạn đã là thành viên của<br>đại gia đình Sweet Oven?</p>
            <a href="${contextPath}/login" class="btn-outline">ĐĂNG NHẬP NGAY</a>
        </div>
    </div>

</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const signupForm = document.getElementById('signupForm');
        const jsErrorBox = document.getElementById('js-error');
        const jsErrorText = document.getElementById('js-error-text');

        // Các biến cho phần kiểm tra mật khẩu
        const passwordInput = document.getElementById('password');

        const reqNodes = {
            length: document.getElementById('req-length'),
            upper: document.getElementById('req-upper'),
            lower: document.getElementById('req-lower'),
            number: document.getElementById('req-number'),
            special: document.getElementById('req-special')
        };

        const regexRules = {
            length: val => val.length >= 8,
            upper: val => /[A-Z]/.test(val),
            lower: val => /[a-z]/.test(val),
            number: val => /[0-9]/.test(val),
            special: val => /[^A-Za-z0-9]/.test(val)
        };

        function updateRequirement(element, isValid) {
            const icon = element.querySelector('i');
            if (isValid) {
                element.classList.add('valid');
                icon.classList.remove('fa-regular', 'fa-circle-xmark');
                icon.classList.add('fa-solid', 'fa-circle-check');
            } else {
                element.classList.remove('valid');
                icon.classList.remove('fa-solid', 'fa-circle-check');
                icon.classList.add('fa-regular', 'fa-circle-xmark');
            }
        }

        passwordInput.addEventListener('input', function(e) {
            const val = e.target.value;

            updateRequirement(reqNodes.length, regexRules.length(val));
            updateRequirement(reqNodes.upper, regexRules.upper(val));
            updateRequirement(reqNodes.lower, regexRules.lower(val));
            updateRequirement(reqNodes.number, regexRules.number(val));
            updateRequirement(reqNodes.special, regexRules.special(val));
        });

        // Xử lý nút ẩn/hiện mật khẩu
        const togglePasswordButtons = document.querySelectorAll('.toggle-password');
        togglePasswordButtons.forEach(button => {
            button.addEventListener('click', function() {
                const targetId = this.getAttribute('data-target');
                const targetInput = document.getElementById(targetId);

                const type = targetInput.getAttribute('type') === 'password' ? 'text' : 'password';
                targetInput.setAttribute('type', type);

                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
        });

        function showError(message) {
            jsErrorText.textContent = message;
            jsErrorBox.style.display = 'block';
            jsErrorBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        signupForm.addEventListener('submit', function (event) {
            jsErrorBox.style.display = 'none';

            const password = passwordInput.value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms').checked;

            if (password !== confirmPassword) {
                event.preventDefault();
                showError('Mật khẩu xác nhận không khớp!');
                return;
            }

            const isPasswordValid = Object.values(regexRules).every(rule => rule(password));

            if (!isPasswordValid) {
                event.preventDefault();
                showError('Vui lòng đảm bảo mật khẩu đạt đủ tất cả các điều kiện bảo mật bên dưới!');
                passwordInput.focus();
                return;
            }

            if (!terms) {
                event.preventDefault();
                showError('Vui lòng đồng ý điều khoản sử dụng!');
                return;
            }
        });
    });
</script>
</body>

</html>