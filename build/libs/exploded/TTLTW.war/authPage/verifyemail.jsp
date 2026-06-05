<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực Email | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3C2F27;
            --accent:  #D4A76A;
            --bg:      #F9F6F0;
        }
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Quicksand',sans-serif; }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg);
        }

        .card {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(139,69,19,.08);
            padding: 48px 40px 40px;
            width: 440px;
            max-width: 95%;
            text-align: center;
        }

        .icon-wrap {
            width: 72px; height: 72px;
            background: #fef5e8;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px; color: var(--accent);
        }

        h2 { font-size: 22px; color: var(--primary); font-weight: 800; margin-bottom: 8px; }

        .subtitle {
            font-size: 14px; color: #777; line-height: 1.6; margin-bottom: 28px;
        }
        .subtitle b { color: var(--primary); }

        .error-msg {
            background: #fff0f0; border: 1px solid #ffcccc;
            color: #d63031; border-radius: 10px;
            padding: 10px 14px; font-size: 13.5px; margin-bottom: 18px;
        }
        .success-msg {
            background: #d4edda; border: 1px solid #c3e6cb;
            color: #155724; border-radius: 10px;
            padding: 10px 14px; font-size: 13.5px; margin-bottom: 18px;
        }

        /* Ô nhập 6 số riêng lẻ */
        .otp-inputs {
            display: flex; gap: 10px; justify-content: center; margin-bottom: 24px;
        }
        .otp-inputs input {
            width: 50px; height: 56px;
            border: 2px solid #eaeaea; border-radius: 12px;
            font-size: 22px; font-weight: 700; text-align: center;
            color: var(--primary); background: #fafafa;
            transition: all .25s;
        }
        .otp-inputs input:focus {
            outline: none; border-color: var(--accent);
            background: #fff; box-shadow: 0 0 0 4px rgba(212,167,106,.15);
        }

        .btn-primary {
            width: 100%; padding: 14px;
            background: var(--primary); color: #fff;
            border: none; border-radius: 12px;
            font-size: 15px; font-weight: 700; letter-spacing: 1px;
            cursor: pointer; transition: all .3s;
        }
        .btn-primary:hover { background: #6d360f; transform: translateY(-2px); }

        .resend-area { margin-top: 20px; font-size: 13.5px; color: #777; }

        /* Đếm ngược */
        #countdown { font-weight: 700; color: var(--primary); }

        .resend-btn {
            background: none; border: none; color: var(--accent);
            font-size: 13.5px; font-weight: 700; cursor: pointer;
            text-decoration: underline; display: none;
        }
        .resend-btn:hover { color: var(--primary); }

        .back-link { display: block; margin-top: 18px; font-size: 13px; color: #aaa; }
        .back-link a { color: var(--primary); font-weight: 700; text-decoration: none; }
    </style>
</head>
<body>
<div class="card">
    <div class="icon-wrap"><i class="fa-regular fa-envelope-open"></i></div>
    <h2>Xác thực Email</h2>
    <p class="subtitle">
        Mã OTP đã được gửi đến<br>
        <b>${sessionScope.pendingEmail}</b><br>
        Vui lòng kiểm tra hộp thư (kể cả mục Spam).
    </p>

    <c:if test="${not empty error}">
        <div class="error-msg"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="success-msg"><i class="fa-solid fa-circle-check"></i> ${success}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-email" method="post">
        <div class="otp-inputs">
            <input type="text" maxlength="1" class="otp-box" id="otp-0" autocomplete="off">
            <input type="text" maxlength="1" class="otp-box" id="otp-1" autocomplete="off">
            <input type="text" maxlength="1" class="otp-box" id="otp-2" autocomplete="off">
            <input type="text" maxlength="1" class="otp-box" id="otp-3" autocomplete="off">
            <input type="text" maxlength="1" class="otp-box" id="otp-4" autocomplete="off">
            <input type="text" maxlength="1" class="otp-box" id="otp-5" autocomplete="off">
        </div>
        <%-- Hidden input tổng hợp 6 ô thành chuỗi để submit --%>
        <input type="hidden" name="otp" id="otpHidden">
        <button type="submit" class="btn-primary">XÁC THỰC NGAY</button>
    </form>

    <div class="resend-area">
        Gửi lại mã sau <span id="countdown">5:00</span>
        <form action="${pageContext.request.contextPath}/resend-otp" method="post" style="display:inline;">
            <button type="submit" class="resend-btn" id="resendBtn">Gửi lại OTP</button>
        </form>
    </div>

    <span class="back-link">
        Nhập sai thông tin? <a href="${pageContext.request.contextPath}/register">Đăng ký lại</a>
    </span>
</div>

<script>
    // ── Ô nhập OTP tự chuyển focus ───────────────────────────────────
    const boxes = document.querySelectorAll('.otp-box');
    boxes.forEach((box, idx) => {
        box.addEventListener('input', e => {
            const val = e.target.value;
            if (val && idx < boxes.length - 1) boxes[idx + 1].focus();
        });
        box.addEventListener('keydown', e => {
            if (e.key === 'Backspace' && !box.value && idx > 0) boxes[idx - 1].focus();
        });
        // Hỗ trợ paste toàn bộ OTP vào ô đầu
        box.addEventListener('paste', e => {
            const pasted = (e.clipboardData || window.clipboardData).getData('text').trim();
            if (/^\d{6}$/.test(pasted)) {
                e.preventDefault();
                [...pasted].forEach((ch, i) => { if (boxes[i]) boxes[i].value = ch; });
                boxes[5].focus();
            }
        });
    });

    // Gộp 6 ô thành hidden input trước khi submit
    document.querySelector('form').addEventListener('submit', function(e) {
        const otp = [...boxes].map(b => b.value).join('');
        if (otp.length !== 6 || !/^\d{6}$/.test(otp)) {
            e.preventDefault();
            alert('Vui lòng nhập đủ 6 chữ số!');
            return;
        }
        document.getElementById('otpHidden').value = otp;
    });

    // ── Đếm ngược 5 phút ─────────────────────────────────────────────
    let seconds = 300;
    const countdownEl = document.getElementById('countdown');
    const resendBtn   = document.getElementById('resendBtn');

    const timer = setInterval(() => {
        seconds--;
        const m = String(Math.floor(seconds / 60)).padStart(1, '0');
        const s = String(seconds % 60).padStart(2, '0');
        countdownEl.textContent = m + ':' + s;

        if (seconds <= 0) {
            clearInterval(timer);
            countdownEl.textContent = '';
            resendBtn.style.display = 'inline';
        }
    }, 1000);
</script>
</body>
</html>