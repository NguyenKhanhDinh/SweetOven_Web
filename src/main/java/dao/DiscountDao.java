package dao;

import model.Discount;
import utils.JdbiConnector;

import java.util.List;

public class DiscountDao {
    public List<Discount> getAllDiscounts() {
    String sql = "SELECT * FROM discount ORDER BY created_at DESC";
    return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Discount.class).list());
    }
}
