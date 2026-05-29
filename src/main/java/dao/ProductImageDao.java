package dao;

import model.ProductImage;
import utils.JdbiConnector;

import java.util.List;

public class ProductImageDao {

    // Thêm ảnh
    public void insertImage(int productId, String imageUrl, boolean isPrimary) {
        String sql = """
            INSERT INTO productimage (product_id, image_url, is_primary)
            VALUES (:productId, :imageUrl, :isPrimary)
        """;

        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .bind("imageUrl", imageUrl)
                        .bind("isPrimary", isPrimary)
                        .execute()
        );
    }

    // Lấy ảnh chính
    public String getPrimaryImage(int productId) {
        String sql = """
            SELECT image_url FROM productimage
            WHERE product_id = :productId AND is_primary = 1
            LIMIT 1
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapTo(String.class)
                        .findOne()
                        .orElse("assets/picture/logo.png")
        );
    }

    // Lấy tất cả ảnh của sản phẩm
    public List<ProductImage> getProductImages(int productId) {
        String sql = """
            SELECT * FROM productimage
            WHERE product_id = :productId
            ORDER BY is_primary DESC
        """;

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapToBean(ProductImage.class)
                        .list()
        );
    }

    // Xoá ảnh
    public void deleteImage(int imageId) {
        String sql = "DELETE FROM productimage WHERE id = :id";

        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", imageId)
                        .execute()
        );
    }
    /**
     * Tìm ảnh theo productId
     */
    public List<ProductImage> findByProductId(int productId) {
        String sql = "SELECT * FROM productimage WHERE product_id = :productId ORDER BY is_primary DESC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapToBean(ProductImage.class)
                        .list()
        );
    }

    /**
     * Cập nhật ảnh
     */
    public void update(ProductImage image) {
        String sql = "UPDATE productimage SET image_url = :imageUrl, is_primary = :isPrimary WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("imageUrl", image.getImageUrl())
                        .bind("isPrimary", image.isPrimary())
                        .bind("id", image.getId())
                        .execute()
        );
    }

    /**
     * Chèn ảnh mới
     */
    public int insert(ProductImage image) {
        String sql = "INSERT INTO productimage (product_id, image_url, is_primary) VALUES (:productId, :imageUrl, :isPrimary)";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", image.getProductId())
                        .bind("imageUrl", image.getImageUrl())
                        .bind("isPrimary", image.isPrimary())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }

    /**
     * Xóa tất cả ảnh của sản phẩm (dùng khi xóa sản phẩm)
     */
    public void deleteByProductId(int productId) {
        String sql = "DELETE FROM productimage WHERE product_id = :productId";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .execute()
        );
    }
}