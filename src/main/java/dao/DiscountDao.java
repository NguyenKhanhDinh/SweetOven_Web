package dao;

import model.Discount;
import utils.JdbiConnector;

import java.util.List;

public class DiscountDao {
    public List<Discount> getAllDiscounts() {
        String sql = "SELECT * FROM discount ORDER BY created_at DESC";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Discount.class).list());
    }

    public Discount getDiscountByCode(String code) {
        String sql = "SELECT * FROM discount WHERE code = :code LIMIT 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("code", code).mapToBean(Discount.class).findFirst().orElse(null));
    }

    public Discount getDiscountById(int id) {
        String sql = "SELECT * FROM discount WHERE id = :id LIMIT 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id", id).mapToBean(Discount.class).findFirst().orElse(null));
    }
}
