package dao;

import model.UserFavorites;
import utils.JdbiConnector;

import java.util.List;

public class UserFavoritesDao {
    public List<UserFavorites> getUserFavoritesByUserId(Integer userid) {
        String sql = """
                SELECT id,user_id as userId,product_id as productId,created_at as createdAt
                FROM user_favorites WHERE user_id = :userId ORDER BY created_at DESC 
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userid).mapToBean(UserFavorites.class).list());
    }

    public boolean removeUserFavorites(int productId, int userId) {
        String sql = """
                DELETE FROM user_favorites WHERE product_id = :productId AND user_id = :userId
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("productId", productId).bind("userId", userId).execute()) > 0;

    }

    public boolean addFavorite(int productId, int userId) {
        String sql = "INSERT IGNORE INTO user_favorites(user_id, product_id,created_at) VALUES (:userId,:productId,NOW())";
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(sql).bind("userId", userId).bind("productId",productId).execute()) > 0;
    }
    public boolean isFavorite(int productId, int userId) {
        String sql = " SELECT COUNT(*) FROM user_favorites WHERE user_id = :userId AND product_id = :productId ";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId",userId).bind("productId",productId).mapTo(Integer.class).one()) > 0;
    }
    public List<Integer> getUserFavoritesProductIds(int userId) {
        String sql = "SELECT product_id FROM user_favorites WHERE user_id = :userId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId",userId).mapTo(Integer.class).list());
    }
}
