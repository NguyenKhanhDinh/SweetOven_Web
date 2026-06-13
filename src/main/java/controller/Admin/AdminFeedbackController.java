package controller.Admin;

import com.google.gson.Gson;
import model.FeedBack;
import service.FeedBackService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/feedback")
public class AdminFeedbackController extends HttpServlet {

    private final FeedBackService feedBackService;
    private final Gson gson;

    private static final int DEFAULT_PAGE_SIZE = 10;

    public AdminFeedbackController() {
        this.feedBackService = new FeedBackService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            //  Hiển thị danh sách
            showFeedbackList(request, response);
        }else {
            switch (action) {
                // TÍNH NĂNG 2: Lấy chi tiết feedback (AJAX)
                case "get-detail":
                    getFeedbackDetail(request, response);
                    break;
                case "delete":
                    deleteFeedback(request, response);
                    break;
                case "mark-opened":
                    markAsOpenedAndRedirectToGmail(request, response);
                    break;
                case "confirm-replied":
                    confirmReplied(request, response);
                    break;
                default:
                    showFeedbackList(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showFeedbackList(request, response);
    }

    // Hiển thị danh sách feedback
    private void showFeedbackList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy các tham số từ request
            String keyword = request.getParameter("keyword");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            int page = 1;
            int pageSize = DEFAULT_PAGE_SIZE;

            // Xử lý phân trang
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Lấy danh sách feedback với phân trang
            Map<String, Object> result = feedBackService.getFeedbacksWithPagination(
                    keyword, dateFrom, dateTo, page, pageSize
            );

            // Lấy thống kê
            Map<String, Object> stats = feedBackService.getStatistics();

            // Set attributes cho JSP
            if ((boolean) result.get("success")) {
                request.setAttribute("feedbacks", result.get("feedbacks"));
                request.setAttribute("totalFeedbacks", result.get("totalFeedbacks"));
                request.setAttribute("currentPage", result.get("currentPage"));
                request.setAttribute("totalPages", result.get("totalPages"));
                request.setAttribute("pageSize", result.get("pageSize"));
            } else {
                request.setAttribute("errorMsg", result.get("message"));
            }

            // Set thống kê
            if ((boolean) stats.get("success")) {
                request.setAttribute("totalFeedbacks", stats.get("totalFeedbacks"));
                request.setAttribute("todayFeedbacks", stats.get("todayFeedbacks"));
                request.setAttribute("weekFeedbacks", stats.get("weekFeedbacks"));
                request.setAttribute("monthFeedbacks", stats.get("monthFeedbacks"));
            }

            // Set filter values để hiển thị lại
            request.setAttribute("keyword", keyword != null ? keyword : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");

            // Forward to JSP
            request.getRequestDispatcher("/adminPage/admin_feedback.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/adminPage/admin_feedback.jsp").forward(request, response);
        }
    }
    //Lấy chi tiết feedback
    private void getFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.getWriter().write(gson.toJson(Map.of("error", "Thiếu ID phản hồi")));
                return;
            }

            int id = Integer.parseInt(idParam);
            Map<String, Object> result = feedBackService.getFeedbackDetail(id);

            if ((boolean) result.get("success")) {
                // Xóa success flag khỏi response
                result.remove("success");
                response.getWriter().write(gson.toJson(result));
            } else {
                response.getWriter().write(gson.toJson(Map.of("error", result.get("message"))));
            }

        } catch (NumberFormatException e) {
            response.getWriter().write(gson.toJson(Map.of("error", "ID không hợp lệ")));
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(gson.toJson(Map.of("error", "Lỗi server: " + e.getMessage())));
        }
    }
    //Xóa feedback
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                request.getSession().setAttribute("errorMsg", "Thiếu ID phản hồi");
                response.sendRedirect(request.getContextPath() + "/admin/feedback");
                return;
            }

            int id = Integer.parseInt(idParam);
            Map<String, Object> result = feedBackService.deleteFeedback(id);

            if ((boolean) result.get("success")) {
                request.getSession().setAttribute("successMsg", result.get("message"));
            } else {
                request.getSession().setAttribute("errorMsg", result.get("message"));
            }

            // Redirect giữ nguyên filter
            String queryString = getFilterQueryString(request);
            response.sendRedirect(request.getContextPath() + "/admin/feedback" + queryString);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
        }
    }

    private String getFilterQueryString(HttpServletRequest request) {
        StringBuilder qs = new StringBuilder();
        String keyword = request.getParameter("keyword");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        String page = request.getParameter("page");

        if (keyword != null && !keyword.isEmpty()) {
            qs.append("?keyword=").append(keyword);
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            qs.append(qs.length() == 0 ? "?" : "&").append("dateFrom=").append(dateFrom);
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            qs.append(qs.length() == 0 ? "?" : "&").append("dateTo=").append(dateTo);
        }
        if (page != null && !page.isEmpty()) {
            qs.append(qs.length() == 0 ? "?" : "&").append("page=").append(page);
        }

        return qs.toString();
    }
    //Đánh dấu opened và redirect đến Gmail compose
    private void markAsOpenedAndRedirectToGmail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                request.getSession().setAttribute("errorMsg", "Thiếu ID phản hồi");
                response.sendRedirect(request.getContextPath() + "/admin/feedback");
                return;
            }
            int id = Integer.parseInt(idParam);
            Map<String, Object> result = feedBackService.markAsOpened(id);
            if ((boolean) result.get("success")) {
                request.getSession().setAttribute("pendingReplyId", id);
                String email = (String) result.get("email");
                String fullName = (String) result.get("fullName");
                String subject = URLEncoder.encode("Phản hồi từ Sweet Oven", StandardCharsets.UTF_8.toString());
                String body = URLEncoder.encode(
                        "Chào " + fullName + ",\n\nCảm ơn bạn đã gửi phản hồi đến Sweet Oven...",
                        StandardCharsets.UTF_8.toString()
                );
                String gmailUrl = "https://mail.google.com/mail/?view=cm&fs=1&to=" + email + "&su=" + subject + "&body=" + body;
                response.sendRedirect(gmailUrl);
            } else {
                request.getSession().setAttribute("errorMsg", result.get("message"));
                response.sendRedirect(request.getContextPath() + "/admin/feedback");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
        }
    }

    // Xác nhận đã gửi email
    private void confirmReplied(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu ID phản hồi\"}");
                return;
            }
            int id = Integer.parseInt(idParam);
            Map<String, Object> result = feedBackService.confirmReplied(id);
            if (request.getSession().getAttribute("pendingReplyId") != null) {
                request.getSession().removeAttribute("pendingReplyId");
            }
            response.getWriter().write(new Gson().toJson(result));
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ\"}");
        }
    }
}