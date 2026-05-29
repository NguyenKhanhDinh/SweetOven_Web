<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tất Cả Voucher | Sweet Oven Bakery</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <%-- header CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/components/css/header.css"/>

    <style>
        body { background: #F9F6F0; font-family: 'Quicksand', 'Segoe UI', sans-serif; }

        .page-wrapper { margin-top: 90px; margin-bottom: 60px; }

        .page-header {
            background: linear-gradient(135deg, #d4722a 0%, #b85a1a 100%);
            border-radius: 18px;
            padding: 32px 36px;
            color: #fff;
            margin-bottom: 32px;
        }
        .page-header h2 { font-weight: 700; font-size: 26px; margin: 0 0 6px; }
        .page-header p  { margin: 0; opacity: .85; font-size: 14px; }

        /* ─── Voucher card (Shopee-style) ─────────────────────── */
        .vc-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 18px;
        }

        .vc-card {
            background: #fff;
            border-radius: 14px;
            display: flex;
            overflow: hidden;
            box-shadow: 0 3px 14px rgba(0,0,0,.07);
            transition: transform .18s, box-shadow .18s;
            position: relative;
        }
        .vc-card:not(.vc-saved):hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(212,114,42,.18);
        }

        /* stripe bên trái */
        .vc-stripe {
            width: 80px;
            flex-shrink: 0;
            background: linear-gradient(160deg, #d4722a, #b85a1a);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 14px 6px;
            gap: 8px;
        }
        .vc-stripe i { color: #fff; font-size: 22px; }
        .vc-stripe .vc-val {
            color: #fff;
            font-weight: 700;
            font-size: 17px;
            text-align: center;
            line-height: 1.2;
            word-break: break-word;
        }

        /* body */
        .vc-body {
            flex: 1;
            padding: 14px 16px;
            min-width: 0;
        }
        .vc-code {
            font-weight: 700;
            font-size: 16px;
            color: #1a1a1a;
            letter-spacing: .5px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .vc-desc {
            font-size: 13px;
            color: #555;
            margin: 4px 0 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .vc-meta { display: flex; flex-wrap: wrap; gap: 6px; font-size: 12px; color: #777; }
        .vc-meta span { display: flex; align-items: center; gap: 4px; }

        /* action */
        .vc-action {
            display: flex;
            align-items: center;
            padding: 0 16px;
            flex-shrink: 0;
        }

        /* saved state */
        .vc-saved .vc-stripe {
            background: linear-gradient(160deg, #22c55e, #16a34a);
        }
        .vc-saved { border: 2px solid #22c55e; }

        /* nút */
        .btn-save {
            background: linear-gradient(135deg, #d4722a, #b85a1a);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 14px;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            cursor: pointer;
            transition: opacity .15s;
        }
        .btn-save:hover { opacity: .85; }

        .btn-use {
            background: linear-gradient(135deg, #22c55e, #16a34a);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 14px;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: opacity .15s;
        }
        .btn-use:hover { opacity: .85; color: #fff; }

        /* dashed separator */
        .vc-sep {
            width: 1px;
            background: repeating-linear-gradient(to bottom, #e5e7eb 0, #e5e7eb 6px, transparent 6px, transparent 12px);
            margin: 10px 0;
        }

        /* toast */
        .toast-wrap { position: fixed; top: 80px; right: 24px; z-index: 9999; display: flex; flex-direction: column; gap: 10px; }
        .toast-item {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 18px rgba(0,0,0,.13);
            padding: 14px 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn .3s ease;
        }
        .toast-success { border-left: 4px solid #22c55e; }
        .toast-error   { border-left: 4px solid #ef4444; }
        @keyframes slideIn { from { transform: translateX(100%); opacity:0; } to { transform: translateX(0); opacity:1; } }

        /* empty */
        .empty-box { text-align: center; padding: 60px 20px; color: #aaa; }
        .empty-box i { font-size: 48px; margin-bottom: 14px; }

        /* badge đã lưu */
        .badge-saved {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #22c55e;
            color: #fff;
            font-size: 11px;
            font-weight: 600;
            border-radius: 20px;
            padding: 2px 9px;
        }
    </style>
</head>
<body>

<%-- HEADER --%>
<%@ include file="/components/header.jsp" %>

<%-- TOASTS --%>
<div class="toast-wrap" id="toast-wrap">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast-item toast-success" id="t-ok">
            <i class="fa fa-check-circle text-success"></i>
            <span>${sessionScope.successMsg}</span>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast-item toast-error" id="t-err">
            <i class="fa fa-times-circle text-danger"></i>
            <span>${sessionScope.errorMsg}</span>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>
</div>

<div class="container page-wrapper">

    <div class="page-header">
        <h2><i class="fa fa-ticket-alt me-2"></i>Tất Cả Voucher</h2>
        <p>Lưu và sử dụng voucher để nhận ưu đãi hấp dẫn cho đơn hàng của bạn!</p>
    </div>

    <c:choose>
        <c:when test="${empty discounts}">
            <div class="empty-box">
                <i class="fa fa-tag"></i>
                <div style="font-size:16px; margin-bottom:6px;">Hiện chưa có voucher nào.</div>
                <div style="font-size:13px;">Hãy quay lại sau bạn nhé!</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="vc-grid">
                <c:forEach var="d" items="${discounts}">
                    <c:set var="isSaved" value="${savedDiscountIds != null && savedDiscountIds.contains(d.id)}"/>
                    <div class="vc-card ${isSaved ? 'vc-saved' : ''}">

                        <c:if test="${isSaved}">
                            <span class="badge-saved"><i class="fa fa-check me-1"></i>Đã lưu</span>
                        </c:if>

                            <%-- stripe --%>
                        <div class="vc-stripe">
                            <i class="fas ${d.discountType == 1 ? 'fa-percent' : 'fa-hand-holding-usd'}"></i>
                            <div class="vc-val">
                                <c:choose>
                                    <c:when test="${d.discountType == 1}">
                                        <fmt:formatNumber value="${d.value}" maxFractionDigits="0"/>%
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${d.value}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                            <%-- separator --%>
                        <div class="vc-sep"></div>

                            <%-- body --%>
                        <div class="vc-body">
                            <div class="vc-code">${d.code}</div>
                            <div class="vc-desc">${d.description}</div>
                            <div class="vc-meta">
                                <span>
                                    <i class="fa fa-receipt"></i>
                                    Đơn tối thiểu <b>${d.displayMinOrder}</b>
                                </span>
                                <span>
                                    <i class="fa fa-clock"></i>
                                    HSD: <b>${d.formattedEndDate}</b>
                                </span>
                                <span>
                                    <c:choose>
                                        <c:when test="${d.discountType == 1}">
                                            <i class="fa fa-percent"></i> Giảm theo %
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa fa-hand-holding-usd"></i> Giảm cố định
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>

                            <%-- action --%>
                        <div class="vc-action">
                            <c:choose>
                                <c:when test="${isSaved}">
                                    <a href="${pageContext.request.contextPath}/my-cart?pendingVoucher=${d.code}"
                                       class="btn-use">
                                        <i class="fa fa-cart-shopping"></i>Sử dụng
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${empty sessionScope.user}">
                                            <a href="${pageContext.request.contextPath}/login?redirect=vouchers"
                                               class="btn-save">
                                                <i class="fa fa-bookmark me-1"></i>Lưu ngay
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/save-voucher"
                                                  style="margin:0;">
                                                <input type="hidden" name="discountId" value="${d.id}">
                                                <button type="submit" class="btn-save">
                                                    <i class="fa fa-bookmark me-1"></i>Lưu ngay
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/components/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/menu.js"></script>

<script>
    // Auto-dismiss toasts
    document.addEventListener('DOMContentLoaded', function () {
        ['t-ok', 't-err'].forEach(function (id) {
            var el = document.getElementById(id);
            if (!el) return;
            setTimeout(function () {
                el.style.transition = 'opacity .4s';
                el.style.opacity = '0';
                setTimeout(function () { el.remove(); }, 400);
            }, 3500);
        });
    });
</script>
</body>
</html>
