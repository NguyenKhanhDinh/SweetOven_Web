package service;

import dao.OrderDao;
import dao.OrderDetailDao;
import model.CartItem;
import model.Order;
import model.OrderDetail;

import java.math.BigDecimal;
import java.util.List;

public class OrderService {
    OrderDao orderDao = new OrderDao();
    OrderDetailDao detailDao = new OrderDetailDao();

    public List<Order> getOrdersByUserId(int userId) {
        return orderDao.getOrdersByUserId(userId);
    }

    public Order getOrderById(int id) {
        return orderDao.getOrderByOrderId(id);
    }

    public List<OrderDetail> getDetails(int id) {
        return detailDao.getOrderDetailsByOrderId(id);
    }
    public int createOrder(Order order,List<CartItem> items) {
        int orderId = orderDao.insertOrder(order);
        if (orderId <=0) return 0;
        for (CartItem item : items) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(orderId);
            detail.setProductId(item.getProduct().getId());
            detail.setQuantity(item.getQuantity());
            detail.setBuyPrice(item.getPrice());
            BigDecimal total = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            detail.setTotalPrice(total);
            detailDao.insertOrderDetail(detail);
        }
        return orderId;
    }
    public void cancelOrder(int orderId,String reason) {
        orderDao.cancleOrder(orderId,reason);
    }

    // admin
    public int countAllOrders() {
        return orderDao.countAllOrders();
    }
    public int countByStatus(int status) {
        return orderDao.countOrdersByStatus(status);
    }
    public int countOrdersToday(){
        return orderDao.countOrdersToday();
    }
    public List<Order> getOrders(String keyword,int status,int paymentMethod,int page,int pageSize) {
        if (page<1) page = 1;
        return orderDao.getOrders(keyword,status,paymentMethod,page,pageSize);
    }
    public int countOrders(String keyword,int status,int paymentMethod) {
        return orderDao.countOrders(keyword,status,paymentMethod);
    }
    public Order findById(int id) {
        return orderDao.findById(id);
    }
    public List<OrderDetail> getOrderDetails(int orderId) {
        return orderDao.getOrderDetails(orderId);
    }
    public enum UpdateResult {SUCCESS,NOT_FOUND,INVALID_TRANSITION,ERROR }

    public UpdateResult updateOrderStatus(int orderId,int newStatus) {
        Order order = orderDao.findById(orderId);
        if (order==null) return UpdateResult.NOT_FOUND;
        int current = order.getOrderStatus();
        if (newStatus!= current +1 || current >= 4 || newStatus == 5) return UpdateResult.INVALID_TRANSITION;
        return orderDao.updateOrderStatus(orderId,newStatus) ? UpdateResult.SUCCESS : UpdateResult.ERROR;
    }
    public UpdateResult cancelOrderAdmin(int orderId,String reason) {
        Order order = orderDao.findById(orderId);
        if (order==null) return UpdateResult.NOT_FOUND;
        if (order.getOrderStatus() >= 4) return UpdateResult.INVALID_TRANSITION;
        String safeReason = (reason == null || reason.isBlank()) ? "Admin hủy đơn" : reason.trim();
        return orderDao.cancelOrderAdmin(orderId,safeReason) ?  UpdateResult.SUCCESS : UpdateResult.ERROR;
    }
    public UpdateResult updateOrderCode(int orderId,String newCode) {
        if(newCode == null || newCode.isBlank()) return UpdateResult.ERROR;
        return orderDao.updateOrderCode(orderId,newCode) ? UpdateResult.SUCCESS :UpdateResult.ERROR;
    }
    public UpdateResult forceUpdateOrderStatus(int orderId,int newStatus) {
        Order order = orderDao.findById(orderId);
        if (order==null) return UpdateResult.NOT_FOUND;
        int current = order.getOrderStatus();
        if (newStatus < current) return UpdateResult.INVALID_TRANSITION;
        if (current == 4 && newStatus == 5) return UpdateResult.INVALID_TRANSITION;
        if(newStatus == current) return UpdateResult.SUCCESS;
        if(newStatus == 5){
            return orderDao.cancelOrderAdmin(orderId,"GHN: Đơn hàng bị hủy/ hoàn hàng") ? UpdateResult.SUCCESS : UpdateResult.ERROR;
        }
        return orderDao.updateOrderStatus(orderId,newStatus) ? UpdateResult.SUCCESS : UpdateResult.ERROR;
    }
}
