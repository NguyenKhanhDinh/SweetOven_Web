package service;

import dao.ProductReviewDao;
import model.ProductReview;

import java.util.List;

public class ProductReviewService {
    private final ProductReviewDao productReviewDao = new ProductReviewDao();

    public String submitReview(ProductReview review) {
        if (review == null)  return "Dữ liệu rỗng";
        if (review.getProductId() <= 0) return "Sản phẩm không hợp lệ";
        if (review.getOrderId() <= 0) return "Đơn hàng không hợp lệ";
        if (review.getUserId() <= 0) return "Bạn cần đăng nhập";
        if (review.getRating() < 1 || review.getRating() > 5) return "Số sao không hợp lệ(1-5)";
        if (review.getComment() != null && review.getComment().length() > 1000) return "Nhận xét tối đa 1000 ký tự";

        if (productReviewDao.hasReviewed(review.getProductId(), review.getOrderId())) {
            return "ALREADY_REVIEWED";
        }
        boolean ok = productReviewDao.insert(review);
        return ok ? "SUCCESS" : "Lỗi database";
    }
    public boolean hasReviewed(int productId, int orderId) {
        return productReviewDao.hasReviewed(productId, orderId);
    }
    public List<ProductReview> getTopReviews(int productId,int limit) {
        return productReviewDao.getTopReviewes(productId,limit);
    }
    public List<ProductReview> getAllReviews(int productId) {
        return productReviewDao.getProductId(productId);
    }
    public int getTotalReviews(int productId) {
        return productReviewDao.countByProductId(productId);
    }
    public double getAverageRatings(int productId) {
        return productReviewDao.getAverageRating(productId);
    }
}
