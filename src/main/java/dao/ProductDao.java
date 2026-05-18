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
    public void deleteById(int id) {
        String sql = "DELETE FROM product WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql).bind("id", id).execute()
        );
    }

    public int addProduct(Product p) {
        String sql = "INSERT INTO product (product_code, category_id, name, original_price, discount_price, " +
                "stock_quantity, status, description, ingredients, is_featured, created_at, updated_at) " +
                "VALUES (:productCode, :categoryId, :name, :originalPrice, :discountPrice, " +
                ":stockQuantity, :status, :description, :ingredients, :featured, NOW(), NOW())";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(p)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
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


    /**
     * Lấy tất cả sản phẩm  - dùng cho admin
     */
    public List<Product> findAll() {
        String sql = "SELECT p.*, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "ORDER BY p.id DESC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapToBean(Product.class).list()
        );
    }

    /**
     * Lấy sản phẩm phân trang - dùng cho admin
     */
    public List<Product> findAll(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT p.*, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "ORDER BY p.id DESC " +
                "LIMIT :limit OFFSET :offset";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", pageSize)
                        .bind("offset", offset)
                        .mapToBean(Product.class).list()
        );
    }

    /**
     * Đếm tổng số sản phẩm (admin)
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM product";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    /**
     * Tìm kiếm sản phẩm theo tên- admin
     */
    public List<Product> searchByName(String keyword, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT p.*, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.name LIKE :keyword " +
                "ORDER BY p.id DESC " +
                "LIMIT :limit OFFSET :offset";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .bind("limit", pageSize)
                        .bind("offset", offset)
                        .mapToBean(Product.class).list()
        );
    }

    /**
     * Đếm số lượng sản phẩm tìm kiếm theo tên
     */
    public int countSearch(String keyword) {
        String sql = "SELECT COUNT(*) FROM product WHERE name LIKE :keyword";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .mapTo(Integer.class).one()
        );
    }

    /**
     * Cập nhật sản phẩm
     */
    public void update(Product p) {
        String sql = "UPDATE product SET product_code = :productCode, category_id = :categoryId, " +
                "name = :name, original_price = :originalPrice, discount_price = :discountPrice, " +
                "stock_quantity = :stockQuantity, status = :status, description = :description, " +
                "ingredients = :ingredients, is_featured = :isFeatured, updated_at = :updatedAt " +
                "WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(p)
                        .execute()
        );
    }

    /**
     * Cập nhật ảnh đại diện cho sản phẩm
     */
    public void updateImage(int productId, String imageUrl) {
        String sql = "UPDATE product SET image = :imageUrl WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("imageUrl", imageUrl)
                        .bind("id", productId)
                        .execute()
        );
    }

    /**
     * Cập nhật trạng thái sản phẩm
     */
    public void updateStatus(int productId, int status) {
        String sql = "UPDATE product SET status = :status, updated_at = NOW() WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("id", productId)
                        .execute()
        );
    }

    /**
     * Lấy sản phẩm theo ID
     */
    public Product getById(int id) {
        String sql = "SELECT * FROM product WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id", id).mapToBean(Product.class).findOne().orElse(null));
    }

    /**
     * Lấy số thứ tự lớn nhất theo prefix
     */
    public int getMaxSequenceByPrefix(String prefix) {
        String sql = "SELECT MAX(CAST(SUBSTRING(product_code, LENGTH(:prefix) + 2) AS UNSIGNED)) " +
                "FROM product WHERE product_code LIKE CONCAT(:prefix, '-%')";
        Integer maxSeq = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("prefix", prefix)
                        .mapTo(Integer.class)
                        .one()
        );
        return maxSeq != null ? maxSeq : 0;
    }
    public int getNextProductSequence() {
        String sql = "SELECT MAX(CAST(SUBSTRING(product_code, 3) AS UNSIGNED)) FROM product";
        Integer maxSeq = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
        return (maxSeq != null ? maxSeq : 0) + 1;
    }
    public boolean isProductCodeExists(String productCode) {
        String sql = "SELECT COUNT(*) FROM product WHERE product_code = :productCode";
        int count = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).bind("productCode", productCode).mapTo(Integer.class).one()
        );
        return count > 0;
    }

    public List<Product> findAllWithFilters(String search, Integer categoryId, Integer status,
                                            Boolean featured, String sort, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("""
            SELECT p.*, pi.image_url as image
            FROM product p
            LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        // Tìm kiếm theo tên hoặc mã sản phẩm
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.product_code LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        // Lọc theo danh mục
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }

        // Lọc theo trạng thái (còn hàng/hết hàng)
        if (status != null) {
            if (status == 1) {
                sql.append(" AND p.status = 1 AND p.stock_quantity > 0");
            } else if (status == 0) {
                sql.append(" AND (p.status = 0 OR p.stock_quantity = 0)");
            }
        }

        // Lọc theo nổi bật
        if (featured != null) {
            sql.append(" AND p.is_featured = ?");
            params.add(featured ? 1 : 0);
        }

        // Sắp xếp
        String orderBy = "p.id DESC";
        if (sort != null && !sort.isEmpty()) {
            switch (sort) {
                case "stock_asc":
                    orderBy = "p.stock_quantity ASC";
                    break;
                case "stock_desc":
                    orderBy = "p.stock_quantity DESC";
                    break;
                case "price_asc":
                    orderBy = "CASE WHEN p.discount_price IS NOT NULL AND p.discount_price > 0 THEN p.discount_price ELSE p.original_price END ASC";
                    break;
                case "price_desc":
                    orderBy = "CASE WHEN p.discount_price IS NOT NULL AND p.discount_price > 0 THEN p.discount_price ELSE p.original_price END DESC";
                    break;
                case "name_asc":
                    orderBy = "p.name ASC";
                    break;
                case "name_desc":
                    orderBy = "p.name DESC";
                    break;
                default:
                    orderBy = "p.id DESC";
            }
        }
        sql.append(" ORDER BY ").append(orderBy);
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
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


    /**
     * Đếm số lượng sản phẩm với bộ lọc
     */
    public int countWithFilters(String search, Integer categoryId, Integer status, Boolean featured) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM product p WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.product_code LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        if (status != null) {
            if (status == 1) {
                sql.append(" AND p.status = 1 AND p.stock_quantity > 0");
            } else if (status == 0) {
                sql.append(" AND (p.status = 0 OR p.stock_quantity = 0)");
            }
        }
        if (featured != null) {
            sql.append(" AND p.is_featured = ?");
            params.add(featured ? 1 : 0);
        }

        final String finalSql = sql.toString();
        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.mapTo(Integer.class).one();
        });
    }
}
