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
    public int insertDiscount(Discount d) {
        String sql = """
                INSERT INTO discount (code,description,discount_type,value,min_order_value,start_date,end_date,created_at,updated_at)
                VALUES (:code,:description,:discountType,:value,:minValueOrder,:startDate,:endDate,:createdAt,:updatedAt)
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql)
                .bind("code",d.getCode())
                .bind("description",d.getDescription())
                .bind("discountType",d.getDiscountType())
                .bind("value",d.getValue())
                .bind("minValueOrder",d.getMinValueOrder())
                .bind("startDate",d.getStartDate())
                .bind("endDate",d.getEndDate())
                .bind("createdAt",d.getCreatedAt())
                .bind("updatedAt",d.getUpdatedAt())
                .executeAndReturnGeneratedKeys("id").mapTo(Integer.class).findFirst().orElse(-1));
    }
    public boolean updateDiscount(Discount d) {
        String sql = """
               UPDATE discount SET code = :code, description = :description,
               discount_type = :discountType, value = :value, min_order_value = :minValueOrder,
               start_date = :startDate, end_date = :endDate, updated_at = :updatedAt
               WHERE id=:id; 
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(sql)
                .bind("id",d.getId())
                .bind("code",d.getCode())
                .bind("description",d.getDescription())
                .bind("discountType",d.getDiscountType())
                .bind("value",d.getValue())
                .bind("minValueOrder",d.getMinValueOrder())
                .bind("startDate",d.getStartDate())
                .bind("endDate",d.getEndDate())
                .bind("updatedAt",d.getUpdatedAt()).execute() >0);
    }
    public boolean deleteDiscount(int id) {
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate("DELETE FROM discount WHERE id = :id").bind("id",id).execute() > 0);
    }
}
