package service;

import dao.CategoryDao;
import model.Category;

import java.util.List;

public class CategoryService {
    private CategoryDao categoryDao = new CategoryDao();

    public List<Category> getAllCategories() {
        return categoryDao.getAllCategories();
    }
}
