package service;

import dao.FeedBackDao;
import model.FeedBack;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class FeedBackService {

    private final FeedBackDao feedBackDao;

    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)[0-9]{9,10}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    public FeedBackService() {
        this.feedBackDao = new FeedBackDao();
    }

    public String insertFeedBack(FeedBack feedBack) {
        if (feedBack == null) return "Dữ liệu rỗng";

        if (feedBack.getFullName() == null || feedBack.getFullName().isBlank()) {
            return "Thiếu họ tên";
        }

        if (feedBack.getEmail() == null || feedBack.getEmail().isBlank()) {
            return "Thiếu email";
        }

        if (feedBack.getPhoneNumber() == null || !feedBack.getPhoneNumber().matches("\\d{9,11}")) {
            return "Số điện thoại không hợp lệ";
        }

        boolean result = feedBackDao.insert(feedBack);
        return result ? "SUCCESS" : "Lỗi database";
    }
    // Lấy danh sách phản hồi, phân trang và lọc
    public Map<String, Object> getFeedbacksWithPagination(String keyword, String dateFrom,
                                                          String dateTo, int page, int pageSize) {
        Map<String, Object> result = new HashMap<>();

        try {
            // Tính offset
            int offset = (page - 1) * pageSize;

            // Lấy danh sách feedback
            List<FeedBack> feedbacks = feedBackDao.findAllWithFilters(
                    keyword, dateFrom, dateTo, offset, pageSize
            );

            // Lấy tổng số bản ghi
            long totalFeedbacks = feedBackDao.countWithFilters(keyword, dateFrom, dateTo);

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalFeedbacks / pageSize);

            result.put("success", true);
            result.put("feedbacks", feedbacks);
            result.put("totalFeedbacks", totalFeedbacks);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("pageSize", pageSize);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy danh sách phản hồi: " + e.getMessage());
        }

        return result;
    }
    //Lấy thống kê
    public Map<String, Object> getStatistics() {
        Map<String, Object> result = new HashMap<>();

        try {
            long total = feedBackDao.getTotalFeedbacks();
            long today = feedBackDao.getTodayFeedbacks();
            long week = feedBackDao.getWeekFeedbacks();
            long month = feedBackDao.getMonthFeedbacks();

            result.put("success", true);
            result.put("totalFeedbacks", total);
            result.put("todayFeedbacks", today);
            result.put("weekFeedbacks", week);
            result.put("monthFeedbacks", month);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy thống kê: " + e.getMessage());
        }

        return result;
    }
}