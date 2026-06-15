package controller.product;


import dao.ProductDao;
import dao.ProductImageDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.ProductImage;
import model.User;
import service.ProductReviewService;
import service.UserFavoriteService;

import java.io.IOException;
import java.util.List;

@WebServlet("/product")
public class ProductController extends HttpServlet {

    private static final int TOP_REVIEWS_LIMIT = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        ProductDao productDao = new ProductDao();
        ProductImageDao imageDao = new ProductImageDao();
        ProductReviewService productReviewService = new ProductReviewService();

        // 1. Sản phẩm đang xem
        Product product = productDao.findById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        List<ProductImage> imageList = imageDao.getProductImages(productId);
        product.setListImages(imageList);

        List<Product> relatedProducts = productDao.getRelatedProducts(product.getCategoryId(), productId, 8);
        for (Product rp : relatedProducts) {
            List<ProductImage> rpImages = imageDao.getProductImages(rp.getId());
            rp.setListImages(rpImages);
        }
        int totalReviews = productReviewService.getTotalReviews(productId);
        double averageRatings = productReviewService.getAverageRatings(productId);

        String orderIdParam = request.getParameter("orderId");
        boolean showReviewForm = false;
        int reviewOrderId = 0;
        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                reviewOrderId = Integer.parseInt(orderIdParam);
                showReviewForm = true;
            }catch (NumberFormatException ignored) {}
        }


        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if(user != null){
            try{
                UserFavoriteService favoriteService = new UserFavoriteService();
                List<Integer> favoiteProductIds = favoriteService.getFavoriteProductIds(user.getId());
                request.setAttribute("favoriteProductIds", favoiteProductIds);
            }catch (Exception e){
                e.printStackTrace();
            }
        }

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("topReviews", productReviewService.getTopReviews(productId, TOP_REVIEWS_LIMIT));
        request.setAttribute("allReviews", productReviewService.getAllReviews(productId));
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("averageRatings", averageRatings);
        request.setAttribute("showReviewForm", showReviewForm);
        request.setAttribute("reviewOrderId", reviewOrderId);


        request.getRequestDispatcher("/WEB-INF/product_detail.jsp").forward(request, response);
    }
}
