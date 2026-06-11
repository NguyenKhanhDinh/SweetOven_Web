<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.ProductReviewService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #3C2F27;
            --primary-hover: #4a3728;
            --accent: #C9A96E;
            --accent-dark: #c97b21;
            --accent-hover: #a96414;
            --accent-light: #e8d5b0;
            --bg: #F9F6F0;
            --white: #ffffff;
            --text-main: #333333;
            --text-muted: #888888;
            --border: rgba(201, 169, 110, .25);
            --shadow: 0 4px 20px rgba(60, 47, 39, .08);
            --radius: 16px;
            --radius-sm: 10px;
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Quicksand', sans-serif;
            background: var(--bg);
            color: var(--text-main);
            padding: 32px 20px 60px;
        }

        .page-wrap {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        /* ── Page header ── */
        .page-head {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .back-btn {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            border: 1.5px solid #ddd;
            background: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: var(--text-muted);
            flex-shrink: 0;
            transition: all .2s;
            box-shadow: var(--shadow);
        }

        .back-btn:hover {
            border-color: var(--accent-dark);
            color: var(--accent-dark);
        }

        .back-btn svg {
            width: 15px;
            height: 15px;
        }

        .page-head-text h1 {
            font-size: 20px;
            font-weight: 800;
            color: var(--primary);
        }

        .page-head-text .sub {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 2px;
            font-weight: 500;
        }

        /* ── Status banner ── */
        .status-banner {
            border-radius: var(--radius);
            padding: 20px 24px 22px;
        }

        .status-banner.s1 {
            background: linear-gradient(135deg, #3C2F27, #4a3728);
        }

        .status-banner.s2 {
            background: linear-gradient(135deg, #6d4c28, #8d6535);
        }

        .status-banner.s3 {
            background: linear-gradient(135deg, #2e7d32, #388e3c);
        }

        .status-banner.s4 {
            background: linear-gradient(135deg, #7f3a3a, #9b4444);
        }

        .banner-top {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 18px;
        }

        .banner-sq {
            width: 18px;
            height: 18px;
            flex-shrink: 0;
            margin-top: 2px;
            border: 2px solid rgba(255, 255, 255, .5);
            border-radius: 3px;
        }

        .banner-title {
            font-size: 16px;
            font-weight: 800;
            color: #fff;
        }

        .banner-sub {
            font-size: 13px;
            color: rgba(255, 255, 255, .75);
            margin-top: 3px;
        }

        .progress-wrap {
            background: rgba(255, 255, 255, .15);
            border-radius: var(--radius-sm);
            padding: 14px 20px 10px;
        }

        .progress-track {
            display: flex;
            align-items: center;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .step-dot {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
        }

        .step-dot.done {
            background: var(--accent);
            color: var(--primary);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, .3);
        }

        .step-dot.active {
            background: #fff;
            color: var(--primary);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, .3);
        }

        .step-dot.pending {
            background: rgba(255, 255, 255, .2);
            color: rgba(255, 255, 255, .5);
        }

        .step-label {
            font-size: 11px;
            font-weight: 700;
            margin-top: 6px;
            white-space: nowrap;
            color: rgba(255, 255, 255, .9);
        }

        .step-label.dim {
            color: rgba(255, 255, 255, .4);
        }

        .connector {
            flex: 1;
            height: 2px;
            margin-bottom: 20px;
        }

        .connector.done {
            background: var(--accent);
        }

        .connector.pending {
            background: rgba(255, 255, 255, .2);
        }

        /* ── Row 2 grid ── */
        .mid-grid {
            display: grid;
            grid-template-columns: 1fr 220px 220px;
            gap: 16px;
            align-items: stretch;
        }

        /* ── Card base ── */
        .card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .section-lbl {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 14px 18px 12px;
            border-bottom: 1px solid rgba(212, 167, 106, .12);
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .1em;
            text-transform: uppercase;
            color: var(--accent-dark);
        }

        .section-lbl .sq {
            width: 9px;
            height: 9px;
            border: 2px solid var(--accent);
            border-radius: 2px;
            flex-shrink: 0;
        }

        /* ── Shipping info ── */
        .col-info {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .ship-row {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            padding: 12px 18px;
            border-bottom: 1px solid var(--bg);
        }

        .ship-row:last-child {
            border-bottom: none;
        }

        .ship-icon {
            width: 30px;
            height: 30px;
            border-radius: 8px;
            background: rgba(212, 167, 106, .1);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 1px;
        }

        .ship-icon i {
            font-size: 12px;
            color: var(--accent-dark);
        }

        .ship-lbl {
            font-size: 10px;
            color: var(--text-muted);
            font-weight: 700;
            letter-spacing: .08em;
            text-transform: uppercase;
            margin-bottom: 3px;
        }

        .ship-val {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-main);
            line-height: 1.5;
        }

        .note-row {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            padding: 12px 18px;
            background: rgba(212, 167, 106, .05);
            border-top: 1px dashed rgba(212, 167, 106, .3);
        }

        .note-icon {
            width: 30px;
            height: 30px;
            border-radius: 8px;
            background: rgba(212, 167, 106, .1);
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 1px;
        }

        .note-icon i {
            font-size: 12px;
            color: var(--accent-dark);
        }

        .note-lbl {
            font-size: 10px;
            color: var(--text-muted);
            font-weight: 700;
            letter-spacing: .08em;
            text-transform: uppercase;
            margin-bottom: 3px;
        }

        .note-val {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-main);
            line-height: 1.55;
            font-style: italic;
        }

        /* ── Payment col ── */
        .col-pay {
            display: flex;
            flex-direction: column;
        }

        .col-pay .card {
            flex: 1;
        }

        .pay-row {
            padding: 10px 16px;
            border-bottom: 1px solid var(--bg);
        }

        .pay-row:last-child {
            border-bottom: none;
            padding-bottom: 14px;
        }

        .pay-row-lbl {
            font-size: 10px;
            color: var(--text-muted);
            font-weight: 700;
            letter-spacing: .07em;
            text-transform: uppercase;
            margin-bottom: 3px;
        }

        .pay-row-val {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-main);
            line-height: 1.4;
        }

        .pay-row-val.code {
            font-size: 12px;
            word-break: break-all;
            color: var(--primary);
        }

        /* ── Summary col ── */
        .col-sum {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .col-sum .card {
            flex: 1;
        }

        .sum-body {
            padding: 12px 16px 14px;
        }

        .sum-row {
            display: flex;
            justify-content: space-between;
            padding: 4px 0;
        }

        .sum-item-label {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .sum-item-val {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-main);
        }

        .sum-divider {
            height: 1px;
            background: rgba(212, 167, 106, .18);
            margin: 8px 0;
        }

        .sum-total-box {
            background: linear-gradient(135deg, rgba(212, 167, 106, .13), rgba(201, 123, 33, .07));
            border: 1px solid rgba(212, 167, 106, .3);
            border-radius: var(--radius-sm);
            padding: 11px 14px;
            text-align: center;
        }

        .sum-total-title {
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .1em;
            text-transform: uppercase;
            color: var(--accent-dark);
            margin-bottom: 3px;
        }

        .sum-total-amt {
            font-size: 21px;
            font-weight: 800;
            color: var(--primary);
            letter-spacing: -.5px;
        }

        /* ── Action buttons ── */
        .btn-row {
            display: flex;
            gap: 8px;
        }

        .btn-row .cancel-btn,
        .btn-row .reorder-btn {
            flex: 1;
            width: auto;
        }

        /* Huỷ đơn hàng (st 1,2,3) — xám */
        .cancel-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            width: 100%;
            padding: 11px 16px;
            border-radius: var(--radius-sm);
            border: 1.5px solid #ddd;
            background: var(--white);
            color: var(--text-muted);
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: all .2s;
            box-shadow: var(--shadow);
        }

        .cancel-btn:hover {
            border-color: #aaa;
            color: #555;
            background: #f5f5f5;
        }

        /* Đã huỷ (st 5) — đỏ */
        .cancelled-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            width: auto;
            padding: 11px 16px;
            border-radius: var(--radius-sm);
            border: 1.5px solid #e53935;
            background: #fff5f5;
            color: #c0392b;
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: default;
            text-decoration: none;
            box-shadow: var(--shadow);
            flex: 1;
        }

        .reorder-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            width: 100%;
            padding: 11px 16px;
            border-radius: var(--radius-sm);
            border: none;
            background: var(--primary);
            color: #fff;
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: all .2s;
            box-shadow: 0 4px 14px rgba(60, 47, 39, .18);
        }

        .reorder-btn:hover {
            opacity: .88;
            color: #fff;
        }

        .reorder-btn.disabled {
            background: #d0c9c2;
            color: #a09890;
            box-shadow: none;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* ── Products table ── */
        .prod-header {
            display: grid;
            padding: 9px 18px;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .08em;
            text-transform: uppercase;
            color: var(--text-muted);
            border-bottom: 1px solid rgba(212, 167, 106, .12);
            background: var(--bg);
        }

        .prod-row {
            display: grid;
            align-items: center;
            padding: 13px 18px;
            border-bottom: 1px solid var(--bg);
            transition: background .15s;
        }

        .prod-row:last-child {
            border-bottom: none;
        }

        .prod-row:hover {
            background: var(--bg);
        }

        .prod-header.no-review,
        .prod-row.no-review {
            grid-template-columns: 1fr 90px 160px;
        }

        .prod-header.has-review,
        .prod-row.has-review {
            grid-template-columns: 1fr 90px 160px 120px;
        }

        .prod-header span:nth-child(2) {
            text-align: center;
        }

        .prod-header span:nth-child(3),
        .prod-header span:nth-child(4) {
            text-align: right;
        }

        .prod-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .prod-thumb {
            width: 52px;
            height: 52px;
            border-radius: var(--radius-sm);
            background: var(--bg);
            flex-shrink: 0;
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .prod-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .prod-name {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-main);
        }

        .prod-price {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
            font-weight: 500;
        }

        .prod-qty {
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .prod-total {
            text-align: right;
            font-size: 14px;
            font-weight: 800;
            color: var(--accent-dark);
        }

        .prod-review {
            text-align: right;
        }

        .review-btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 11px;
            border-radius: 20px;
            border: 1.5px solid var(--accent);
            background: transparent;
            color: var(--accent-dark);
            font-family: 'Quicksand', sans-serif;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            transition: all .2s;
            white-space: nowrap;
        }

        .review-btn:hover {
            background: var(--accent);
            color: var(--white);
        }

        .reviewed-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            color: #2e7d32;
            font-weight: 600;
            background: #e8f5e9;
            border: 1px solid #a5d6a7;
            border-radius: 20px;
            padding: 5px 12px;
            white-space: nowrap;
        }
        .reviewed-badge i { font-size: 13px; }

        /* ── Cancel Dialog ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, .45);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open {
            display: flex;
        }

        .modal-box {
            background: #fff;
            border-radius: 18px;
            width: 92%;
            max-width: 440px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, .25);
            overflow: hidden;
            animation: popIn .22s ease;
        }

        @keyframes popIn {
            from {
                transform: scale(.92);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .modal-head {
            padding: 20px 22px 14px;
            border-bottom: 1px solid rgba(212, 167, 106, .18);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-head-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: #fff0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .modal-head-icon i {
            color: #e53935;
            font-size: 16px;
        }

        .modal-head-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--primary);
        }

        .modal-head-sub {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
            font-weight: 500;
        }

        .modal-body {
            padding: 18px 22px;
        }

        .reason-list {
            display: flex;
            flex-direction: column;
            gap: 9px;
        }

        .reason-item {
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 11px 14px;
            border-radius: 10px;
            border: 1.5px solid #eee;
            cursor: pointer;
            transition: all .18s;
            background: #fafafa;
        }

        .reason-item:hover {
            border-color: var(--accent);
            background: rgba(212, 167, 106, .06);
        }

        .reason-item.selected {
            border-color: var(--accent-dark);
            background: rgba(201, 123, 33, .08);
        }

        .reason-item input[type=radio] {
            accent-color: var(--accent-dark);
            width: 16px;
            height: 16px;
            flex-shrink: 0;
        }

        .reason-item label {
            font-size: 13.5px;
            font-weight: 600;
            color: var(--text-main);
            cursor: pointer;
            flex: 1;
        }

        .custom-note-wrap {
            margin-top: 10px;
            display: none;
        }

        .custom-note-wrap.show {
            display: block;
        }

        .custom-note-wrap textarea {
            width: 100%;
            border: 1.5px solid #ddd;
            border-radius: 10px;
            padding: 10px 12px;
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-main);
            resize: none;
            outline: none;
            transition: border .2s;
        }

        .custom-note-wrap textarea:focus {
            border-color: var(--accent-dark);
        }

        .modal-foot {
            padding: 14px 22px 18px;
            display: flex;
            gap: 10px;
            border-top: 1px solid rgba(212, 167, 106, .12);
        }

        .modal-btn-cancel {
            flex: 1;
            padding: 11px 0;
            border-radius: 10px;
            border: 1.5px solid #ddd;
            background: #fff;
            color: var(--text-muted);
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all .18s;
        }

        .modal-btn-cancel:hover {
            border-color: #aaa;
            background: #f5f5f5;
        }

        .modal-btn-confirm {
            flex: 1;
            padding: 11px 0;
            border-radius: 10px;
            border: none;
            background: #e53935;
            color: #fff;
            font-family: 'Quicksand', sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: opacity .18s;
            box-shadow: 0 4px 14px rgba(229, 57, 53, .28);
        }

        .modal-btn-confirm:hover {
            opacity: .88;
        }

        .modal-btn-confirm:disabled {
            background: #d0c9c2;
            box-shadow: none;
            cursor: not-allowed;
        }

        @media (max-width: 900px) {
            .mid-grid {
                grid-template-columns: 1fr 1fr;
            }

            .col-info {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 560px) {
            .mid-grid {
                grid-template-columns: 1fr;
            }

            .prod-header.no-review,
            .prod-row.no-review {
                grid-template-columns: 1fr 70px 110px;
            }
        }
    </style>
</head>
<body>

<c:set var="st" value="${order.orderStatus}"/>
<c:choose>
    <c:when test="${st == 1}"><c:set var="sCls" value="s1"/><c:set var="sTitle" value="Chờ xác nhận"/><c:set var="sDesc"
                                                                                                             value="Đơn hàng đang chờ shop xác nhận"/><c:set
            var="d1" value="done"/><c:set var="d2" value="active"/><c:set var="d3" value="pending"/><c:set var="d4"
                                                                                                           value="pending"/><c:set
            var="c1" value="done"/><c:set var="c2" value="pending"/><c:set var="c3" value="pending"/></c:when>
    <c:when test="${st == 2}"><c:set var="sCls" value="s1"/><c:set var="sTitle" value="Đã xác nhận"/><c:set var="sDesc"
                                                                                                            value="Đơn hàng đã được shop xác nhận"/><c:set
            var="d1" value="done"/><c:set var="d2" value="done"/><c:set var="d3" value="active"/><c:set var="d4"
                                                                                                        value="pending"/><c:set
            var="c1" value="done"/><c:set var="c2" value="done"/><c:set var="c3" value="pending"/></c:when>
    <c:when test="${st == 3}"><c:set var="sCls" value="s2"/><c:set var="sTitle" value="Đang giao hàng"/><c:set
            var="sDesc" value="Đơn hàng đang trên đường giao đến bạn"/><c:set var="d1" value="done"/><c:set var="d2"
                                                                                                            value="done"/><c:set
            var="d3" value="done"/><c:set var="d4" value="active"/><c:set var="c1" value="done"/><c:set var="c2"
                                                                                                        value="done"/><c:set
            var="c3" value="done"/></c:when>
    <c:when test="${st == 4}"><c:set var="sCls" value="s3"/><c:set var="sTitle" value="Hoàn thành"/><c:set var="sDesc"
                                                                                                           value="Đơn hàng đã được giao thành công"/><c:set
            var="d1" value="done"/><c:set var="d2" value="done"/><c:set var="d3" value="done"/><c:set var="d4"
                                                                                                      value="done"/><c:set
            var="c1" value="done"/><c:set var="c2" value="done"/><c:set var="c3" value="done"/></c:when>
    <c:otherwise><c:set var="sCls" value="s4"/><c:set var="sTitle" value="Đã huỷ"/><c:set var="sDesc"
                                                                                          value="${not empty order.cancelReason ? order.cancelReason : 'Đơn hàng này đã bị huỷ'}"/><c:set
            var="d1" value="done"/><c:set var="d2" value="pending"/><c:set var="d3" value="pending"/><c:set var="d4"
                                                                                                            value="pending"/><c:set
            var="c1" value="pending"/><c:set var="c2" value="pending"/><c:set var="c3" value="pending"/></c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${order.paymentMethod == 0}"><c:set var="pmLabel" value="Nhận hàng trả tiền"/></c:when>
    <c:when test="${order.paymentMethod == 1}"><c:set var="pmLabel" value="Ví MoMo"/></c:when>
    <c:when test="${order.paymentMethod == 2}"><c:set var="pmLabel" value="VNPay"/></c:when>
    <c:otherwise><c:set var="pmLabel" value="Thanh toán online"/></c:otherwise>
</c:choose>

<div class="page-wrap">

    <!-- Page header -->
    <div class="page-head">
        <a href="${pageContext.request.contextPath}/profile" class="back-btn">
            <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
            </svg>
        </a>
        <div class="page-head-text">
            <h1>Chi tiết đơn hàng</h1>
            <div class="sub">Mã đơn #${order.orderCode} · ${order.orderDateFormatted}</div>
        </div>
    </div>

    <!-- Hàng 1: Banner trạng thái -->
    <div class="status-banner ${sCls}">
        <div class="banner-top">
            <div class="banner-sq"></div>
            <div>
                <div class="banner-title">${sTitle}</div>
                <div class="banner-sub">${sDesc}</div>
            </div>
        </div>
        <div class="progress-wrap">
            <div class="progress-track">
                <div class="step">
                    <div class="step-dot ${d1}">✓</div>
                    <div class="step-label">Đã đặt</div>
                </div>
                <div class="connector ${c1}"></div>
                <div class="step">
                    <div class="step-dot ${d2}"><c:choose><c:when
                            test="${d2=='done'}">✓</c:when><c:otherwise>2</c:otherwise></c:choose></div>
                    <div class="step-label ${d2=='pending'?'dim':''}">Xác nhận</div>
                </div>
                <div class="connector ${c2}"></div>
                <div class="step">
                    <div class="step-dot ${d3}"><c:choose><c:when
                            test="${d3=='done'}">✓</c:when><c:otherwise>3</c:otherwise></c:choose></div>
                    <div class="step-label ${d3=='pending'?'dim':''}">Đang giao</div>
                </div>
                <div class="connector ${c3}"></div>
                <div class="step">
                    <div class="step-dot ${d4}"><c:choose><c:when
                            test="${d4=='done'}">✓</c:when><c:otherwise>4</c:otherwise></c:choose></div>
                    <div class="step-label ${d4=='pending'?'dim':''}">Đã giao</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hàng 2: thông tin giao hàng | thanh toán | tóm tắt+nút -->
    <div class="mid-grid">

        <!-- Cột trái: thông tin giao hàng -->
        <div class="col-info">
            <div class="card" style="height:100%;">
                <div class="section-lbl"><span class="sq"></span>Thông tin giao hàng</div>
                <div class="ship-row">
                    <div class="ship-icon"><i class="fa fa-user"></i></div>
                    <div>
                        <div class="ship-lbl">Người nhận</div>
                        <div class="ship-val">${order.fullName} · ${order.phoneNumber}</div>
                    </div>
                </div>
                <div class="ship-row">
                    <div class="ship-icon"><i class="fa fa-map-marker-alt"></i></div>
                    <div>
                        <div class="ship-lbl">Địa chỉ</div>
                        <div class="ship-val">${order.address}</div>
                    </div>
                </div>
                <c:if test="${not empty order.note}">
                    <div class="note-row">
                        <div class="note-icon"><i class="fa fa-sticky-note"></i></div>
                        <div>
                            <div class="note-lbl">Ghi chú</div>
                            <div class="note-val">${order.note}</div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Cột giữa: thanh toán -->
        <div class="col-pay">
            <div class="card">
                <div class="section-lbl"><span class="sq"></span>Thanh toán</div>
                <div style="height:4px;"></div>
                <div class="pay-row">
                    <div class="pay-row-lbl">Phương thức</div>
                    <div class="pay-row-val">${pmLabel}</div>
                </div>
                <div class="pay-row">
                    <div class="pay-row-lbl">Ngày đặt</div>
                    <div class="pay-row-val">${order.orderDateFormatted}</div>
                </div>
                <div class="pay-row">
                    <div class="pay-row-lbl"># Mã đơn</div>
                    <div class="pay-row-val code">#${order.orderCode}</div>
                </div>
            </div>
        </div>

        <!-- Cột phải: tóm tắt + nút hành động -->
        <div class="col-sum">
            <div class="card">
                <div class="section-lbl"><span class="sq"></span>Tóm tắt</div>
                <div class="sum-body">
                    <div class="sum-row">
                        <span class="sum-item-label">Tiền hàng</span>
                        <span class="sum-item-val"><fmt:formatNumber value="${order.subTotal}"
                                                                     type="number"/> VNĐ</span>
                    </div>
                    <div class="sum-row">
                        <span class="sum-item-label">Phí ship</span>
                        <span class="sum-item-val"><fmt:formatNumber value="${order.shippingFee}"
                                                                     type="number"/> VNĐ</span>
                    </div>
                    <c:if test="${order.discountAmount != null}">
                        <div class="sum-row">
                            <span class="sum-item-label">Giảm giá</span>
                            <span class="sum-item-val" style="color:#2e7d32;">−<fmt:formatNumber
                                    value="${order.discountAmount}" type="number"/> VNĐ</span>
                        </div>
                    </c:if>
                    <div class="sum-divider"></div>
                    <div class="sum-total-box">
                        <div class="sum-total-title">Tổng cộng</div>
                        <div class="sum-total-amt"><fmt:formatNumber value="${order.totalAmount}" type="number"/> VNĐ
                        </div>
                    </div>
                </div>
            </div>

            <!-- Nút hành động -->
            <c:choose>

                <%-- st 1, 2, 3: chỉ hiện nút Huỷ đơn hàng màu xám --%>
                <c:when test="${st == 1 || st == 2 || st == 3}">
                    <button type="button" class="cancel-btn" onclick="openCancelDialog(${order.id})">
                        <i class="fa fa-times-circle"></i> Huỷ đơn hàng
                    </button>
                </c:when>

                <%-- st 4: chỉ hiện nút Mua lại --%>
                <c:when test="${st == 4}">
                    <c:choose>
                        <c:when test="${canReOrder}">
                            <a href="${pageContext.request.contextPath}/reorder?id=${order.id}" class="reorder-btn">
                                <i class="fa fa-redo"></i> Mua lại
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="reorder-btn disabled" title="Sản phẩm đã hết hàng hoặc ngừng bán">
                                <i class="fa fa-redo"></i> Mua lại
                            </span>
                        </c:otherwise>
                    </c:choose>
                </c:when>

                <%-- st 5: hiện Đã huỷ (đỏ) + Mua lại --%>
                <c:when test="${st == 5}">
                    <div class="btn-row">
                        <span class="cancelled-btn">
                            <i class="fa fa-times-circle"></i> Đã huỷ
                        </span>
                        <c:choose>
                            <c:when test="${canReOrder}">
                                <a href="${pageContext.request.contextPath}/reorder?id=${order.id}" class="reorder-btn">
                                    <i class="fa fa-redo"></i> Mua lại
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="reorder-btn disabled" title="Sản phẩm đã hết hàng hoặc ngừng bán">
                                    <i class="fa fa-redo"></i> Mua lại
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

            </c:choose>
        </div>

    </div>

    <!-- Hàng 3: bảng sản phẩm -->
    <div class="card">
        <div class="section-lbl"><span class="sq"></span>Sản phẩm</div>

        <%-- Chỉ st == 4 mới có cột Đánh giá --%>
        <c:choose>
            <c:when test="${st == 4}">
                <div class="prod-header has-review">
                    <span>Sản phẩm</span><span>SL</span><span>Thành tiền</span><span>Đánh giá</span>
                </div>
            </c:when>
            <c:otherwise>
                <div class="prod-header no-review">
                    <span>Sản phẩm</span><span>SL</span><span>Thành tiền</span>
                </div>
            </c:otherwise>
        </c:choose>

        <c:forEach var="item" items="${orderDetails}">
            <c:choose>
                <c:when test="${st == 4}">
                    <div class="prod-row has-review">
                        <div class="prod-info">
                            <div class="prod-thumb">
                                <c:choose>
                                    <c:when test="${not empty item.productImage}"><img src="${item.productImage}"
                                                                                       alt="${item.productName}"/></c:when>
                                    <c:otherwise><i class="fa fa-image"
                                                    style="color:var(--accent);font-size:16px;"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <div class="prod-name">${item.productName}</div>
                                <div class="prod-price">${item.buyPriceFormatted} / cái</div>
                            </div>
                        </div>
                        <div class="prod-qty">×${item.quantity}</div>
                        <div class="prod-total">${item.totalPriceFormatted}</div>
                        <div class="prod-review">
                            <%
                                ProductReviewService _rvSvc = new ProductReviewService();
                                model.OrderDetail _it = (model.OrderDetail) pageContext.getAttribute("item");
                                model.Order _order = (model.Order) request.getAttribute("order");
                                boolean _reviewed = _rvSvc.hasReviewed(_it.getProductId(), _order.getId());
                                pageContext.setAttribute("_reviewed", _reviewed);
                            %>
                            <c:choose>
                                <c:when test="${_reviewed}">
                                    <span class="reviewed-badge">
                                        <i class="fa fa-check-circle"></i> Đã đánh giá
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/product?id=${item.productId}&orderId=${order.id}#pd-comment"
                                       class="review-btn">
                                        <i class="fa fa-star"></i> Viết đánh giá
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="prod-row no-review">
                        <div class="prod-info">
                            <div class="prod-thumb">
                                <c:choose>
                                    <c:when test="${not empty item.productImage}"><img src="${item.productImage}"
                                                                                       alt="${item.productName}"/></c:when>
                                    <c:otherwise><i class="fa fa-image"
                                                    style="color:var(--accent);font-size:16px;"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <div class="prod-name">${item.productName}</div>
                                <div class="prod-price">${item.buyPriceFormatted} / cái</div>
                            </div>
                        </div>
                        <div class="prod-qty">×${item.quantity}</div>
                        <div class="prod-total">${item.totalPriceFormatted}</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>

    <!-- ════════════════════════════════════════════════════
         Modal hủy đơn hàng
    ═════════════════════════════════════════════════════ -->
    <div class="modal-overlay" id="cancelModal">
        <div class="modal-box">
            <div class="modal-head">
                <div class="modal-head-icon"><i class="fa fa-times-circle"></i></div>
                <div>
                    <div class="modal-head-title">Huỷ đơn hàng</div>
                    <div class="modal-head-sub">Vui lòng chọn lý do huỷ đơn của bạn</div>
                </div>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/cancel-order" id="cancelForm">
                <input type="hidden" name="id" id="cancelOrderId"/>

                <div class="modal-body">
                    <div class="reason-list">

                        <div class="reason-item" onclick="selectReason(this)">
                            <input type="radio" name="cancelReason" id="r1"
                                   value="Tôi muốn thay đổi địa chỉ giao hàng"/>
                            <label for="r1">Tôi muốn thay đổi địa chỉ giao hàng</label>
                        </div>

                        <div class="reason-item" onclick="selectReason(this)">
                            <input type="radio" name="cancelReason" id="r2"
                                   value="Tôi muốn thay đổi sản phẩm trong đơn"/>
                            <label for="r2">Tôi muốn thay đổi sản phẩm trong đơn</label>
                        </div>

                        <div class="reason-item" onclick="selectReason(this)">
                            <input type="radio" name="cancelReason" id="r3"
                                   value="Tôi tìm được chỗ mua giá rẻ hơn"/>
                            <label for="r3">Tôi tìm được chỗ mua giá rẻ hơn</label>
                        </div>

                        <div class="reason-item" onclick="selectReason(this)">
                            <input type="radio" name="cancelReason" id="r4"
                                   value="Tôi không có nhu cầu mua nữa"/>
                            <label for="r4">Tôi không có nhu cầu mua nữa</label>
                        </div>

                        <div class="reason-item" onclick="selectReason(this)">
                            <input type="radio" name="cancelReason" id="r5"
                                   value="Đặt nhầm sản phẩm / số lượng"/>
                            <label for="r5">Đặt nhầm sản phẩm / số lượng</label>
                        </div>

                        <div class="reason-item" onclick="selectReason(this, true)">
                            <input type="radio" name="cancelReason" id="r6" value="other"/>
                            <label for="r6">Lý do khác</label>
                        </div>

                    </div>

                    <div class="custom-note-wrap" id="customNoteWrap">
                    <textarea name="customNote" id="customNote" rows="3"
                              placeholder="Nhập lý do của bạn..."></textarea>
                    </div>
                </div>

                <div class="modal-foot">
                    <button type="button" class="modal-btn-cancel" onclick="closeCancelDialog()">
                        Giữ đơn hàng
                    </button>
                    <button type="button" class="modal-btn-confirm" id="confirmCancelBtn"
                            disabled onclick="submitCancel()">
                        Xác nhận huỷ
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openCancelDialog(orderId) {
            document.getElementById('cancelOrderId').value = orderId;
            // reset form
            document.querySelectorAll('.reason-item').forEach(el => el.classList.remove('selected'));
            document.querySelectorAll('input[name=cancelReason]').forEach(el => el.checked = false);
            document.getElementById('customNoteWrap').classList.remove('show');
            document.getElementById('customNote').value = '';
            document.getElementById('confirmCancelBtn').disabled = true;
            document.getElementById('cancelModal').classList.add('open');
            document.body.style.overflow = 'hidden';
        }

        function closeCancelDialog() {
            document.getElementById('cancelModal').classList.remove('open');
            document.body.style.overflow = '';
        }

        function selectReason(item, isOther) {
            document.querySelectorAll('.reason-item').forEach(el => el.classList.remove('selected'));
            item.classList.add('selected');
            item.querySelector('input[type=radio]').checked = true;

            const customWrap = document.getElementById('customNoteWrap');
            if (isOther) {
                customWrap.classList.add('show');
                document.getElementById('customNote').focus();
            } else {
                customWrap.classList.remove('show');
            }
            document.getElementById('confirmCancelBtn').disabled = false;
        }

        // Nếu chọn "Lý do khác" nhưng chưa nhập → disable nút
        document.getElementById('customNote').addEventListener('input', function () {
            const btn = document.getElementById('confirmCancelBtn');
            btn.disabled = this.value.trim() === '';
        });

        function submitCancel() {
            const selected = document.querySelector('input[name=cancelReason]:checked');
            if (!selected) return;
            if (selected.value === 'other') {
                const note = document.getElementById('customNote').value.trim();
                if (!note) {
                    document.getElementById('customNote').focus();
                    return;
                }
            }
            document.getElementById('cancelForm').submit();
        }

        // Nhấn bên ngoài modal để đóng
        document.getElementById('cancelModal').addEventListener('click', function (e) {
            if (e.target === this) closeCancelDialog();
        });
    </script>

</body>
</html>
