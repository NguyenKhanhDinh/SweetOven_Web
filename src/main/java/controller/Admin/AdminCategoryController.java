package controller.Admin;

import dao.CategoryDao;
import dao.ProductDao;
import model.Category;
import utils.UploadUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/categories")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class AdminCategoryController extends HttpServlet {

    private CategoryDao categoryDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        categoryDao = new CategoryDao();
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        switch (action) {
            case "add":
                addCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchKeyword = request.getParameter("search");
        if (searchKeyword == null) searchKeyword = "";

        List<Category> categories;
        if (!searchKeyword.trim().isEmpty()) {
            categories = categoryDao.searchByName(searchKeyword);
        } else {
            categories = categoryDao.findAll();
        }

        for (Category category : categories) {
            int productCount = categoryDao.countProducts(category.getId());
            category.setProductCount(productCount);
        }

        List<Category> allCategories = categoryDao.findAll();
        int totalCategories = allCategories.size();
        int activeCategories = (int) allCategories.stream()
                .filter(c -> c.getStatus() == 1).count();
        int inactiveCategories = totalCategories - activeCategories;
        int totalProducts = productDao.countAll();

        request.setAttribute("categories", categories);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("activeCategories", activeCategories);
        request.setAttribute("inactiveCategories", inactiveCategories);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("searchKeyword", searchKeyword);

        request.getRequestDispatcher("/adminPage/admin_categories.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String statusParam = request.getParameter("status");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=empty_name");
            return;
        }

        Category category = new Category();
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");
        category.setStatus(statusParam != null ? Integer.parseInt(statusParam) : 1);
        category.setCreatedAt(LocalDateTime.now());
        category.setUpdatedAt(LocalDateTime.now());

        Part filePart = request.getPart("thumbnail");
        String thumbnailPath = null;
        if (filePart != null && filePart.getSize() > 0) {
            thumbnailPath = UploadUtils.saveFile(filePart, request.getServletContext(), "categories");
            category.setThumbnail(thumbnailPath);
        }

        try {
            int generatedId = categoryDao.insert(category);
            if (generatedId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/categories?error=add_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=exception");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String statusParam = request.getParameter("status");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
            return;
        }

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=empty_name");
            return;
        }

        int id = Integer.parseInt(idParam);

        Category existingCategory = categoryDao.getCategoryById(id);
        if (existingCategory == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=not_found");
            return;
        }

        Category category = new Category();
        category.setId(id);
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");
        category.setStatus(statusParam != null ? Integer.parseInt(statusParam) : 1);
        category.setUpdatedAt(LocalDateTime.now());

        Part filePart = request.getPart("thumbnail");
        if (filePart != null && filePart.getSize() > 0) {
            if (existingCategory.getThumbnail() != null && !existingCategory.getThumbnail().isEmpty()) {
                UploadUtils.deleteFile(request.getServletContext(), existingCategory.getThumbnail());
            }
            String thumbnailPath = UploadUtils.saveFile(filePart, request.getServletContext(), "categories");
            category.setThumbnail(thumbnailPath);
        } else {
            category.setThumbnail(existingCategory.getThumbnail());
        }

        try {
            categoryDao.update(category);
            response.sendRedirect(request.getContextPath() + "/admin/categories?success=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=update_failed");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String forceParam = request.getParameter("force");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
            return;
        }

        int id = Integer.parseInt(idParam);

        Category category = categoryDao.getCategoryById(id);
        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=not_found");
            return;
        }

        boolean hasProducts = categoryDao.hasProducts(id);

        if (hasProducts && !"true".equals(forceParam)) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=has_products");
            return;
        }

        try {
            categoryDao.hardDelete(id);

            if (category.getThumbnail() != null && !category.getThumbnail().isEmpty()) {
                UploadUtils.deleteFile(request.getServletContext(), category.getThumbnail());
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=delete_failed");
        }
    }
}