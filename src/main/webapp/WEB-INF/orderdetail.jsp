<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng | Sweet Oven</title>

    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Quicksand', sans-serif;
            background: #FFF9F0;
        }

        .order-container {
            max-width: 1100px;
            margin: 120px auto 40px;
        }

        .card-custom {
            background: #fff;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .status {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
        }

        .status-pending { background:#FEF3C7; color:#92400E; }
        .status-delivering { background:#DBEAFE; color:#1E40AF; }
        .status-completed { background:#D1FAE5; color:#065F46; }
        .status-cancelled { background:#FECACA; color:#991B1B; }

        .product-row {
            display:flex;
            align-items:center;
            gap:15px;
            margin-bottom:12px;
        }

        .product-img {
            width:70px;
            height:70px;
            border-radius:10px;
            object-fit:cover;
            transition:0.2s;
        }

        .product-row a:hover img {
            transform: scale(1.05);
        }

        .summary {
            border-top:1px solid #eee;
            margin-top:15px;
            padding-top:10px;
        }

        .summary div {
            display:flex;
            justify-content:space-between;
            margin-bottom:8px;
        }

        .summary .total {
            font-weight:700;
            font-size:18px;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="/components/header.jsp"/>


    <!-- HEADER -->
    <div class="card-custom mb-4">
        <div class="order-header">
            <div>
                <b>Đơn hàng #${order.orderCode}</b><br>
                ${order.orderDateFormatted}
            </div>

            <div>
                <c:choose>
                    <c:when test="${order.orderStatus == '1'}">
                        <span class="status status-pending">Chờ xác nhận</span>
                    </c:when>
                    <c:when test="${order.orderStatus == '2'}">
                        <span class="status status-pending">Chờ lấy hàng</span>
                    </c:when>
                    <c:when test="${order.orderStatus == '3'}">
                        <span class="status status-delivering">Đang giao</span>
                    </c:when>
                    <c:when test="${order.orderStatus == '4'}">
                        <span class="status status-completed">Đã giao</span>
                    </c:when>
                    <c:when test="${order.orderStatus == '5'}">
                        <span class="status status-cancelled">Đã hủy</span>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- PRODUCTS -->
    <div class="card-custom mb-4">
        <h5>Sản phẩm</h5>

        <c:forEach var="item" items="${orderDetails}">
            <div class="product-row">

                <!-- CLICK IMAGE -->
                <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">
                    <img class="product-img"
                         src="${not empty item.productImage ? item.productImage : 'assets/picture/logo.png'}">
                </a>

                <!-- CLICK NAME -->
                <div class="flex-grow-1">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}"
                       style="text-decoration:none; color:black;">
                        <b>${item.productName}</b>
                    </a>
                    <br>
                    <small>Số lượng: ${item.quantity}</small>
                </div>

                <!-- PRICE -->
                <div>
                    <fmt:formatNumber value="${item.totalPrice}" type="number"/> VNĐ
                </div>

            </div>
        </c:forEach>

        <!-- SUMMARY -->
        <div class="summary">
            <div>
                <span>Tiền hàng</span>
                <span><fmt:formatNumber value="${order.subTotal}" type="number"/> VNĐ</span>
            </div>

            <c:if test="${order.discountAmount > 0}">
                <div>
                    <span>Giảm giá</span>
                    <span>- <fmt:formatNumber value="${order.discountAmount}" type="number"/> VNĐ</span>
                </div>
            </c:if>

            <div>
                <span>Phí ship</span>
                <span><fmt:formatNumber value="${order.shippingFee}" type="number"/> VNĐ</span>
            </div>

            <div class="total">
                <span>Tổng</span>
                <span><fmt:formatNumber value="${order.totalAmount}" type="number"/> VNĐ</span>
            </div>
        </div>
    </div>

    <!-- INFO -->
    <div class="row">
        <div class="col-md-6">
            <div class="card-custom">
                <h5>Giao hàng</h5>
                <p><b>${order.fullName}</b></p>
                <p>${order.phoneNumber}</p>
                <p>${order.address}</p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card-custom">
                <h5>Ghi chú</h5>
                <p>${not empty order.note ? order.note : 'Không có ghi chú'}</p>
            </div>
        </div>
    </div>

</div>

<!-- FOOTER -->
<jsp:include page="/components/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>