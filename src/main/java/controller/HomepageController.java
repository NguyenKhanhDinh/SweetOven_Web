package controller;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import model.Banner;
import model.Category;
import model.Discount;
import model.Product;
import service.CategoryService;
import service.DiscountService;
import service.ProductService;
import service.BannerService;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "HomepageController", value = {"/home",""})
    public class HomepageController extends HttpServlet {
    private ProductService productService;
    private BannerService bannerService;
    private DiscountService discountService;
    private CategoryService categoryService;
    public void init() {
        this.productService = new ProductService();
        this.bannerService = new BannerService();
        this.discountService = new DiscountService();
        this.categoryService = new CategoryService();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //for featured products
        List<Product> feturedProducts = productService.getFeaturedProductsWithDiscount();
        request.setAttribute("featuredProducts", feturedProducts);
        //banners
        List<Banner> banners = bannerService.getAllBanners();
        request.setAttribute("banners", banners);
        //discounts
        List<Discount> discounts = discountService.getAllDiscounts();
        request.setAttribute("discounts",discounts) ;
        //categories
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

}
