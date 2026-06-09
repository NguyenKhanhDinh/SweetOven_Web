package dao;

import model.Discount;
import utils.JdbiConnector;

import java.util.List;

public class DiscountDao {
    private static final String SELECT_COLS = """
            SELECT id,code,description,discount_type AS discountType,value,min_order_value AS minValueOrder,
            start_date AS startDate,end_date AS endDate,created_at AS createdAt,updated_at AS updatedAt FROM discount
            """;


    public List<Discount> getAllDiscounts() {
        String sql = SELECT_COLS + " ORDER BY created_at DESC";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Discount.class).list());
    }

    public Discount getDiscountByCode(String code) {
        String sql = SELECT_COLS + " WHERE code = :code LIMIT 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("code", code).mapToBean(Discount.class).findFirst().orElse(null));
    }

    public Discount getDiscountById(int id) {
        String sql =SELECT_COLS + " WHERE id = :id LIMIT 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id", id).mapToBean(Discount.class).findFirst().orElse(null));
    }
}
