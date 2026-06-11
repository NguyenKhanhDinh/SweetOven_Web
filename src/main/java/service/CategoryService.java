package service;

import dao.CategoryDao;
import model.Category;
import java.util.List;

public class CategoryService {
    private CategoryDao categoryDao = new CategoryDao();

    // Lấy tất cả danh mục
    public List<Category> getAllCategories() {
        return categoryDao.getAllCategories();
    }

    // Lấy danh mục theo ID
    public Category getCategoryById(int id) {
        return categoryDao.getCategoryById(id);
    }

    // Lấy tất cả danh mục
    public List<Category> findAllCategories() {
        return categoryDao.findAll();
    }

    // Lấy danh mục active
    public List<Category> findActiveCategories() {
        return categoryDao.findActive();
    }

    // Tìm kiếm danh mục theo tên
    public List<Category> searchCategoriesByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return categoryDao.findAll();
        }
        return categoryDao.searchByName(keyword);
    }

    // Thêm danh mục mới
    public int addCategory(Category category) {
        return categoryDao.insert(category);
    }

    // Cập nhật danh mục
    public boolean updateCategory(Category category) {
        try {
            categoryDao.update(category);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean softDeleteCategory(int id) {
        try {
            categoryDao.softDelete(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hardDeleteCategory(int id) {
        try {
            categoryDao.hardDelete(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm số sản phẩm trong danh mục
    public int countProductsInCategory(int categoryId) {
        return categoryDao.countProducts(categoryId);
    }

    // Kiểm tra danh mục có sản phẩm không
    public boolean hasProducts(int categoryId) {
        return categoryDao.hasProducts(categoryId);
    }

    // Cập nhật trạng thái danh mục
    public boolean updateCategoryStatus(int id, int status) {
        try {
            categoryDao.updateStatus(id, status);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Đếm tổng số danh mục
    public int countTotalCategories() {
        return categoryDao.findAll().size();
    }

    // Đếm số danh mục active
    public int countActiveCategories() {
        return (int) categoryDao.findAll().stream()
                .filter(c -> c.getStatus() == 1)
                .count();
    }

    // Đếm số danh mục inactive
    public int countInactiveCategories() {
        return (int) categoryDao.findAll().stream()
                .filter(c -> c.getStatus() == 0)
                .count();
    }
}