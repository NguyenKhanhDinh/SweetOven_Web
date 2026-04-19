package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.FeedBack;
import service.FeedBackService;

import java.io.IOException;

@WebServlet("/contact")
public class ContactController extends HttpServlet {
    private FeedBackService feedBackService = new FeedBackService();
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.getRequestDispatcher("/WEB-INF/contact.jsp").forward(request, response);
}
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phoneNumber");
    String content = request.getParameter("content");

    FeedBack feedBack = new FeedBack();
    feedBack.setFullName(fullName);
    feedBack.setEmail(email);
    feedBack.setPhoneNumber(phone);
    feedBack.setContent(content);

    String message = feedBackService.insertFeedBack(feedBack);
    if ("SUCCESS".equals(message)) {
        request.getSession().setAttribute("succesMsg","Gửi thành công!");
    }else{
        request.getSession().setAttribute("errorMsg",message);
    }
    response.sendRedirect(request.getContextPath()+"/contact");
}
}
