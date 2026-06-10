package controller;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;


@WebServlet(name = "HomepageController", value = {"/home",""})
    public class HomepageController extends HttpServlet {
    private ProductService productService;
    private BannerService bannerService;
    private DiscountService discountService;
    private CategoryService categoryService;
    private UserDiscountService userDiscountService;
    private UserFavoriteService userFavoriteService;
    public void init() {
        this.productService = new ProductService();
        this.bannerService = new BannerService();
        this.discountService = new DiscountService();
        this.categoryService = new CategoryService();
        this.userDiscountService = new UserDiscountService();
        this.userFavoriteService = new UserFavoriteService();
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

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            try {
                List<Integer> savedDiscountIds = userDiscountService.getSavedDiscountIds(user.getId());
                request.setAttribute("savedDiscountIds", savedDiscountIds);

                List<Integer> usedDiscountIds = userDiscountService.getUsedDiscountIds(user.getId());
                if (!usedDiscountIds.isEmpty()) {
                    discounts = discounts.stream().filter(d -> !usedDiscountIds.contains(d.getId())).collect(java.util.stream.Collectors.toList());
                    request.setAttribute("discounts", discounts);
                }
                List<Integer> favoriteProductIds = userFavoriteService.getFavoriteProductIds(user.getId());
                request.setAttribute("favoriteProductIds", favoriteProductIds);
            }catch (Exception e){
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

}
