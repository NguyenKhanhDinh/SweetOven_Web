package controller;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import model.Banner;
import model.Product;
import service.ProductService;
import service.BannerService;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "HomepageController", value = {"/home",""})
    public class HomepageController extends HttpServlet {
    private ProductService productService;
    private BannerService bannerService;
    public void init() {
        this.productService = new ProductService();
        this.bannerService = new BannerService();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> feturedProducts = productService.getFeaturedProducts();
        request.setAttribute("featuredProducts", feturedProducts);
        List<Banner> banners = bannerService.getAllBanners();
        request.setAttribute("banners", banners);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

}
