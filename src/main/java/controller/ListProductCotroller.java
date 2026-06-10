package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.Product;
import model.User;
import service.CategoryService;
import service.ProductService;
import service.UserFavoriteService;

import java.io.IOException;
import java.util.List;

@WebServlet("/menu")
public class ListProductCotroller extends HttpServlet {

    private ProductService productService = new ProductService();
    private CategoryService categoryService = new CategoryService();
    private UserFavoriteService userFavoriteService = new UserFavoriteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        String categoryIdParam = request.getParameter("categoryId");

        int page = (pageParam == null || pageParam.isEmpty())
                ? 1
                : Integer.parseInt(pageParam);

        int pageSize = 30;

        if (keyword == null || keyword.trim().isEmpty()) {
            keyword = "";
        }

        if (sort == null || sort.trim().isEmpty() || "default".equals(sort)) {
            sort = "";
        }

        Integer categoryId = null;

        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            categoryId = Integer.parseInt(categoryIdParam);
        }

        Category currentCategory = null;

        if (categoryId != null) {
            currentCategory = categoryService.getCategoryById(categoryId);
        }

        List<Product> list = productService.findAllWithFilters(
                keyword,
                categoryId,
                1,
                null,
                sort,
                page,
                pageSize
        );
        System.out.println("SIZE = " + list.size());

        int total = productService.countWithFilters(
                keyword,
                categoryId,
                1,
                null
        );

        int totalPages = (int) Math.ceil((double) total / pageSize);

        List<Category> categories = categoryService.getAllCategories();

        request.setAttribute("products", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);
        request.setAttribute("categoryList", categories);
        request.setAttribute("currentCategory", currentCategory);

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            try {
                List<Integer> favoriteProductIds = userFavoriteService.getFavoriteProductIds(user.getId());
                request.setAttribute("favoriteProductIds", favoriteProductIds);
            }catch (Exception e){
                e.printStackTrace();
            }
        }


        request.getRequestDispatcher("/WEB-INF/menu.jsp")
                .forward(request, response);
    }
}