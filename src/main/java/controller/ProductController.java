package controller;


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
import service.UserFavoriteService;

import java.io.IOException;
import java.util.List;

@WebServlet("/product")
public class ProductController extends HttpServlet {

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

        request.setAttribute("product", product);
        request.setAttribute("relatedProducts", relatedProducts);

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

        request.getRequestDispatcher("/WEB-INF/product_detail.jsp").forward(request, response);
    }
}
