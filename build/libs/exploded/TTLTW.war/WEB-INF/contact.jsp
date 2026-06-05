<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Liên hệ | Sweet Oven</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        .contact-page {
            font-family: 'Quicksand', sans-serif;
            --primary:#8B4513;
            --secondary:#D4A76A;
            --light:#FFF9F0;
        }

        .contact-page .hero {
            padding:120px 20px 60px;
            text-align:center;
            background:linear-gradient(135deg,var(--light),#f5e6c6);
        }

        .contact-page .hero h1 {
            font-size:2.8rem;
            font-weight:700;
            color:var(--primary);
        }

        .contact-page .hero p {
            color:#6b4f2d;
        }

        .contact-page .wrapper {
            max-width:1200px;
            margin:auto;
            padding:40px 20px;
        }

        .contact-page .grid {
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:30px;
        }

        .contact-page .card {
            background:white;
            padding:30px;
            border-radius:20px;
            box-shadow:0 10px 25px rgba(0,0,0,0.08);
        }

        .contact-page h3 {
            color:var(--primary);
            font-weight:700;
            margin-bottom:20px;
        }

        .contact-page input,
        .contact-page textarea {
            width:100%;
            padding:12px;
            border-radius:10px;
            border:1px solid #ddd;
            margin-bottom:15px;
        }

        .contact-page button {
            background:var(--secondary);
            border:none;
            padding:12px;
            border-radius:25px;
            width:100%;
            font-weight:600;
        }

        .contact-page button:hover {
            background:#c89555;
        }

        .contact-page iframe {
            width:100%;
            border-radius:15px;
            height:250px;
            border:none;
        }

        @media(max-width:768px){
            .contact-page .grid {
                grid-template-columns:1fr;
            }
        }
        /* ── Toast ── */
        #toast-container {
            position: fixed;
            top: 76px;
            right: 16px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 8px;
            pointer-events: none;
        }
        .toast-notify {
            width: 300px;
            padding: 10px 12px 10px 14px;
            border-radius: 10px;
            background: #fff;
            display: flex;
            align-items: center;
            gap: 9px;
            box-shadow: 0 4px 16px rgba(0,0,0,.12);
            border-left: 4px solid #ccc;
            pointer-events: all;
            animation: slideInRight .28s cubic-bezier(.22,.68,0,1.2) forwards;
            position: relative;
            overflow: hidden;
        }
        .toast-notify.success { border-left-color: #2e9e5b; }
        .toast-notify.error   { border-left-color: #e04040; }
        .toast-notify .toast-icon { font-size: 15px; flex-shrink: 0; }
        .toast-notify.success .toast-icon { color: #2e9e5b; }
        .toast-notify.error   .toast-icon { color: #e04040; }
        .toast-notify .toast-msg {
            flex: 1;
            font-size: 13px;
            color: #333;
            line-height: 1.4;
            font-weight: 500;
        }
        .toast-notify .toast-close {
            background: none;
            border: none;
            color: #bbb;
            font-size: 14px;
            cursor: pointer;
            padding: 2px 4px;
            border-radius: 4px;
            transition: color .15s;
        }
        .toast-notify .toast-close:hover { color: #555; }
        .toast-notify .toast-progress {
            position: absolute;
            bottom: 0; left: 0;
            height: 2px;
            border-radius: 0 0 0 10px;
            animation: toastProgress 3.5s linear forwards;
        }
        .toast-notify.success .toast-progress { background: #2e9e5b; }
        .toast-notify.error   .toast-progress { background: #e04040; }
        .contact-page button:disabled {
            opacity: .65;
            cursor: not-allowed;
        }
    </style>
</head>

<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="contact"/>
</jsp:include>

<div class="contact-page">

    <section class="hero">
        <h1>Liên hệ với chúng tôi</h1>
        <p>Sweet Oven luôn sẵn sàng hỗ trợ bạn 💛</p>
    </section>

    <div class="wrapper">
        <div class="grid">

            <!-- LEFT -->
            <div>
                <div class="card info">
                    <h3>Thông tin</h3>
                    <p><i class="fa fa-location-dot"></i> 123 Đường Ngọt Ngào, TP.HCM</p>
                    <p><i class="fa fa-phone"></i> 0909 123 456</p>
                    <p><i class="fa fa-envelope"></i> sweetoven@gmail.com</p>
                </div>

                <div class="card mt-4">
                    <h3>Bản đồ</h3>
                    <iframe src="https://www.google.com/maps?q=Ho+Chi+Minh&output=embed"></iframe>
                </div>
            </div>

            <!-- RIGHT -->
            <div class="card">
                <h3>Gửi tin nhắn</h3>
                <form id="contactForm" action="${pageContext.request.contextPath}/contact" method="post">
                    <input type="text"  id="fullName"    name="fullName"    placeholder="Họ và tên" required>
                    <input type="email" id="email"       name="email"       placeholder="Email" required>
                    <input type="text"  id="phoneNumber" name="phoneNumber" placeholder="Số điện thoại">
                    <textarea           id="content"     name="content"     placeholder="Nội dung" required></textarea>
                    <button type="submit" id="submitBtn">Gửi liên hệ</button>
                </form>

            </div>

        </div>
    </div>

</div>

<jsp:include page="/components/footer.jsp"/>
<div id="toast-container"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let toastCount = 0;
    function showToast(type, msg) {
        const id = 'toast-' + (++toastCount);
        const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-xmark';
        const el = document.createElement('div');
        el.className = 'toast-notify ' + type;
        el.id = id;
        el.innerHTML =
            '<span class="toast-icon"><i class="fa ' + icon + '"></i></span>' +
            '<span class="toast-msg">' + msg + '</span>' +
            '<button class="toast-close" onclick="closeToast(\''+id+'\')">&#x2715;</button>' +
            '<div class="toast-progress"></div>';
        document.getElementById('toast-container').appendChild(el);
        setTimeout(() => closeToast(id), 3500);
    }
    function closeToast(id) {
        const el = document.getElementById(id);
        if (!el) return;
        el.style.animation = 'slideOutRight .3s ease forwards';
        setTimeout(() => el.remove(), 300);
    }

    /* ── AJAX gửi form ── */
    document.getElementById('contactForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.textContent = 'Đang gửi...';

        const body = new URLSearchParams({
            fullName:    document.getElementById('fullName').value,
            email:       document.getElementById('email').value,
            phoneNumber: document.getElementById('phoneNumber').value,
            content:     document.getElementById('content').value
        });

        fetch('${pageContext.request.contextPath}/contact', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: body.toString()
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    showToast('success', data.message);
                    document.getElementById('contactForm').reset();
                } else {
                    showToast('error', data.message || 'Có lỗi xảy ra, vui lòng thử lại.');
                }
            })
            .catch(() => {
                showToast('error', 'Không thể kết nối đến máy chủ.');
            })
            .finally(() => {
                btn.disabled = false;
                btn.textContent = 'Gửi liên hệ';
            });
    });
</script>
</body>
</html>