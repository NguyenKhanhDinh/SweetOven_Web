package controller.order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.OrderDetail;
import model.Product;
import model.User;
import service.OrderService;
import service.ProductService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/reorder")
public class ReorderController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath()+ "/login");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(request.getParameter("id"));
        }catch (NumberFormatException e){
            response.sendRedirect(request.getContextPath()+ "/user?tab=orders");
            return;
        }
        List<OrderDetail> orderDetails = orderService.getDetails(orderId);
        if (orderDetails == null || orderDetails.isEmpty()){
            response.sendRedirect(request.getContextPath()+ "/order-detail?id=" + orderId);
            return;
        }
        List<CartItem> checkoutItems = new ArrayList<>();
        BigDecimal subTotal = BigDecimal.ZERO;

        for (OrderDetail orderDetail : orderDetails) {
            Product product = productService.findById(orderDetail.getProductId());
            if (product == null || product.getStatus() != 1 || product.getStockQuantity() <orderDetail.getQuantity()){
                session.setAttribute("errorMsg","Một số sản phẩm hết hàng, vui lòng kiểm tra lại.");
                response.sendRedirect(request.getContextPath()+ "/order-detail?id=" + orderId);
                return;
            }
            BigDecimal price = product.getDisplayPrice();
            checkoutItems.add(new CartItem(orderDetail.getQuantity(),price,product,orderDetail.getProductImage()));
            subTotal = subTotal.add(price.multiply(BigDecimal.valueOf(orderDetail.getQuantity())));
        }
        String selectedIds = checkoutItems.stream().map(ci -> String.valueOf(ci.getProduct().getId())).collect(Collectors.joining(","));
        session.setAttribute("checkoutItems", checkoutItems);
        session.setAttribute("checkoutTotal", subTotal);
        session.setAttribute("checkoutSelectedIds", selectedIds);

        response.sendRedirect(request.getContextPath() +"/checkout");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}

}
