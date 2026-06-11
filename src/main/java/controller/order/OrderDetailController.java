package controller.order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderDetail;
import model.Product;
import service.OrderService;
import service.ProductService;

import java.io.IOException;

import java.util.List;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {
    OrderService orderService = new OrderService();
    ProductService productService = new ProductService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderID = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(orderID);
        List<OrderDetail> orderDetails = orderService.getDetails(orderID);

        boolean canReOrder = false;
        if(order != null && order.getOrderStatus() == 4 || order.getOrderStatus() == 5 && orderDetails != null && !orderDetails.isEmpty()) {
            canReOrder = true;
            for (OrderDetail orderDetail : orderDetails) {
                Product product = productService.findById(orderDetail.getProductId());
                if(product == null || product.getStatus() !=1 || product.getStockQuantity() < orderDetail.getQuantity()) {
                    canReOrder = false;
                    break;
                }
            }
        }

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("canReOrder", canReOrder);
        request.getRequestDispatcher("/WEB-INF/orderdetail.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
}
