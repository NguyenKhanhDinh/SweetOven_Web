package controller.Admin;

import jakarta.servlet.http.*;
import model.User;
import service.CategoryService;
import service.ProductService;
import model.Category;
import utils.CloudinaryUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/categories")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 5,       // 5MB
        maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class AdminCategoryController extends HttpServlet {

    private CategoryService categoryService;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        categoryService = new CategoryService();
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User adminUser = (User) session.getAttribute("user");
        if (adminUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User adminUser = (User) session.getAttribute("user");
        if (adminUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

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

        List<Category> categories = categoryService.searchCategoriesByName(searchKeyword);

        for (Category category : categories) {
            int productCount = categoryService.countProductsInCategory(category.getId());
            category.setProductCount(productCount);
        }
        int totalCategories = categoryService.countTotalCategories();
        int activeCategories = categoryService.countActiveCategories();
        int inactiveCategories = categoryService.countInactiveCategories();
        int totalProducts = productService.countAllProducts();

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
        if (filePart != null && filePart.getSize() > 0) {
            String cloudinaryUrl = CloudinaryUtil.uploadImage(filePart);
            if (cloudinaryUrl != null) {
                category.setThumbnail(cloudinaryUrl);
            }
        }
        try {
            int generatedId = categoryService.addCategory(category);
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

        // Validate input
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
            return;
        }

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=empty_name");
            return;
        }

        int id = Integer.parseInt(idParam);

        // Lấy category cũ qua service
        Category existingCategory = categoryService.getCategoryById(id);
        if (existingCategory == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=not_found");
            return;
        }

        // Tạo đối tượng category mới
        Category category = new Category();
        category.setId(id);
        category.setName(name.trim());
        category.setDescription(description != null ? description.trim() : "");
        category.setStatus(statusParam != null ? Integer.parseInt(statusParam) : 1);
        category.setCreatedAt(existingCategory.getCreatedAt()); // Giữ nguyên ngày tạo gốc
        category.setUpdatedAt(LocalDateTime.now());

        Part filePart = request.getPart("thumbnail");
        if (filePart != null && filePart.getSize() > 0) {
            String cloudinaryUrl = CloudinaryUtil.uploadImage(filePart);
            if (cloudinaryUrl != null) {
                category.setThumbnail(cloudinaryUrl);
            } else {
                category.setThumbnail(existingCategory.getThumbnail());
            }
        } else {
            category.setThumbnail(existingCategory.getThumbnail());
        }

        try {
            boolean updated = categoryService.updateCategory(category);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/categories?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=update_failed");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
            return;
        }

        int id = Integer.parseInt(idParam);

        Category category = categoryService.getCategoryById(id);
        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=not_found");
            return;
        }

        try {
            boolean deleted = categoryService.softDeleteCategory(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/categories?error=delete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/categories?error=delete_failed");
        }
    }
}