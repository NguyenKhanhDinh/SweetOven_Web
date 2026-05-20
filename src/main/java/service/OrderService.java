package service;

import dao.OrderDao;
import dao.OrderDetailDao;
import model.Order;
import model.OrderDetail;

import java.util.List;

public class OrderService {
    OrderDao orderDao = new OrderDao();
    OrderDetailDao detailDao = new OrderDetailDao();
    public List<Order> getOrdersByUserId(int userId) {
        return orderDao.getOrdersByUserId(userId);
    }
    public Order getOrderById(int id){
        return orderDao.getOrderByOrderId(id);
    }

    public List<OrderDetail> getDetails(int id){
        return detailDao.getOrderDetailsByOrderId(id);
    }
}
