package dao;

import model.Product;
import utils.JdbiConnector;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ProductDao {
    // featured products for homepage
    public List<Product> getFeaturedProducts() {

        String sql = "SELECT p.*, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.is_featured = 1 AND p.status = 1 " +
                "ORDER BY RAND() " +
                "LIMIT 4";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }

    // lấy hết sản phẩm hiển thị lên
    public List<Product> getListProduct() {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 " +
                "ORDER BY p.id DESC";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }

    public int addProduct(Product p) {
        String sql = "INSERT INTO product (product_code, category_id, name, original_price, discount_price, stock_quantity, status, description, ingredients, is_featured, created_at, updated_at) "
                + "VALUES (:productCode,:categoryId, :name, :discountPrice, :stockQuantity,:stockQuantity, :status, :description, :ingredients, :isFeatured, now(),now())";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createUpdate(sql).bindBean(p).executeAndReturnGeneratedKeys("id").mapTo(int.class).one());
    }

    // tìm sản phẩm dựa trên id xài cho xem chi tiết sản phẩm
    public Product findById(int id) {
        String sql = "SELECT p.*, pi.image_url " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.id =:id";
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).bind("id", id).mapToBean(Product.class).findOne().orElse(null));
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
                "LIMIT " + limit;
        return JdbiConnector.jdbi.withHandle(handle -> handle.createQuery(sql).bind("categoryId", categoryId).bind("currentProductId", currentProductId).bind("limit", limit).mapToBean(Product.class).list());
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

    // phân trang và tìm kiếm sản phẩm
    public List<Product> getProductsPaging(int offset, int limit) {
        String sql = "SELECT p.*, pi.image_url as image " + "\n" +
                "FROM product p\n" +
                "LEFT JOIN productimage pi \n" +
                "    ON p.id = pi.product_id AND pi.is_primary = 1\n" +
                "WHERE p.status = 1\n" +
                "ORDER BY p.id DESC\n" +
                "LIMIT :limit OFFSET :offset";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("offset", offset).bind("limit", limit).mapToBean(Product.class).list());
    }

    public List<Product> searchProducts(int offset, int limit, String keyword) {
        String sql = "SELECT p.*, pi.image_url as image " + "\n" +
                "FROM product p\n" +
                "LEFT JOIN productimage pi \n" +
                "    ON p.id = pi.product_id AND pi.is_primary = 1\n" +
                "WHERE p.status = 1\n" +
                "AND p.name LIKE :keyword\n" +
                "ORDER BY p.id DESC\n" +
                "LIMIT :limit OFFSET :offset";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("keyword", "%" + keyword + "%").bind("offset", offset).bind("limit", limit).mapToBean(Product.class).list());
    }

    public List<Product> getProductsSort(int offset, int limit, String sort) {
        String orderBy = "p.id DESC";
        switch (sort) {
            case "price_asc":
                orderBy = "COALESCE(NULLIF(p.discount_price, 0), p.original_price) ASC";
                break;
            case "price_desc":
                orderBy = "COALESCE(NULLIF(p.discount_price, 0), p.original_price) DESC";
                break;
            case "name_asc":
                orderBy = "p.name ASC";
                break;
            case "name_desc":
                orderBy = "p.name DESC";
                break;
        }
        String sql = "SELECT p.*, pi.image_url as image " + "\n" +
                "FROM product p\n" +
                "LEFT JOIN productimage pi \n" +
                "ON p.id = pi.product_id AND pi.is_primary = 1\n" +
                "WHERE p.status = 1\n" +
                "ORDER BY " + orderBy + " \n" +
                "LIMIT :limit OFFSET :offset";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("offset", offset).bind("limit", limit).mapToBean(Product.class).list());
    }

    //đếm tổng sản phẩm
    public int countPrducts(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*) FROM product p
        WHERE p.status = 1
    """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword + "%");
        }

        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }

        final String finalSql = sql.toString();

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.mapTo(Integer.class).first();
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
    public List<Product> getProducts(int offset, int limit, String keyword, String sort, Integer categoryId) {
        StringBuilder sql = new StringBuilder("""
        SELECT p.*, pi.image_url as image
        FROM product p
        LEFT JOIN productimage pi 
            ON p.id = pi.product_id AND pi.is_primary = 1
        WHERE p.status = 1
    """);

        List<Object> params = new ArrayList<>();

        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword + "%");
        }

        String orderBy = "p.id DESC";
        if (sort != null && !sort.isEmpty() && !"default".equals(sort)) {
            switch (sort) {
                case "price_asc":
                    orderBy = "COALESCE(NULLIF(p.discount_price, 0), p.original_price) ASC";
                    break;
                case "price_desc":
                    orderBy = "COALESCE(NULLIF(p.discount_price, 0), p.original_price) DESC";
                    break;
                case "name_asc":
                    orderBy = "p.name ASC";
                    break;
                case "name_desc":
                    orderBy = "p.name DESC";
                    break;
            }
        }
        sql.append(" ORDER BY ").append(orderBy);
        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        final String finalSql = sql.toString();

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.mapToBean(Product.class).list();
        });
    }
    public List<Product> getFavoriteProducts(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return new ArrayList<>();
        }
        String placeholders = productIds.stream().map(String::valueOf).collect(Collectors.joining(","));
        String sql = "SELECT p.*, pi.image_url as image FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.id IN (" + placeholders + ") AND p.status = 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Product.class).list());
    }
}
