package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/search-suggestions")
public class SearchController extends HttpServlet {
    ProductService productService;
    public void init() {
        productService = new ProductService();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control","no-cache");
        String keyword = request.getParameter("keyword");
        if(keyword==null || keyword.trim().length()<2){
            response.getWriter().write("[]");
            return;
        }
        List<Product> products = productService.findAllWithFilters(keyword.trim(),null,null,null,null,1,8);
        Gson gson = new Gson();
        List<Map<String,Object>> result = products.stream().map(p -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", p.getId());
            item.put("name", p.getName());
            item.put("image", p.getImage()!=null? p.getImage() : "");
            item.put("price",p.getDisplayPrice());
            item.put("originalPrice",p.getOriginalPrice());
            item.put("discountPrice",p.getDiscountPrice());
            return item;
        }).collect(Collectors.toList());
        response.getWriter().write(gson.toJson(result));
    }
}
