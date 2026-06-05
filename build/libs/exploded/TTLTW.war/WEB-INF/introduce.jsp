<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Giới thiệu về Sweet Oven Bakery - tiệm bánh thủ công với nguyên liệu tự nhiên, tươi mới mỗi ngày.">
    <title>Giới thiệu | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary:      #3C2F27;
            --primary-hover:#5a3d2b;
            --accent:       #D9A273;
            --accent-light: rgba(217, 162, 115, 0.13);
            --bg:           #FFFFFF;
            --bg-alt:       #FAF7F2;
            --text-main:    #333333;
            --text-muted:   #777777;
            --border:       #eaeaea;
            --shadow:       0 4px 20px rgba(60, 47, 39, 0.08);
            --radius:       16px;
            --section-gap:  88px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Quicksand', sans-serif;
            background: var(--bg);
            color: var(--text-main);
            line-height: 1.7;
        }

        /* ── HERO ──────────────────────────────────────────── */
        .hero-section {
            position: relative;
            height: 92vh;
            min-height: 540px;
            background: url('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1600&h=900&fit=crop') center/cover no-repeat;
            display: flex;
            align-items: center;
        }
        .hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(60,47,39,0.88) 0%, rgba(60,47,39,0.55) 60%, rgba(60,47,39,0.2) 100%);
        }
        .hero-content {
            position: relative;
            z-index: 2;
        }
        .hero-eyebrow {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 1rem;
            display: block;
        }
        .hero-title {
            font-size: clamp(2.4rem, 6vw, 4.4rem);
            font-weight: 800;
            color: #ffffff;
            line-height: 1.08;
            margin-bottom: 1rem;
        }
        .hero-title span { color: var(--accent); }
        .hero-sub {
            font-size: 0.95rem;
            color: rgba(255,255,255,0.68);
            font-weight: 500;
            margin-bottom: 2rem;
            letter-spacing: 0.3px;
        }
        .btn-hero {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--accent);
            color: var(--primary);
            font-weight: 700;
            font-size: 0.92rem;
            padding: 0.78rem 1.9rem;
            border-radius: 30px;
            text-decoration: none;
            border: 2px solid var(--accent);
            transition: all 0.25s ease;
            letter-spacing: 0.5px;
        }
        .btn-hero:hover {
            background: transparent;
            color: var(--accent);
        }
        .hero-scroll {
            position: absolute;
            bottom: 1.8rem;
            left: 50%;
            transform: translateX(-50%);
            color: rgba(255,255,255,0.35);
            font-size: 0.9rem;
            z-index: 2;
        }

        /* ── STATS BAR ─────────────────────────────────────── */
        .stats-bar {
            background: var(--primary);
        }
        .stats-grid {
            display: flex;
            align-items: stretch;
            justify-content: space-around;
            flex-wrap: wrap;
        }
        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 1.8rem 1.2rem;
            flex: 1;
            min-width: 130px;
        }
        .stat-num {
            font-size: 1.9rem;
            font-weight: 800;
            color: var(--accent);
            line-height: 1;
            margin-bottom: 0.2rem;
        }
        .stat-label {
            font-size: 0.78rem;
            font-weight: 600;
            color: rgba(255,255,255,0.65);
            text-align: center;
        }
        .stat-divider {
            width: 1px;
            background: rgba(255,255,255,0.12);
            margin: 1.2rem 0;
            align-self: stretch;
        }

        /* ── SECTION COMMON ────────────────────────────────── */
        .section-label {
            display: inline-block;
            font-size: 0.7rem;
            font-weight: 800;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: var(--accent);
            background: var(--accent-light);
            padding: 4px 12px;
            border-radius: 50px;
            margin-bottom: 0.7rem;
        }
        .section-heading {
            font-size: clamp(1.6rem, 3vw, 2.2rem);
            font-weight: 800;
            color: var(--primary);
            line-height: 1.2;
            margin-bottom: 0.8rem;
        }
        .section-heading.centered { text-align: center; }
        .section-sub {
            font-size: 0.93rem;
            color: var(--text-muted);
            max-width: 480px;
            margin: 0.3rem auto 0;
            text-align: center;
            line-height: 1.7;
        }
        .section-body {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-bottom: 0.85rem;
            line-height: 1.8;
        }
        .mb-section { margin-bottom: 2.8rem; }

        /* ── STORY ─────────────────────────────────────────── */
        .story-section {
            padding: var(--section-gap) 0;
            background: var(--bg);
        }
        .story-img-wrap {
            position: relative;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(60,47,39,0.11);
        }
        .story-img-wrap img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            display: block;
        }
        .story-badge {
            position: absolute;
            bottom: 1.2rem;
            left: 1.2rem;
            background: var(--primary);
            color: #fff;
            padding: 0.55rem 1rem;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 0.4rem;
            font-weight: 700;
            font-size: 0.83rem;
        }
        .story-badge i { color: var(--accent); }
        .story-list {
            list-style: none;
            padding: 0;
            margin: 1.2rem 0 0;
        }
        .story-list li {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            padding: 0.5rem 0;
            font-weight: 600;
            font-size: 0.92rem;
            color: var(--text-main);
            border-bottom: 1px solid var(--border);
        }
        .story-list li:last-child { border-bottom: none; }
        .story-list li i { color: var(--accent); font-size: 0.85rem; flex-shrink: 0; }

        /* ── VALUES ────────────────────────────────────────── */
        .values-section {
            padding: var(--section-gap) 0;
            background: var(--bg-alt);
        }
        .value-card {
            background: var(--bg);
            border-radius: var(--radius);
            padding: 1.7rem 1.3rem;
            height: 100%;
            border: 1px solid var(--border);
            text-align: center;
            box-shadow: var(--shadow);
        }
        .value-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            background: var(--accent-light);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }
        .value-icon i { font-size: 1.25rem; color: var(--accent); }
        .value-card h4 {
            font-size: 0.96rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 0.45rem;
        }
        .value-card p {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin: 0;
            line-height: 1.7;
        }

        /* ── MISSION ────────────────────────────────────────── */
        .mission-section {
            padding: var(--section-gap) 0;
            background: var(--bg);
        }
        .mission-cards-row {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }
        .mission-card {
            flex: 1;
            min-width: 280px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
        }
        .mission-card-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
        }
        .mission-card-body {
            padding: 1.8rem 1.8rem 2rem;
        }
        .mission-card-tag {
            font-size: 0.68rem;
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--accent);
            margin-bottom: 0.4rem;
            display: block;
        }
        .mission-card h3 {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 0.6rem;
            line-height: 1.3;
        }
        .mission-divider {
            width: 32px;
            height: 3px;
            background: var(--accent);
            border-radius: 2px;
            margin-bottom: 0.9rem;
        }
        .mission-card p {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.8;
            margin: 0;
        }

        /* ── PROCESS ────────────────────────────────────────── */
        .process-section {
            padding: var(--section-gap) 0;
            background: var(--bg-alt);
        }
        .process-list {
            max-width: 660px;
            margin: 0 auto;
        }
        .process-item {
            display: flex;
            gap: 1.3rem;
            align-items: flex-start;
            padding: 1.5rem 0;
            border-bottom: 1px solid var(--border);
        }
        .process-item:last-child { border-bottom: none; }
        .process-icon-wrap {
            width: 44px;
            height: 44px;
            background: var(--accent-light);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .process-icon-wrap i { font-size: 1.05rem; color: var(--accent); }
        .process-num {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--primary);
            color: #fff;
            font-size: 0.68rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-top: 10px;
        }
        .process-body { flex: 1; }
        .process-body h4 {
            font-size: 0.97rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 0.25rem;
        }
        .process-body p {
            font-size: 0.87rem;
            color: var(--text-muted);
            margin: 0;
            line-height: 1.7;
        }

        /* ── TEAM ───────────────────────────────────────────── */
        .team-section {
            padding: var(--section-gap) 0;
            background: var(--bg);
        }
        .team-card {
            background: var(--bg);
            border-radius: var(--radius);
            overflow: hidden;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            height: 100%;
        }
        .team-img-wrap {
            width: 100%;
            height: 220px;
            overflow: hidden;
        }
        .team-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: top;
            display: block;
        }
        .team-info { padding: 1.2rem 1.3rem; }
        .team-info h5 {
            font-size: 0.98rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 0.2rem;
        }
        .team-role {
            display: inline-block;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.8px;
            color: var(--accent);
            background: var(--accent-light);
            padding: 2px 10px;
            border-radius: 50px;
            margin-bottom: 0.6rem;
        }
        .team-info p {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin: 0;
            line-height: 1.6;
        }

        /* ── CTA ─────────────────────────────────────────────
           Dùng accent (vàng nâu) thay vì primary (#3C2F27)
           để không trùng với footer
        ─────────────────────────────────────────────────────── */
        .cta-section {
            padding: var(--section-gap) 0;
            background: var(--bg-alt);
            border-top: 1px solid var(--border);
        }
        .cta-section .section-heading { color: var(--primary); }
        .cta-sub {
            font-size: 0.93rem;
            color: var(--text-muted);
            margin: 0 auto 2rem;
            max-width: 440px;
            text-align: center;
        }
        .cta-buttons {
            display: flex;
            gap: 0.9rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-cta-primary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--primary);
            color: #fff;
            font-weight: 700;
            font-size: 0.92rem;
            padding: 0.78rem 1.9rem;
            border-radius: 30px;
            text-decoration: none;
            border: 2px solid var(--primary);
            transition: all 0.25s ease;
        }
        .btn-cta-primary:hover {
            background: var(--primary-hover);
            border-color: var(--primary-hover);
            color: #fff;
        }
        .btn-cta-outline {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: transparent;
            color: var(--primary);
            font-weight: 700;
            font-size: 0.92rem;
            padding: 0.78rem 1.9rem;
            border-radius: 30px;
            text-decoration: none;
            border: 2px solid var(--border);
            transition: all 0.25s ease;
        }
        .btn-cta-outline:hover {
            border-color: var(--primary);
            color: var(--primary);
        }

        /* ── RESPONSIVE ─────────────────────────────────────── */
        @media (max-width: 991.98px) {
            .stat-divider { display: none; }
            .stat-item { min-width: 48%; padding: 1.3rem 1rem; }
            .mission-card { min-width: 100%; }
        }
        @media (max-width: 767.98px) {
            :root { --section-gap: 60px; }
            .hero-title { font-size: 2.2rem; }
            .story-img-wrap img { height: 240px; }
            .mission-card-img { height: 160px; }
            .cta-buttons { flex-direction: column; align-items: center; }
            .btn-cta-primary, .btn-cta-outline { width: 100%; max-width: 260px; justify-content: center; }
        }
    </style>
