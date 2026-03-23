package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import service.ProductService;

import java.io.IOException;

import java.util.List;


@WebServlet("/menu")
public class ListProductCotroller extends HttpServlet {
    private ProductService productService = new ProductService();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        int page = (pageParam == null) ? 1 : Integer.parseInt(pageParam);
        int limit = 30;
        int offset = (page - 1) * limit;

        if(keyword == null) keyword = "";
        if(sort == null) sort = "";

        List<Product> list;
        if (!keyword.isEmpty()) {
            list = productService.searchProducts(offset, limit, keyword);
        } else if (!sort.isEmpty()) {
            list = productService.getProductsSort(offset, limit, sort);
        } else {
            list = productService.getProductsPaging(offset, limit);
        }
        int total = productService.countProducts(keyword,null);
        int totalPages = (int) Math.ceil((double) total / limit);
        request.setAttribute("products", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/WEB-INF/menu.jsp").forward(request, response);

    }


}
