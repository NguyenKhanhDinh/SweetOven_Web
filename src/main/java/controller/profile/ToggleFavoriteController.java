package controller.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.UserFavoriteService;

import java.io.IOException;
@WebServlet("/toggle-favorite")
public class ToggleFavoriteController extends HttpServlet{
	private static final UserFavoriteService userFavoriteService = new UserFavoriteService();
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");

        if(user==null){
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"unauthenticated\"}");
            return;
        }
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int userId = user.getId();

            boolean alreadyFavorite = userFavoriteService.isFavorite(productId, userId);
            boolean isFavoriteNow;
            if(alreadyFavorite){
                userFavoriteService.removeFavorites(productId, userId);
                isFavoriteNow = false;
            }else {
                userFavoriteService.addFavorite(productId, userId);
                isFavoriteNow = true;
            }
            response.getWriter().write("{\"status\":\"ok\",\"isFavorite\":" + isFavoriteNow +"}");
        }catch (NumberFormatException e){
           response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
           response.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid productId\"}");
        }
    }
}
