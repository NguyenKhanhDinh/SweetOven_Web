package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserService;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    UserService userService = new UserService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if(user == null) {
            response.sendRedirect("login");
            return;
        }
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

       UserService.ChangePasswordResult result =userService.changePassword(user.getId(),oldPassword,newPassword,confirmPassword);

       switch (result){
           case SUCCESS:
               session.setAttribute("successMsg","Đổi mật khẩu thành công!");
               break;
           case WRONG_OLD_PASSWORD:
               session.setAttribute("errorMsg","Mật khẩu cũ không đúng!");
               break;
           case CONFIRM_NOT_MATCH:
               session.setAttribute("error","Xác nhận mật khẩu không khớp!");
               break;
           case WEAK_NEW_PASSWORD:
               session.setAttribute("errorMsg","Mật mới phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
               break;
           default:
               session.setAttribute("errorMsg","Có lỗi xảy ra, vui lòng thử lại!");
       }
       response.sendRedirect("profile");
    }
}
