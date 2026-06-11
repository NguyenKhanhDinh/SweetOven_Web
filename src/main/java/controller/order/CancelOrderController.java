package controller.order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import service.OrderService;

import java.io.IOException;

@WebServlet("/cancel-order")
public class CancelOrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");
        String customerNote =  request.getParameter("customerNote");

        if(idStr==null||idStr.isBlank()){
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        int orderId;
        try {
            orderId = Integer.parseInt(idStr.trim());
        }catch (NumberFormatException e){
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        Order order = orderService.getOrderById(orderId);
        if(order==null || !order.getUserId().equals(user.getId()) || order.getOrderStatus()<1 || order.getOrderStatus()>3){
            response.sendRedirect(request.getContextPath() + "/order-detail?id="+orderId);
            return;
        }
        String finalReason;
        if("orther".equals(reason) && customerNote != null && !customerNote.isBlank()){
            finalReason = customerNote.trim();
        }else if( reason != null && !reason.isBlank()){
            finalReason = reason.trim();
        }else{
            finalReason = "Không có lý do";
        }
        orderService.cancelOrder(orderId,finalReason);
        response.sendRedirect(request.getContextPath() + "/order-detail?id="+orderId);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
}
