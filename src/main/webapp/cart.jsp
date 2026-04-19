<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | Sweet Oven Bakery</title>
    <meta name="description" content="Tiệm bánh ngọt & đồ nướng thủ công - Sweet Oven Bakery" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/picture/logo.png">

    <!-- Các thư viện bên ngoài -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">


    <style>
        :root {
            --primary: #8B4513;
            --secondary: #D4A76A;
            --accent: #8A4B24;
            --muted: #85756b;
            --border: #f2e7de;
            --bg: #fffdfb;
            --radius: 14px;
            --brand: #3c2f27;
        }

        /* --- SỬA LỖI LAYOUT BẰNG FLEXBOX --- */
        body {
            padding-top: 100px;
            font-family: 'Quicksand', sans-serif;
            background: var(--bg);
            color: var(--brand);
            margin: 0;
            /* Cấu trúc Flexbox giúp đẩy footer xuống đáy */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        main {
            padding: 20px 0 60px 0;
            /* Bắt buộc main giãn ra để lấp đầy khoảng trống */
            flex: 1 0 auto;
        }
        /* ------------------------------------ */

        /* Đổi h1 thành class để tránh ảnh hưởng đến h1 của Header/Footer */
        .cart-title {
            text-align: center;
            margin-bottom: 40px;
            font-size: 32px;
            color: var(--brand);
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .content {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            background: white;
            border-radius: var(--radius);
            box-shadow: 0 6px 18px rgba(92, 44, 22, 0.05);
            overflow: hidden;
        }

        .content th {
            background: #faf7f4;
            color: var(--brand);
            text-align: left;
            padding: 16px 20px;
            font-size: 15px;
            font-weight: 600;
        }

        .content td {
            padding: 20px;
            border-top: 1px solid var(--border);
            vertical-align: middle;
        }

        .san-pham {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .san-pham img {
            width: 100px;
            height: 100px;
            border-radius: 10px;
            border: 1px solid #eee;
            object-fit: cover;
        }

        .img-container {
            position: relative;
            width: 100px;
            height: 100px;
        }

        .out-of-stock-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            text-transform: uppercase;
            border-radius: 10px;
            z-index: 2;
        }

        .stock-warning {
            color: #d9534f;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .product-info h2 {
            font-size: 16px;
            color: var(--brand);
            margin: 0;
            font-weight: 600;
        }

        .product-info p {
            font-size: 13px;
            color: var(--muted);
            margin: 4px 0;
        }

        .qty-control {
            display: inline-flex;
            align-items: center;
            border: 1px solid #ccc;
            border-radius: 6px;
            overflow: hidden;
        }

        .qty-control button {
            background: linear-gradient(135deg, var(--primary), #A0522D);
            color: #fff;
            border: none;
            width: 32px;
            height: 32px;
            cursor: pointer;
            font-size: 18px;
            font-weight: 600;
            transition: background 0.2s;
        }

        .qty-control button:hover {
            background: linear-gradient(135deg, var(--secondary), #E6B17E);
        }

        .qty-control input {
            width: 50px;
            height: 32px;
            border: none;
            text-align: center;
            font-size: 16px;
            font-weight: 600;
            color: var(--brand);
            background: #fffdfb;
            line-height: 32px;
            appearance: textfield;
        }

        .qty-control input::-webkit-inner-spin-button,
        .qty-control input::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .checkout-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-top: 20px;
        }

        .btn-checkout {
            width: 250px;
            background: linear-gradient(135deg, var(--primary), #A0522D);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            text-transform: uppercase;
        }

        .btn-checkout:hover:not(:disabled) {
            background: linear-gradient(135deg, var(--secondary), #E6B17E);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(92, 26, 11, 0.2);
        }

        .btn-checkout:disabled {
            background: #ccc;
            cursor: not-allowed;
            color: #666;
        }

        @media (max-width: 768px) {
            body {
                padding-top: 80px;
            }

            .content th,
            .content td {
                padding: 12px 15px;
            }

            .san-pham {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .san-pham img {
                width: 80px;
                height: 80px;
            }

            .btn-checkout {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<!-- Import component Header -->
<jsp:include page="components/header.jsp" />

<main>
    <div class="container">
        <!-- Đã sửa thành class .cart-title -->
        <h1 class="cart-title">GIỎ HÀNG</h1>

        <table class="content" aria-label="Giỏ hàng">
            <thead>
            <tr>
                <th>Thông tin chi tiết sản phẩm</th>
                <th>Đơn giá</th>
                <th>Số lượng</th>
                <th>Tổng giá</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${empty cart.items}">
                <tr>
                    <td colspan="5" style="text-align:center; padding: 40px; color: #888;">
                        <i class="fas fa-shopping-basket fa-3x mb-3" style="color: #ddd;"></i><br>
                        Giỏ hàng của bạn đang trống
                    </td>
                </tr>
            </c:if>

            <c:set var="anyOutOfStock" value="false" />
            <c:forEach var="item" items="${cart.items}">
                <c:if test="${item.product.stockQuantity <= 0}">
                    <c:set var="anyOutOfStock" value="true" />
                </c:if>
                <tr>
                    <td class="san-pham">
                        <div class="img-container">
                            <img src="${item.imageUrl}" alt="${item.product.name}">
                            <c:if test="${item.product.stockQuantity <= 0}">
                                <div class="out-of-stock-overlay">Hết hàng</div>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <h2>${item.product.name}</h2>
                            <c:if test="${item.product.stockQuantity > 0 && item.product.stockQuantity < item.quantity}">
                                <span class="stock-warning">Số lượng trong kho không đủ (còn ${item.product.stockQuantity})</span>
                            </c:if>
                        </div>
                    </td>

                    <td>
                        <fmt:formatNumber value="${item.product.displayPrice}" type="number" /> VNĐ
                    </td>

                    <td>
                        <div class="qty-control">
                            <!-- Giảm -->
                            <form action="${pageContext.request.contextPath}/update-cart" method="post" style="display:inline">
                                <input type="hidden" name="productId" value="${item.product.id}">
                                <input type="hidden" name="action" value="decrease">
                                <button type="submit">−</button>
                            </form>

                            <input type="number" value="${item.quantity}" readonly>

                            <!-- Tăng -->
                            <form action="${pageContext.request.contextPath}/update-cart" method="post" style="display:inline">
                                <input type="hidden" name="productId" value="${item.product.id}">
                                <input type="hidden" name="action" value="increase">
                                <button type="submit">+</button>
                            </form>
                        </div>
                    </td>

                    <td>
                        <fmt:formatNumber value="${item.product.displayPrice * item.quantity}" type="number" /> VNĐ
                    </td>

                    <td style="text-align:center">
                        <form action="${pageContext.request.contextPath}/del-item" method="post" onsubmit="return confirm('Xóa sản phẩm này?')">
                            <input type="hidden" name="productId" value="${item.product.id}">
                            <button type="submit" class="btn btn-link text-danger" title="Xóa sản phẩm">
                                <i class="fa-solid fa-trash-can"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- Bấm nút Thanh toán -->
        <c:if test="${not empty cart.items}">
            <div class="checkout-actions">
                <c:choose>
                    <c:when test="${anyOutOfStock}">
                        <button class="btn-checkout" type="button" disabled title="Vui lòng xóa sản phẩm hết hàng trước khi thanh toán">
                            Thanh toán
                        </button>
                        <p class="stock-warning mt-2 text-end">Vui lòng xóa sản phẩm <strong>Hết hàng</strong> để tiếp tục.</p>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/checkout" method="POST">
                            <button type="submit" class="btn-checkout">Thanh toán</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

    </div>
</main>

<!-- Import component Footer -->
<jsp:include page="components/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>