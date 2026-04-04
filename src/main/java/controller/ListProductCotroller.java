package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;
import service.CategoryService;
import service.ProductService;

import java.io.IOException;
import java.util.List;


@WebServlet("/menu")
public class ListProductCotroller extends HttpServlet {
    private ProductService productService = new ProductService();
    private CategoryService categoryService = new CategoryService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        String categoryIdParam = request.getParameter("categoryId");

        int page = (pageParam == null) ? 1 : Integer.parseInt(pageParam);
        int limit = 30;
        int offset = (page - 1) * limit;

        if(keyword == null) keyword = "";
        if(sort == null) sort = "";
        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            categoryId = Integer.parseInt(categoryIdParam);
        }
        Category currentCategory = null;
        if (categoryId != null) {
            currentCategory = categoryService.getCategoryById(categoryId);
        }
        List<Product> list = productService.getProducts(offset, limit, keyword, sort, categoryId);

        int total = productService.countProducts(keyword,categoryId);
        int totalPages = (int) Math.ceil((double) total / limit);

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("products", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);
        request.setAttribute("categoryList", categories);
        request.setAttribute("currentCategory", currentCategory);

        request.getRequestDispatcher("/WEB-INF/menu.jsp").forward(request, response);

    }


}
