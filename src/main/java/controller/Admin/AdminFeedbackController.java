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
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Sẽ thêm ở các commit sau
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

}