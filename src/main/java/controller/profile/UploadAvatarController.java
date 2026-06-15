package controller.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import service.UserService;

import java.io.IOException;


@WebServlet("/upload-avatar")
@MultipartConfig
public class UploadAvatarController extends HttpServlet {

    UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        Part filePart = request.getPart("avatar");

        if (filePart == null || filePart.getSize() == 0) {
            session.setAttribute("errorMsg", "Vui lòng chọn ảnh!");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        String contentType = filePart.getContentType();
        String extension;

        switch (contentType) {
            case "image/png":
                extension = ".png";
                break;
            case "image/jpeg":
                extension = ".jpg";
                break;
            default:
                session.setAttribute("errorMsg", "Chỉ chấp nhận PNG hoặc JPG!");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
        }
        String dbPath = utils.CloudinaryUtil.uploadImage(filePart);

        if(dbPath != null && !dbPath.isEmpty()){
            boolean updated = userService.updateAvatar(user.getId(), dbPath);
            if(updated){
                user.setAvatar(dbPath);
                session.setAttribute("user", user);
                session.setAttribute("successMsg", "Cập nhật avatar thành công!");
            }else{
                session.setAttribute("errorMsg", "Lỗi khi lưu avatar vào database!");
            }
        }else{
            session.setAttribute("errorMsg", "Lỗi mạng khi tải ảnh!");
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}