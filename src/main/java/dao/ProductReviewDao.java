package dao;

import model.ProductReview;
import utils.JdbiConnector;

import java.util.List;

public class ProductReviewDao {

    public boolean insert(ProductReview review) {
        String sql = "INSERT INTO product_review(product_id,order_id,user_id,rating,comment,created_at) VALUES(:productId,:orderId,:userId,:rating,:comment,NOW())";
        try {
            return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bindBean(review).execute() > 0);
        }catch (Exception e) {
            return false;
        }
    }
    public boolean hasReviewed(int productId, int orderId) {
        String sql = "SELECT COUNT(*) FROM product_review WHERE product_id = :productId AND order_id = :orderId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("productId",productId).bind("orderId",orderId).mapTo(Integer.class).one()) > 0;
    }
    public List<ProductReview> getProductId(int productId) {
        String sql = """
                SELECT pr.id,pr.product_id AS productId,pr.order_id AS orderId,pr.user_id AS userId,u.full_name AS userName,pr.rating AS rating,pr.comment,pr.created_at AS createdAt
                FROM product_review pr LEFT JOIN user u ON pr.user_id = u.id
                WHERE pr.product_id = :productId
                ORDER BY pr.rating DESC,pr.created_at DESC
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).bind("productId",productId).mapToBean(ProductReview.class).list());
    }
    public List<ProductReview> getTopReviewes(int productId, int limit) {
        String sql = """
                SELECT pr.id,pr.product_id AS productId,pr.order_id AS orderId,pr.user_id AS userId,u.full_name AS userName,pr.rating AS rating,pr.comment,pr.created_at AS createdAt
                FROM product_review pr LEFT JOIN user u ON pr.user_id = u.id
                WHERE pr.product_id = :productId
                ORDER BY pr.rating DESC,pr.created_at DESC
                LIMIT :lim
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).bind("productId",productId).bind("lim",limit).mapToBean(ProductReview.class).list());
    }
    public int countByProductId(int productId) {
        String sql = "SELECT COUNT(*) FROM product_review WHERE product_id = :productId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("productId",productId).mapTo(Integer.class).one());
    }
    public double getAverageRating(int productI) {
        String sql = "SELECT COALESCE(AVG(rating),0) FROM product_review WHERE product_id = :productId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("productId",productI).mapTo(Double.class).one());
    }
}
