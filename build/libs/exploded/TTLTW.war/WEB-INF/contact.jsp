<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ | Sweet Oven</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        /* ══════════════════════════════════════════
           CONTACT PAGE
        ══════════════════════════════════════════ */

        /* ── Page header banner ── */
        .contact-page-header {
            background: #FAF7F2;
            border-bottom: 1px solid #EAE0D5;
            padding: 52px 0 48px;
            position: relative;
            overflow: hidden;
        }
        /* họa tiết SVG nền giống featured-section */
        .contact-page-header-bg {
            position: absolute;
            inset: 0;
            pointer-events: none;
            z-index: 0;
        }
        .contact-page-header-inner {
            max-width: 1160px;
            margin: 0 auto;
            padding: 0 28px;
            position: relative;
            z-index: 1;
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 40px;
            flex-wrap: wrap;
        }
        .contact-page-header-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 3.5px;
            text-transform: uppercase;
            color: #D9A273;
            margin-bottom: 14px;
        }
        .contact-page-header-eyebrow-line {
            display: block;
            width: 28px;
            height: 1px;
            background: #D9A273;
            opacity: 0.7;
        }
        .contact-page-header h1 {
            font-size: 2.6rem;
            font-weight: 700;
            color: #3C2F27;
            margin: 0;
            letter-spacing: 4px;
            text-transform: uppercase;
            line-height: 1.1;
        }
        .contact-page-header-right {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 16px;
            padding-bottom: 4px;
            max-width: 340px;
        }
        .contact-page-header-desc {
            color: #9E8F85;
            font-size: 0.88rem;
            font-weight: 400;
            line-height: 1.8;
            text-align: right;
            margin: 0;
        }
        .contact-page-header-divider {
            display: block;
            width: 40px;
            height: 2px;
            background: #D9A273;
            border-radius: 1px;
        }
        /* breadcrumb nhỏ */
        .contact-breadcrumb {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 11px;
            color: #A89890;
            font-weight: 500;
            margin-bottom: 18px;
        }
        .contact-breadcrumb a {
            color: #A89890;
            text-decoration: none;
            transition: color 0.2s;
        }
        .contact-breadcrumb a:hover { color: #D9A273; }
        .contact-breadcrumb-sep { opacity: 0.5; }
        .contact-breadcrumb-current { color: #3C2F27; font-weight: 600; }

        /* ── Main section ── */
        .contact-section {
            background: #FAF7F2;
            padding: 52px 0 80px;
        }
        .contact-inner {
            max-width: 1160px;
            margin: 0 auto;
            padding: 0 28px;
        }

        /* ── Content grid ── */
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1.3fr;
            gap: 28px;
            align-items: start;
        }

        /* ── Sticky form column ── */
        .contact-form-sticky {
            position: sticky;
            top: 88px;
        }

        /* ── Cards — border-radius 14px đồng bộ product-card ── */
        .contact-card {
            background: #ffffff;
            border: 1px solid #ECE5DD;
            border-radius: 14px;
            padding: 28px 30px;
            box-shadow: 0 2px 12px rgba(60, 47, 39, 0.07);
            transition: border-color 0.22s ease, box-shadow 0.22s ease;
        }
        .contact-card:hover {
            border-color: #D9C4AC;
            box-shadow: 0 4px 20px rgba(60, 47, 39, 0.11);
        }
        .contact-card + .contact-card {
            margin-top: 16px;
        }
        .contact-card-title {
            font-size: 0.68rem;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #D9A273;
            margin-bottom: 20px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        .contact-card-title::before {
            content: '';
            display: block;
            width: 20px;
            height: 1px;
            background: #D9A273;
            flex-shrink: 0;
        }

        /* Info items */
        .contact-info-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 13px 0;
            border-bottom: 1px solid #F0EAE2;
        }
        .contact-info-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
        .contact-info-icon {
            width: 36px;
            height: 36px;
            background: #FAF5EE;
            border: 1px solid #EAD9C8;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #D9A273;
            font-size: 13px;
            flex-shrink: 0;
        }
        .contact-info-text { flex: 1; }
        .contact-info-label {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #A89890;
            margin-bottom: 2px;
        }
        .contact-info-value {
            font-size: 0.88rem;
            font-weight: 600;
            color: #3C2F27;
        }

        /* Hours */
        .contact-hours-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            font-size: 0.85rem;
            border-bottom: 1px dashed #EAE0D5;
        }
        .contact-hours-row:last-child { border-bottom: none; }
        .contact-hours-day  { color: #3C2F27; font-weight: 600; }
        .contact-hours-time { color: #9E8F85; font-weight: 400; }
        .contact-hours-open {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #22c55e;
        }
        .contact-hours-open::before {
            content: '';
            display: block;
            width: 6px; height: 6px;
            border-radius: 50%;
            background: #22c55e;
        }

        /* Map */
        .contact-map-wrap iframe {
            width: 100%;
            height: 220px;
            border: none;
            display: block;
            border-radius: 14px;
        }

        /* ── Form card ── */
        .contact-form-card {
            background: #ffffff;
            border: 1px solid #ECE5DD;
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(60, 47, 39, 0.07);
            overflow: hidden;
        }
        .contact-form-header {
            background: #3C2F27;
            padding: 28px 32px;
        }
        .contact-form-header-eyebrow {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #D9A273;
            margin-bottom: 8px;
        }
        .contact-form-header h3 {
            font-size: 1.35rem;
            font-weight: 700;
            color: #ffffff;
            margin: 0;
            letter-spacing: 0.5px;
        }
        .contact-form-header p {
            font-size: 0.82rem;
            color: rgba(255,255,255,0.55);
            margin: 8px 0 0;
            font-weight: 400;
        }
        .contact-form-body { padding: 32px; }

        /* Form fields */
        .contact-field-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 14px;
        }
        .contact-field { margin-bottom: 14px; }
        .contact-field label {
            display: block;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #3C2F27;
            margin-bottom: 7px;
        }
        .contact-field input,
        .contact-field textarea {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid #ECE5DD;
            border-radius: 9px;
            font-family: 'Quicksand', sans-serif;
            font-size: 0.88rem;
            font-weight: 500;
            color: #3C2F27;
            background: #FDFAF6;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
            -webkit-appearance: none;
        }
        .contact-field input::placeholder,
        .contact-field textarea::placeholder {
            color: #C4B5AB;
            font-weight: 400;
        }
        .contact-field input:focus,
        .contact-field textarea:focus {
            border-color: #D9A273;
            box-shadow: 0 0 0 3px rgba(217, 162, 115, 0.12);
            background: #fff;
        }
        .contact-field textarea {
            resize: vertical;
            min-height: 130px;
        }
        .contact-field-group .contact-field { margin-bottom: 0; }

        /* Submit button */
        .contact-btn-submit {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 0.85rem 2.4rem;
            background: #3C2F27;
            color: #ffffff;
            font-family: 'Quicksand', sans-serif;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            border: 2px solid #3C2F27;
            border-radius: 9px;
            cursor: pointer;
            transition: background 0.22s ease, color 0.22s ease;
            margin-top: 6px;
        }
        .contact-btn-submit:hover:not(:disabled) {
            background: transparent;
            color: #3C2F27;
        }
        .contact-btn-submit:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }

        /* ── Toast ── */
        #toast-container {
            position: fixed;
            top: 76px; right: 16px;
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
            box-shadow: 0 4px 16px rgba(44,34,24,.13);
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
            flex: 1; font-size: 13px; color: #3C2F27;
            line-height: 1.4; font-weight: 500;
        }
        .toast-notify .toast-close {
            background: none; border: none; color: #bbb;
            font-size: 14px; cursor: pointer;
            padding: 2px 4px; border-radius: 4px; transition: color .15s;
        }
        .toast-notify .toast-close:hover { color: #555; }
        .toast-notify .toast-progress {
            position: absolute; bottom: 0; left: 0; height: 2px;
            animation: toastProgress 3.5s linear forwards;
        }
        .toast-notify.success .toast-progress { background: #2e9e5b; }
        .toast-notify.error   .toast-progress { background: #e04040; }

        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(30px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes slideOutRight {
            from { opacity: 1; transform: translateX(0); }
            to   { opacity: 0; transform: translateX(30px); }
        }
        @keyframes toastProgress {
            from { width: 100%; }
            to   { width: 0; }
        }

        /* ── Responsive ── */
        @media (max-width: 900px) {
            .contact-grid { grid-template-columns: 1fr; }
            .contact-page-header-right { align-items: flex-start; }
            .contact-page-header-desc  { text-align: left; }
            .contact-page-header-inner { flex-direction: column; align-items: flex-start; gap: 16px; }
            .contact-form-sticky { position: static; }
        }
        @media (max-width: 576px) {
            .contact-page-header { padding: 36px 0 32px; }
            .contact-page-header h1 { font-size: 1.9rem; }
            .contact-page-header-inner { padding: 0 18px; }
            .contact-field-group { grid-template-columns: 1fr; }
            .contact-form-body { padding: 24px 20px; }
            .contact-inner { padding: 0 18px; }
            .contact-section { padding: 36px 0 60px; }
        }
    </style>
</head>

<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="contact"/>
</jsp:include>

<!-- ══════════════════════════════════════════════
     PAGE HEADER
══════════════════════════════════════════════ -->
<div class="contact-page-header">

    <!-- Họa tiết nền SVG — giống featured-section -->
    <div class="contact-page-header-bg" aria-hidden="true">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
            <defs>
                <pattern id="contact-pattern" x="0" y="0" width="120" height="120" patternUnits="userSpaceOnUse">
                    <ellipse cx="20" cy="18" rx="3.5" ry="6" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.18" transform="rotate(-20 20 18)"/>
                    <ellipse cx="26" cy="14" rx="3" ry="5.5" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.18" transform="rotate(-35 26 14)"/>
                    <line x1="22" y1="22" x2="22" y2="36" stroke="#C9A96E" stroke-width="1" opacity="0.15"/>
                    <rect x="72" y="60" width="4" height="18" rx="2" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.14" transform="rotate(30 74 69)"/>
                    <ellipse cx="74" cy="58" rx="5" ry="3" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.14" transform="rotate(30 74 58)"/>
                    <ellipse cx="95" cy="20" rx="10" ry="6" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.13"/>
                    <path d="M85 20 Q95 12 105 20" fill="none" stroke="#C9A96E" stroke-width="1" opacity="0.13"/>
                    <circle cx="50" cy="90" r="1.5" fill="#C9A96E" opacity="0.15"/>
                    <circle cx="10" cy="75" r="1" fill="#C9A96E" opacity="0.12"/>
                    <circle cx="110" cy="100" r="1.5" fill="#C9A96E" opacity="0.13"/>
                </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#contact-pattern)"/>
        </svg>
    </div>

    <div class="contact-page-header-inner">
        <div>
            <!-- Breadcrumb -->
            <div class="contact-breadcrumb">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <span class="contact-breadcrumb-sep"><i class="fa fa-chevron-right" style="font-size:8px"></i></span>
                <span class="contact-breadcrumb-current">Liên hệ</span>
            </div>
            <!-- Eyebrow + Title -->
            <div class="contact-page-header-eyebrow">
                <span class="contact-page-header-eyebrow-line"></span>
                <span>Sweet Oven Bakery</span>
            </div>
            <h1>LIÊN HỆ<br>& HỖ TRỢ</h1>
        </div>

        <div class="contact-page-header-right">
            <p class="contact-page-header-desc">
                Đội ngũ Sweet Oven luôn sẵn sàng<br>
                hỗ trợ bạn trong giờ làm việc.<br>
                Phản hồi trong vòng 24 giờ.
            </p>
            <span class="contact-page-header-divider"></span>
        </div>
    </div>
</div>

<!-- ══════════════════════════════════════════════
     MAIN CONTENT
══════════════════════════════════════════════ -->
<section class="contact-section">
    <div class="contact-inner">
        <div class="contact-grid">

            <!-- ── LEFT: Thông tin ── -->
            <div>
                <!-- Info card -->
                <div class="contact-card">
                    <div class="contact-card-title">Thông tin liên hệ</div>

                    <div class="contact-info-item">
                        <div class="contact-info-icon"><i class="fa fa-location-dot"></i></div>
                        <div class="contact-info-text">
                            <div class="contact-info-label">Địa chỉ</div>
                            <div class="contact-info-value">123 Đường Ngọt Ngào, TP.HCM</div>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="contact-info-icon"><i class="fa fa-phone"></i></div>
                        <div class="contact-info-text">
                            <div class="contact-info-label">Điện thoại</div>
                            <div class="contact-info-value">0909 123 456</div>
                        </div>
                    </div>
                    <div class="contact-info-item">
                        <div class="contact-info-icon"><i class="fa fa-envelope"></i></div>
                        <div class="contact-info-text">
                            <div class="contact-info-label">Email</div>
                            <div class="contact-info-value">sweetoven@gmail.com</div>
                        </div>
                    </div>
                </div>

                <!-- Hours card -->
                <div class="contact-card">
                    <div class="contact-card-title">Giờ mở cửa</div>
                    <div class="contact-hours-row">
                        <span class="contact-hours-day">Thứ 2 – Thứ 6</span>
                        <span class="contact-hours-time">07:00 – 21:00</span>
                    </div>
                    <div class="contact-hours-row">
                        <span class="contact-hours-day">Thứ 7</span>
                        <span class="contact-hours-time">07:00 – 22:00</span>
                    </div>
                    <div class="contact-hours-row">
                        <span class="contact-hours-day">Chủ nhật</span>
                        <span class="contact-hours-time">08:00 – 20:00</span>
                    </div>
                    <div class="contact-hours-row" style="padding-top:12px;">
                        <span class="contact-hours-open">Đang mở cửa</span>
                        <span style="font-size:11px;color:#9E8F85;">Hôm nay: 07:00 – 21:00</span>
                    </div>
                </div>

                <!-- Map card -->
                <div class="contact-card" style="padding:0;overflow:hidden;">
                    <iframe
                            src="https://www.google.com/maps?q=Ho+Chi+Minh&output=embed"
                            title="Bản đồ Sweet Oven"
                            loading="lazy"
                            allowfullscreen>
                    </iframe>
                </div>
            </div>

            <!-- ── RIGHT: Form (sticky) ── -->
            <div class="contact-form-sticky">
                <div class="contact-form-card">
                    <div class="contact-form-header">
                        <div class="contact-form-header-eyebrow">Gửi tin nhắn</div>
                        <h3>Chúng tôi muốn nghe từ bạn</h3>
                        <p>Điền thông tin bên dưới — chúng tôi sẽ phản hồi sớm nhất có thể.</p>
                    </div>

                    <div class="contact-form-body">
                        <form id="contactForm" action="${pageContext.request.contextPath}/contact" method="post" novalidate>

                            <div class="contact-field-group">
                                <div class="contact-field">
                                    <label for="fullName">Họ và tên <span style="color:#D9A273">*</span></label>
                                    <input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A" required>
                                </div>
                                <div class="contact-field">
                                    <label for="phoneNumber">Số điện thoại</label>
                                    <input type="text" id="phoneNumber" name="phoneNumber" placeholder="0909 000 000">
                                </div>
                            </div>

                            <div class="contact-field">
                                <label for="email">Email <span style="color:#D9A273">*</span></label>
                                <input type="email" id="email" name="email" placeholder="example@email.com" required>
                            </div>

                            <div class="contact-field">
                                <label for="content">Nội dung <span style="color:#D9A273">*</span></label>
                                <textarea id="content" name="content" placeholder="Viết nội dung bạn muốn gửi đến Sweet Oven..." required></textarea>
                            </div>

                            <button type="submit" id="submitBtn" class="contact-btn-submit">
                                <i class="fas fa-paper-plane"></i>
                                Gửi liên hệ
                            </button>

                        </form>
                    </div>
                </div>
            </div>

        </div><!-- /contact-grid -->
    </div><!-- /contact-inner -->
</section>

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
            '<button class="toast-close" onclick="closeToast(\'' + id + '\')">&#x2715;</button>' +
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

    document.getElementById('contactForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang gửi...';

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
            .catch(() => showToast('error', 'Không thể kết nối đến máy chủ.'))
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-paper-plane"></i> Gửi liên hệ';
            });
    });
</script>
</body>
</html>
