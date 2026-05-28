package controller;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import model.*;
import service.*;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "HomepageController", value = {"/home",""})
    public class HomepageController extends HttpServlet {
    private ProductService productService;
    private BannerService bannerService;
    private DiscountService discountService;
    private CategoryService categoryService;
    private FeedBackService feedBackService;
    public void init() {
        this.productService = new ProductService();
        this.bannerService = new BannerService();
        this.discountService = new DiscountService();
        this.feedBackService = new FeedBackService();
        this.categoryService = new CategoryService();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //for featured products
        List<Product> feturedProducts = productService.getFeaturedProducts();
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
        // Only get POSITIVE feedbacks for homepage - no AI call here!
        List<FeedBack> positiveFeedbacks = feedBackService.getPositiveFeedbacksForHomepage();
        request.setAttribute("feedbacks", positiveFeedbacks);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

}