</head>
<body>

<jsp:include page="/components/header.jsp">
    <jsp:param name="activePage" value="introduce"/>
</jsp:include>

<main>

    <!-- HERO -->
    <section class="hero-section">
        <div class="hero-overlay"></div>
        <div class="hero-content container">
            <span class="hero-eyebrow">Sweet Oven Bakery</span>
            <h1 class="hero-title">NƯỚNG VỊ<br><span>HẠNH PHÚC</span></h1>
            <p class="hero-sub">Thủ công · Tươi mới mỗi ngày · Không chất bảo quản</p>
            <a href="${pageContext.request.contextPath}/menu" class="btn-hero">
                <i class="fas fa-shopping-bag"></i> Khám phá sản phẩm
            </a>
        </div>
        <div class="hero-scroll"><i class="fas fa-chevron-down"></i></div>
    </section>

    <!-- STATS -->
    <section class="stats-bar">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item">
                    <span class="stat-num">5+</span>
                    <span class="stat-label">Năm kinh nghiệm</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <span class="stat-num">50+</span>
                    <span class="stat-label">Loại bánh</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <span class="stat-num">10K+</span>
                    <span class="stat-label">Khách hàng hài lòng</span>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <span class="stat-num">100%</span>
                    <span class="stat-label">Nguyên liệu tự nhiên</span>
                </div>
            </div>
        </div>
    </section>

    <!-- STORY -->
    <section class="story-section">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <div class="story-img-wrap">
                        <img src="https://cdn.tgdd.vn/2020/08/CookProduct/cn-1200x676-5.jpg"
                             alt="Sweet Oven Bakery" loading="lazy">
                        <div class="story-badge">
                            <i class="fas fa-award"></i>
                            <span>Thành lập 2019</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="section-label">Câu chuyện của chúng tôi</div>
                    <h2 class="section-heading">Sweet Oven Bakery</h2>
                    <p class="section-body">Được thành lập năm 2019, Sweet Oven Bakery ra đời từ một góc bếp nhỏ với khao khát mang hương vị thuần khiết nhất đến tay mọi người.</p>
                    <p class="section-body">Chúng tôi tin rằng một chiếc bánh ngon cần thời gian, sự tỉ mỉ và tình yêu thực sự trong từng công đoạn.</p>
                    <ul class="story-list">
                        <li><i class="fas fa-check-circle"></i> Làm mới hoàn toàn mỗi ngày</li>
                        <li><i class="fas fa-check-circle"></i> Không chất bảo quản, không phẩm màu nhân tạo</li>
                        <li><i class="fas fa-check-circle"></i> Nguyên liệu nhập khẩu chọn lọc</li>
                        <li><i class="fas fa-check-circle"></i> Công thức được hoàn thiện qua nhiều năm</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- VALUES -->
    <section class="values-section">
        <div class="container">
            <div class="text-center mb-section">
                <div class="section-label">Tại sao chọn chúng tôi</div>
                <h2 class="section-heading centered">Giá trị cốt lõi</h2>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="value-card">
                        <div class="value-icon"><i class="fas fa-leaf"></i></div>
                        <h4>Nguyên liệu sạch</h4>
                        <p>100% tự nhiên, kiểm tra chất lượng nghiêm ngặt trước khi sử dụng.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="value-card">
                        <div class="value-icon"><i class="fas fa-fire-alt"></i></div>
                        <h4>Tươi mỗi ngày</h4>
                        <p>Làm thủ công từ sáng sớm, đảm bảo hương vị tươi ngon nhất khi đến tay bạn.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="value-card">
                        <div class="value-icon"><i class="fas fa-medal"></i></div>
                        <h4>Chất lượng cao</h4>
                        <p>Kiểm soát từ nguyên liệu đến thành phẩm, không thỏa hiệp với bất kỳ tiêu chuẩn nào.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="value-card">
                        <div class="value-icon"><i class="fas fa-heart"></i></div>
                        <h4>Làm bằng tình yêu</h4>
                        <p>Mỗi chiếc bánh được tạo ra với đam mê, sự tận tâm và niềm vui thực sự.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- MISSION & VISION — có ảnh -->
    <section class="mission-section">
        <div class="container">
            <div class="text-center mb-section">
                <div class="section-label">Định hướng phát triển</div>
                <h2 class="section-heading centered">Tầm nhìn &amp; Sứ mệnh</h2>
            </div>
            <div class="mission-cards-row">
                <div class="mission-card">
                    <img class="mission-card-img"
                         src="https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800&h=400&fit=crop"
                         alt="Sứ mệnh" loading="lazy">
                    <div class="mission-card-body">
                        <span class="mission-card-tag">Sứ mệnh</span>
                        <h3>Mang niềm vui qua từng chiếc bánh</h3>
                        <div class="mission-divider"></div>
                        <p>Chúng tôi tin rằng hạnh phúc có thể bắt đầu từ một chiếc bánh ấm nóng. Sứ mệnh của Sweet Oven là tạo nên những khoảnh khắc đáng nhớ cho gia đình và người thân bạn qua hương vị thuần khiết, chân thật.</p>
                    </div>
                </div>
                <div class="mission-card">
                    <img class="mission-card-img"
                         src="https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800&h=400&fit=crop"
                         alt="Tầm nhìn" loading="lazy">
                    <div class="mission-card-body">
                        <span class="mission-card-tag">Tầm nhìn</span>
                        <h3>Thương hiệu bánh thủ công được yêu thích nhất</h3>
                        <div class="mission-divider"></div>
                        <p>Sweet Oven hướng đến trở thành thương hiệu bánh thủ công hàng đầu tại Việt Nam — nơi chất lượng, sự sáng tạo và cảm xúc luôn được đặt lên trên hết trong mọi sản phẩm.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- PROCESS -->
    <section class="process-section">
        <div class="container">
            <div class="text-center mb-section">
                <div class="section-label">Quy trình sản xuất</div>
                <h2 class="section-heading centered">Từ bếp đến tay bạn</h2>
                <p class="section-sub">Mỗi chiếc bánh trải qua 4 bước được kiểm soát nghiêm ngặt để đảm bảo chất lượng tốt nhất</p>
            </div>
            <div class="process-list">
                <div class="process-item">
                    <div class="process-icon-wrap"><i class="fas fa-seedling"></i></div>
                    <div class="process-body">
                        <h4>Chọn nguyên liệu</h4>
                        <p>Nguyên liệu tự nhiên, tươi sạch được tuyển chọn kỹ từ các nhà cung cấp uy tín trong và ngoài nước.</p>
                    </div>
                    <div class="process-num">01</div>
                </div>
                <div class="process-item">
                    <div class="process-icon-wrap"><i class="fas fa-blender"></i></div>
                    <div class="process-body">
                        <h4>Pha trộn theo công thức</h4>
                        <p>Công thức được nghiên cứu và hoàn thiện qua nhiều năm, đảm bảo hương vị đồng nhất trong từng mẻ bánh.</p>
                    </div>
                    <div class="process-num">02</div>
                </div>
                <div class="process-item">
                    <div class="process-icon-wrap"><i class="fas fa-fire"></i></div>
                    <div class="process-body">
                        <h4>Nướng thủ công</h4>
                        <p>Mỗi mẻ bánh được kiểm soát nhiệt độ chính xác, nướng theo thời gian chuẩn để đạt độ chín hoàn hảo.</p>
                    </div>
                    <div class="process-num">03</div>
                </div>
                <div class="process-item">
                    <div class="process-icon-wrap"><i class="fas fa-box-open"></i></div>
                    <div class="process-body">
                        <h4>Đóng gói &amp; giao hàng</h4>
                        <p>Bánh được đóng gói cẩn thận, bảo quản đúng cách và giao đến tay khách hàng trong thời gian sớm nhất.</p>
                    </div>
                    <div class="process-num">04</div>
                </div>
            </div>
        </div>
    </section>

    <!-- TEAM -->
    <section class="team-section">
        <div class="container">
            <div class="text-center mb-section">
                <div class="section-label">Con người</div>
                <h2 class="section-heading centered">Đội ngũ của chúng tôi</h2>
                <p class="section-sub">Những con người tài năng và tận tâm đứng sau mỗi chiếc bánh của Sweet Oven</p>
            </div>
            <div class="row g-4 justify-content-center">
                <div class="col-md-4">
                    <div class="team-card">
                        <div class="team-img-wrap">
                            <img src="https://images.unsplash.com/photo-1583394293214-28ded15ee548?w=400&h=400&fit=crop&crop=face"
                                 alt="Nguyễn Khánh Dinh" loading="lazy">
                        </div>
                        <div class="team-info">
                            <h5>Nguyễn Khánh Dinh</h5>
                            <span class="team-role">Head Chef &amp; Founder</span>
                            <p>10 năm kinh nghiệm làm bánh, đào tạo tại Pháp và Nhật Bản.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="team-card">
                        <div class="team-img-wrap">
                            <img src="https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?w=400&h=400&fit=crop&crop=face"
                                 alt="Đoàn Huy Cương" loading="lazy">
                        </div>
                        <div class="team-info">
                            <h5>Đoàn Huy Cương</h5>
                            <span class="team-role">Senior Baker</span>
                            <p>Chuyên gia bánh mì artisan và các loại bánh nướng truyền thống.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="team-card">
                        <div class="team-img-wrap">
                            <img src="https://images.unsplash.com/photo-1566554273541-37a9ca77b91f?w=400&h=400&fit=crop&crop=face"
                                 alt="Bùi Ánh Hậu" loading="lazy">
                        </div>
                        <div class="team-info">
                            <h5>Bùi Ánh Hậu</h5>
                            <span class="team-role">Cake Decorator</span>
                            <p>Nghệ sĩ trang trí bánh, biến mỗi chiếc bánh thành tác phẩm nghệ thuật.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA — nền kem sáng, KHÔNG dùng #3C2F27 để tránh trùng footer -->
    <section class="cta-section">
        <div class="container text-center">
            <div class="section-label">Bắt đầu ngay hôm nay</div>
            <h2 class="section-heading centered">Thưởng thức hương vị<br>ngọt ngào của chúng tôi</h2>
            <p class="cta-sub">Đặt hàng trực tuyến hoặc ghé thăm cửa hàng tại TP. Hồ Chí Minh</p>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/menu" class="btn-cta-primary">
                    <i class="fas fa-shopping-bag"></i> Mua ngay
                </a>
                <a href="${pageContext.request.contextPath}/contact" class="btn-cta-outline">
                    <i class="fas fa-map-marker-alt"></i> Tìm cửa hàng
                </a>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/components/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        if (!window.IntersectionObserver) {
            document.querySelectorAll('.reveal').forEach(function(el){ el.classList.add('visible'); });
            return;
        }
        var io = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    io.unobserve(entry.target);
                }
            });
        }, { threshold: 0.12 });
        document.querySelectorAll('.reveal').forEach(function (el) { io.observe(el); });
    })();
</script>

</body>
</html>
