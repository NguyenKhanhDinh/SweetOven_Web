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
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).mapToBean(UserDiscount.class).list());
    }

    public boolean isAlreadySaved(int userId, int discountId) {
        String sql = " SELECT COUNT(*) FROM user_discount WHERE user_id = :userId AND discount_id = :discountId ";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).bind("discountId", discountId).mapTo(Integer.class).findFirst().orElse(0) > 0);
    }

    public boolean saveDiscount(int userId, int discountId) {
        String sql = """
                INSERT INTO user_discount (user_id,discount_id,is_used,saved_at) VALUES (:userId,:discountId,0,NOW())
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("userId", userId).bind("discountId", discountId).execute() > 0);
    }

    public boolean markAsUsed(int userId, int discountId) {
        String sql = "UPDATE user_discount SET is_used = 1 WHERE user_id = :userId AND discount_id = :discountId AND is_used = 0";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("userId", userId).bind("discountId", discountId).execute() > 0);
    }

    public List<Integer> getSavedDiscountIds(int userId) {
        String sql = "SELECT discount_id FROM user_discount WHERE user_id = :userId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).mapTo(Integer.class).list());
    }

    public List<UserDiscount> getSavedActiveDiscounts(int userId) {
        String sql = """
                SELECT ud.id AS userDiscountId,ud.user_id AS userId,ud.is_used AS isUsed,ud.saved_at AS savedAt,d.id AS id,d.code AS code,
                    d.description AS description,d.discount_type AS discountType,d.value AS value,d.min_order_value AS minValueOrder,
                    d.start_date AS startDate,d.end_Date AS endDate,d.created_at AS createdAt,d.updated_at AS updatedAt
                FROM user_discount ud JOIN  discount d ON ud.discount_id = d.id
                WHERE ud.user_id = :userId AND ud.is_used = 0 AND (d.start_date IS NULL OR d.start_date <= NOW())
                    AND (d.end_date IS NULL OR d.end_date > NOW()) 
                ORDER BY ud.saved_at DESC
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).bind("userId", userId).mapToBean(UserDiscount.class).list());
    }
    public boolean isAlreadyUsed(int userId, int discountId) {
        String sql = "SELECT  COUNT(*) FROM user_discount WHERE user_id = :userId AND discount_id = :discountId  AND is_used = 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId",userId).bind("discountId", discountId).mapTo(Integer.class).findFirst().orElse(0) > 0);
    }
    public List<Integer> getUsedDiscountIds(int userId) {
        String sql = "SELECT discount_id FROM user_discount WHERE user_id = :userId AND is_used = 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId",userId).mapTo(Integer.class).list());
    }
}
