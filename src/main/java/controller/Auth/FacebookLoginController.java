package controller.Auth;

import dao.CartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.User;
import service.UserService;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@WebServlet ("/login-facebook")
public class FacebookLoginController extends HttpServlet {
    private static final String APP_ID = "1035438258942657";
    private static final String APP_SECRET = "9400725d9425467985788a3ff2dfe8f4";
    private static final String REDIRECT_URL = "https://app.sweetoven.id.vn/login-facebook";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        if(code == null ){
            if(error != null){
                response.sendRedirect(request.getContextPath()+"/authPage/login.jsp?error=FacebookDenied");
                return;
            }
            String fbUrl = "https://www.facebook.com/v18.0/dialog/oauth"
                    + "?client_id=" + APP_ID
                    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URL, "UTF-8")
                    + "&scope=public_profile"
                    + "&response_type=code";
            response.sendRedirect(fbUrl);
            return;
        }
        try {
            String tonkenUrl = "https://graph.facebook.com/v18.0/oauth/access_token"
                    + "?client_id=" + APP_ID
                    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URL, "UTF-8")
                    + "&client_secret=" + APP_SECRET
                    + "&code=" + code;
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest tokenReq = HttpRequest.newBuilder().uri(URI.create(tonkenUrl)).GET().build();
            HttpResponse<String> tokenRes = client.send(tokenReq, HttpResponse.BodyHandlers.ofString());
            String accessToken = tokenRes.body().split("\"access_token\":\"")[1].split("\"")[0];
            String userInfoUrl = "https://graph.facebook.com/me?fields=id,name,email&access_token=" + accessToken;
            HttpRequest userReq = HttpRequest.newBuilder().uri(URI.create(userInfoUrl)).GET().build();
            HttpResponse<String> userRes = client.send(userReq,HttpResponse.BodyHandlers.ofString());
            String userJson = userRes.body();
            String facebookId = userJson.split("\"id\":\"")[1].split("\"")[0];
            String fullName = userJson.split("\"name\":\"")[1].split("\"")[0];
            UserService userService = new UserService();
            User user = userService.findOrFacebookUser(facebookId, fullName);
            if(user == null || user.isBlocked() || user.getStatus() != 1){
                response.sendRedirect(request.getContextPath() + "/authPage/login.jsp?error=AccountBlocked");
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            CartDao cartDao = new CartDao();
            Cart sessionCart = (Cart) session.getAttribute("cart");
            if(sessionCart == null){
                sessionCart = new Cart();
            }
            Cart merged = cartDao.mergeDBCartIntoSession(user.getId(), sessionCart);
            cartDao.saveCartToDB(user.getId(), merged);
            session.setAttribute("cart", merged);

            if (user.getRoleId()==1){
                response.sendRedirect(request.getContextPath()+"/admin/dashboard");
            }else{
                response.sendRedirect(request.getContextPath()+"/");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()+"/authPage/login.jsp?error=FacebookError");
        }
    }
}
