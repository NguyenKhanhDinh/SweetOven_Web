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
        if (orderId <0) return 0;
        for (CartItem item : items) {
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(orderId);
            detail.setProductId(item.getProduct().getId());
            detail.setQuantity(item.getQuantity());
            detail.setBuyPrice(item.getPrice());
            BigDecimal total = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            detailDao.insertOrderDetail(detail);
        }
        return orderId;
    }
}
