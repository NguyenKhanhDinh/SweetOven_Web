package controller.Auth;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import service.UserService;

import java.io.IOException;
import java.util.Collections;

@WebServlet("/login-google")
public class LoginGoogleController extends HttpServlet {

    private static final String CLIENT_ID = "1087592609374-l4pgsgu9aofrh2jgo365ebesk6evmeer.apps.googleusercontent.com";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idTokenString = request.getParameter("credential");
        if (idTokenString == null || idTokenString.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=NoToken");
            return;
        }
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                .setAudience(Collections.singletonList(CLIENT_ID))
                .build();

        try {
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=InvalidToken");
                return;
            }
            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String fullName = (String) payload.get("name");
            UserService userService = new UserService();
            User user = userService.findOrCreateGoogleUser(email, fullName);
            if (user == null||user.isBlocked()||user.getStatus()!=1) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=AccountBlocked");
                return;
            }
            request.getSession().setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/");

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=ServerError");
        }
    }
}