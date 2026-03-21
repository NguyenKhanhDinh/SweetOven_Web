package dao;

import model.Product;
import utils.JdbiConnector;

import java.util.List;

public class ProductDao {
    // lấy ra hiển thị sản phẩm nổi bật
    public List<Product> getFeaturedProducts() {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM Product p " +
                "LEFT JOIN ProductImage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.is_featured = 1 AND p.status = 1 " +
                "ORDER BY RAND() " +
                "LIMIT 4";
        return JdbiConnector.jdbi.withHandle(handle ->handle.createQuery(sql).mapToBean(Product.class).list());
    }
    // lấy hết sản phẩm hiển thị lên
    public List<Product> getListProduct() {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM Product p " +
                "LEFT JOIN ProductImage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 " +
                "ORDER BY p.id DESC";
        return JdbiConnector.jdbi.withHandle(handle ->handle.createQuery(sql).mapToBean(Product.class).list());
    }
    public int addProduct(Product p) {
        String sql = "INSERT INTO Product (product_code, category_id, name, price, stock_quantity, status, description, ingredients, is_featured, created_at, updated_at) "
                + "VALUES (:productCode,:categoryId, :name, :price,:stockQuantity, :status, :description, :ingredients, :isFeatured, now(),now())";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createUpdate(sql).bindBean(p).executeAndReturnGeneratedKeys("id").mapTo(int.class).one());
    }
    // tìm sản phẩm dựa trên id xài cho xem chi tiết sản phẩm
    public Product findById(int id) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM Product p " +
                "LEFT JOIN ProductImage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.id =:id";
        return JdbiConnector.jdbi.withHandle(handle ->handle.createQuery(sql).mapToBean(Product.class).one());
    }
    // hiển thị sản phẩm liên quan
    public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM Product p " +
                "LEFT JOIN ProductImage pi " +
                "ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.category_id = :categoryId " +
                "AND p.id != :currentProductId " +
                "AND p.status = 1 " +
                "ORDER BY RAND() " +
                "LIMIT " + limit;
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }
    //tìm sản phẩm dụa trên danh mục
    public List<Product> getProductsByCategory(int categoryId) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM Product p " +
                "LEFT JOIN ProductImage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 AND p.category_id = :categoryId " +
                "ORDER BY p.id DESC";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }
    // tìm theo keyword
}
