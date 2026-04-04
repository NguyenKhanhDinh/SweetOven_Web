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
}
