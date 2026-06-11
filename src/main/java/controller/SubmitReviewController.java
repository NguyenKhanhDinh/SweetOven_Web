package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProductReview;
import model.User;
import service.ProductReviewService;

import java.io.IOException;

@WebServlet("/submit-review")
public class SubmitReviewController extends HttpServlet {

    private final ProductReviewService productReviewService = new ProductReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String productIdParam = request.getParameter("productId");
        String orderIdParam = request.getParameter("orderId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");

        String redirectBase = request.getContextPath() + "/product?id=" + productIdParam;

        if(user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int productId,orderId,rating;
        try {
            productId = Integer.parseInt(productIdParam);
            orderId = Integer.parseInt(orderIdParam);
            rating = Integer.parseInt(ratingParam);
        }catch(NumberFormatException e) {
            response.sendRedirect(redirectBase + "&reviewMsg=error");
            return;
        }
        ProductReview review = new ProductReview();
        review.setProductId(productId);
        review.setOrderId(orderId);
        review.setUserId(user.getId());
        review.setRating(rating);
        review.setComment(comment != null ? comment.trim() : "");

        String result = productReviewService.submitReview(review);

        switch (result) {
            case "SUCCESS" -> response.sendRedirect(redirectBase + "&reviewMsg=success#pd-comment" + productId);
            case "ALREADY_REVIEWED" -> response.sendRedirect(redirectBase + "&reviewMsg=already#pd-comment" + productId);
            default -> response.sendRedirect(redirectBase + "&reviewMsg=error#pd-comment");
        }

    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}

}
