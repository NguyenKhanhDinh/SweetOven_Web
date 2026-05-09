package dao;

import model.UserDiscount;
import utils.JdbiConnector;

import java.util.ArrayList;
import java.util.List;

public class UserDiscountDao {
    public List<UserDiscount> getSavedDiscounts(int userId) {
      String sql = """
              SELECT ud.id AS userDiscountId,ud.user_id AS userId,ud.is_used AS isUsed,ud.saved_at AS savedAt,
                 d.id AS id,d.code AS code,d.description AS description,d.discount_type AS discountType,
                 d.value AS value,d.min_order_value AS minValueOrder,d.start_date AS startDate,d.end_Date AS endDate,
                 d.created_at AS createdAt, d.updated_at AS updatedAt
              FROM user_discount ud JOIN discount d ON ud.discount_id = d.id
              WHERE ud.user_id = :userId
              ORDER BY ud.saved_at DESC
              """;
      return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId",userId).mapToBean(UserDiscount.class).list());
    }
    public boolean saveDiscount(int userId, int discountId) {
        String sql = """
                INSERT INTO user_discount (user_id,discount_id) VALUES (:userId,:discountId,NOW())
                """;
        return  JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(sql).bind("userId",userId).bind("discountId",discountId).execute()>0);
    }
}
