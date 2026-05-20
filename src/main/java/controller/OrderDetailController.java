package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderDetail;
import service.OrderService;

import java.io.IOException;

import java.util.List;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {
    OrderService orderService = new OrderService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== OrderDetailController doGet called, id=" + request.getParameter("id"));
        int orderID = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(orderID);
        System.out.println("=== order=" + order);
        List<OrderDetail> orderDetails = orderService.getDetails(orderID);
        System.out.println("=== orderDetails size=" + orderDetails.size());
        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.getRequestDispatcher("/WEB-INF/orderdetail.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
}
