package dao;

import model.Product;
import utils.JdbiConnector;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ProductDao {

    public List<Product> getFeaturedProducts() {
        String sql = "SELECT p.*, p.is_featured as featured, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.is_featured = 1 AND p.status = 1 AND p.is_deleted = 0 " +
                "ORDER BY RAND() " +
                "LIMIT 4";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getListProduct() {
        String sql = "SELECT p.*, p.is_featured as featured, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.is_deleted = 0 " +
                "ORDER BY p.id DESC";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public Product findById(int id) {
        String sql = "SELECT p.*, p.is_featured as featured, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.id = :id";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public List<Product> getRelatedProducts(int categoryId, int currentProductId, int limit) {
        String sql = "SELECT p.*, p.is_featured as featured, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.category_id = :categoryId " +
                "AND p.id != :currentProductId " +
                "AND p.status = 1 AND p.is_deleted = 0 " +
                "ORDER BY RAND() " +
                "LIMIT :limit";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .bind("currentProductId", currentProductId)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getProductsByCategory(int categoryId) {
        String sql = "SELECT p.*, p.is_featured as featured, pi.image_url as image " +
                "FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.status = 1 AND p.is_deleted = 0 AND p.category_id = :categoryId " +
                "ORDER BY p.id DESC";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void deleteById(int id) {
        String sql = "UPDATE product SET is_deleted = 1, status = 0, updated_at = NOW() WHERE id = :id";

        JdbiConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
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

    public List<String> getProductImages(int productId) {
        String sql = "SELECT image_url FROM productimage WHERE product_id = :productId";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapTo(String.class)
                        .list()
        );
    }

    public List<Product> getFavoriteProducts(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return new ArrayList<>();
        }

        String placeholders = productIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        String sql = "SELECT p.*, p.is_featured as featured, pi.image_url as image FROM product p " +
                "LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1 " +
                "WHERE p.id IN (" + placeholders + ") AND p.status = 1 AND p.is_deleted = 0";

        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void update(Product p) {
        String sql = "UPDATE product SET product_code = :productCode, category_id = :categoryId, " +
                "name = :name, original_price = :originalPrice, discount_price = :discountPrice, " +
                "stock_quantity = :stockQuantity, status = :status, description = :description, " +
                "ingredients = :ingredients, is_featured = :featured, updated_at = NOW() " +
                "WHERE id = :id";

        JdbiConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(p)
                        .execute()
        );
    }

    public void updateStatus(int productId, int status) {
        String sql = "UPDATE product SET status = :status, updated_at = NOW() WHERE id = :id";

        JdbiConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("id", productId)
                        .execute()
        );
    }

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
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );

        return (maxSeq != null ? maxSeq : 0) + 1;
    }

    public boolean isProductCodeExists(String productCode) {
        String sql = "SELECT COUNT(*) FROM product WHERE product_code = :productCode";

        int count = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productCode", productCode)
                        .mapTo(Integer.class)
                        .one()
        );

        return count > 0;
    }

    public List<Product> findAllWithFilters(String search, Integer categoryId, Integer status,
                                            Boolean featured, String sort, int page, int pageSize) {

        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder("""
            SELECT p.*, p.is_featured as featured, pi.image_url as image
            FROM product p
            LEFT JOIN productimage pi ON p.id = pi.product_id AND pi.is_primary = 1
            WHERE p.is_deleted = 0
        """);

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
            } else {
                sql.append(" AND (p.status = 0 OR p.stock_quantity = 0)");
            }
        }

        if (featured != null) {
            sql.append(" AND p.is_featured = ?");
            params.add(featured ? 1 : 0);
        }

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
            }
        }

        sql.append(" ORDER BY ").append(orderBy);
        sql.append(" LIMIT ? OFFSET ?");

        params.add(pageSize);
        params.add(offset);

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }

            return query.mapToBean(Product.class).list();
        });
    }

    public int countWithFilters(String search, Integer categoryId, Integer status, Boolean featured) {

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*)
            FROM product p
            WHERE p.is_deleted = 0
        """);

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
            } else {
                sql.append(" AND (p.status = 0 OR p.stock_quantity = 0)");
            }
        }

        if (featured != null) {
            sql.append(" AND p.is_featured = ?");
            params.add(featured ? 1 : 0);
        }

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM product WHERE is_deleted = 0";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int countAvailable() {
        String sql = "SELECT COUNT(*) FROM product WHERE status = 1 AND stock_quantity > 0 AND is_deleted = 0";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int countOutOfStock() {
        String sql = "SELECT COUNT(*) FROM product WHERE (status = 0 OR stock_quantity = 0) AND is_deleted = 0";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int countFeatured() {
        String sql = "SELECT COUNT(*) FROM product WHERE is_featured = 1 AND is_deleted = 0";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }
    public void restoreById(int id) {
        String sql = "UPDATE product SET is_deleted = 0, updated_at = NOW() WHERE id = :id";

        JdbiConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }
}