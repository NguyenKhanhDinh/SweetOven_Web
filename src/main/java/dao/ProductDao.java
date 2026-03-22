package dao;

import model.Product;
import utils.JdbiConnector;

import java.util.List;

public class ProductDao {
    // featured products for homepage
    public List<Product> getFeaturedProducts() {

        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +

                "WHERE p.is_featured = 1 AND p.status = 1 " +
                "ORDER BY RAND() " +
                "LIMIT 4";
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).mapToBean(Product.class).list());
    }
    // lấy hết sản phẩm hiển thị lên
    public List<Product> getListProduct() {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 " +
                "ORDER BY p.id DESC";
        return JdbiConnector.jdbi.withHandle(handle ->handle.createQuery(sql).mapToBean(Product.class).list());
    }
    public int addProduct(Product p) {
        String sql = "INSERT INTO product (product_code, category_id, name, price, stock_quantity, status, description, ingredients, is_featured, created_at, updated_at) "
                + "VALUES (:productCode,:categoryId, :name, :price,:stockQuantity, :status, :description, :ingredients, :isFeatured, now(),now())";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createUpdate(sql).bindBean(p).executeAndReturnGeneratedKeys("id").mapTo(int.class).one());
    }
    // tìm sản phẩm dựa trên id xài cho xem chi tiết sản phẩm
    public Product findById(int id) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.id =:id";
        return JdbiConnector.jdbi.withHandle(handle ->handle.createQuery(sql).bind("id",id).mapToBean(Product.class).findOne().orElse(null));
    }
    // hiển thị sản phẩm liên quan
    public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi " +
                "ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.category_id = :categoryId " +
                "AND p.id != :currentProductId " +
                "AND p.status = 1 " +
                "ORDER BY RAND() " +
                "LIMIT "+limit;
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).bind("categoryId", categoryId) .bind("currentProductId", currentProductId) .bind("limit", limit).mapToBean(Product.class).list());
    }
    //tìm sản phẩm dụa trên danh mục
    public List<Product> getProductsByCategory(int categoryId) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 AND p.category_id = :categoryId " +
                "ORDER BY p.id DESC";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).bind("categoryId", categoryId).mapToBean(Product.class).list());
    }
    // phân trang và tìm kiếm sản phẩm trong trang menu
    public List<Product> getProductsPaging(int offset, int limit, String keyword, Integer categoryId, String sort){
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 ";
        if (keyword != null && !keyword.isEmpty()) {
            sql+=("AND p.name LIKE :keyword ");
        }

        if (categoryId != null) {
            sql+=("AND p.category_id = :categoryId ");
        }
        // sắp xếp
        switch (sort) {
            case "price-asc":
                sql+=("ORDER BY p.price ASC ");
                break;
            case "price-desc":
                sql+=("ORDER BY p.price DESC ");
                break;
            case "name-asc":
                sql+=("ORDER BY p.name ASC ");
                break;
            case "name-desc":
                sql+=("ORDER BY p.name DESC ");
                break;
            default:
                sql+=("ORDER BY p.id DESC ");
        }
        sql+=("LIMIT :limit OFFSET :offset");

        final String finalSql = sql;

        return JdbiConnector.jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql)
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (keyword != null && !keyword.isEmpty()) {
                query.bind("keyword", "%" + keyword + "%");
            }

            if (categoryId != null) {
                query.bind("categoryId", categoryId);
            }

            return query.mapToBean(Product.class).list();
        });
    }
    //đếm tổng sản phẩm
    public int countPrducts(String keyword, Integer categoryId) {
        String sql = "SELECT COUNT(*) FROM product WHERE product.status = 1";
        if (keyword != null && !keyword.isEmpty()) {
            sql += "AND p.name LIKE :keyword ";
        }

        if (categoryId != null) {
            sql += "AND p.category_id = :categoryId ";
        }
        final String finalSql = sql;
        return JdbiConnector.jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);

            if (keyword != null && !keyword.isEmpty()) {
                query.bind("keyword", "%" + keyword + "%");
            }

            if (categoryId != null) {
                query.bind("categoryId", categoryId);
            }

            return query.mapTo(Integer.class).one();
        });
    }
    // lấy ảnh phụ cho sản phẩm
    public List<String> getProductImages(int productId) {
        String sql = "SELECT image_url FROM productImage WHERE product_id = :productId";

        return JdbiConnector.jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapTo(String.class)
                        .list()
        );
    }
}
