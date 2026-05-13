package dao;

import model.Category;
import utils.JdbiConnector;

import java.util.List;

public class CategoryDao {
    public List<Category> getAllCategories(){
    String sql =" SELECT c.*, COUNT(p.id) as product_count " +
            "FROM Category c " +
            "LEFT JOIN Product p ON c.id = p.category_id " +
            "WHERE c.status = 1 " +
            "GROUP BY c.id " +
            "ORDER BY c.id ASC";
    return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Category.class).list());
    }
    public Category getCategoryById(int categoryId){
        String sql = "SELECT * FROM category WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id",categoryId).mapToBean(Category.class).findOne().orElse(null));
    }

    public List<Category> findAll() {
        String sql = "SELECT * FROM category ORDER BY id ASC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapToBean(Category.class).list()
        );
    }


    public List<Category> findActive() {
        String sql = "SELECT * FROM category WHERE status = 1 ORDER BY id ASC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapToBean(Category.class).list()
        );
    }

    /**
     * Thêm danh mục mới
     */
    public int insert(Category category) {
        String sql = "INSERT INTO category (name, description, thumbnail, status, created_at, updated_at) " +
                "VALUES (:name, :description, :thumbnail, :status, NOW(), NOW())";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(category)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }


    /**
     * Cập nhật danh mục
     */
    public void update(Category category) {
        String sql = "UPDATE category SET name = :name, description = :description, " +
                "thumbnail = :thumbnail, status = :status, updated_at = NOW() WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(category)
                        .execute()
        );
    }


    public void softDelete(int id) {
        String sql = "UPDATE category SET status = 0, updated_at = NOW() WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }

    /**
     * Xóa cứng danh mục
     */
    public void hardDelete(int id) {
        String sql = "DELETE FROM category WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }

    /**
     * Kiểm tra danh mục có sản phẩm nào không
     */
    public boolean hasProducts(int categoryId) {
        String sql = "SELECT COUNT(*) FROM product WHERE category_id = :categoryId";
        int count = JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .mapTo(Integer.class)
                        .one()
        );
        return count > 0;
    }

    /**
     * Đếm số sản phẩm theo danh mục
     */
    public int countProducts(int categoryId) {
        String sql = "SELECT COUNT(*) FROM product WHERE category_id = :categoryId";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    /**
     * Tìm kiếm danh mục theo tên
     */
    public List<Category> searchByName(String keyword) {
        String sql = "SELECT * FROM category WHERE name LIKE :keyword ORDER BY id ASC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .mapToBean(Category.class)
                        .list()
        );
    }

    /**
     * Cập nhật trạng thái danh mục
     */
    public void updateStatus(int id, int status) {
        String sql = "UPDATE category SET status = :status, updated_at = NOW() WHERE id = :id";
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("id", id)
                        .execute()
        );
    }


}
