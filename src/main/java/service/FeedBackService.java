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
            int offset = (page - 1) * pageSize;
            List<FeedBack> feedbacks = feedBackDao.findAllWithFilters(
                    keyword, dateFrom, dateTo, offset, pageSize
            );
            long totalFeedbacks = feedBackDao.countWithFilters(keyword, dateFrom, dateTo);
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

    // Lấy thống kê
    public Map<String, Object> getStatistics() {
        Map<String, Object> result = new HashMap<>();

        try {
            long total = feedBackDao.getTotalFeedbacks();
            long today = feedBackDao.getTodayFeedbacks();
            long week = feedBackDao.getWeekFeedbacks();
            long month = feedBackDao.getMonthFeedbacks();
            long pending = feedBackDao.getPendingFeedbacks();

            result.put("success", true);
            result.put("totalFeedbacks", total);
            result.put("todayFeedbacks", today);
            result.put("weekFeedbacks", week);
            result.put("monthFeedbacks", month);
            result.put("pendingFeedbacks", pending);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy thống kê: " + e.getMessage());
        }

        return result;
    }

    // Lấy chi tiết feedback
    public Map<String, Object> getFeedbackDetail(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);

            if (feedback != null) {
                result.put("success", true);
                result.put("id", feedback.getId());
                result.put("fullName", feedback.getFullName());
                result.put("email", feedback.getEmail());
                result.put("phoneNumber", feedback.getPhoneNumber());
                result.put("content", feedback.getContent());
                result.put("reply", feedback.getReply());
                result.put("status", feedback.getStatus());
                result.put("externalReplyStatus", feedback.getExternalReplyStatus());
                result.put("createdAt", feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString() : "");
                result.put("repliedAt", feedback.getRepliedAt() != null ? feedback.getRepliedAt().toString() : "");
                result.put("repliedBy", feedback.getRepliedBy());
            } else {
                result.put("success", false);
                result.put("message", "Không tìm thấy phản hồi!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy chi tiết phản hồi: " + e.getMessage());
        }

        return result;
    }

    // Mở Gmail
    public Map<String, Object> markAsOpened(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);
            if (feedback == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean updated = feedBackDao.updateExternalReplyStatusOpened(id);

            if (updated) {
                result.put("success", true);
                result.put("message", "Đã mở Gmail");
                result.put("email", feedback.getEmail());
                result.put("fullName", feedback.getFullName());
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        return result;
    }

    // Xác nhận đã gửi email
    public Map<String, Object> confirmReplied(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);
            if (feedback == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean updated = feedBackDao.updateExternalReplyStatusReplied(id);

            if (updated) {
                result.put("success", true);
                result.put("message", "Đã xác nhận gửi email phản hồi!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        return result;
    }

    // Lưu nội dung reply và cập nhật trạng thái
    public Map<String, Object> saveReplyAndConfirm(int id, String replyContent, String repliedBy) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);
            if (feedback == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean updated = feedBackDao.updateRepliedStatus(id, replyContent, repliedBy);

            if (updated) {
                result.put("success", true);
                result.put("message", "Đã lưu phản hồi và cập nhật trạng thái!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể lưu phản hồi!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        return result;
    }

    // Xóa feedback
    public Map<String, Object> deleteFeedback(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack existing = feedBackDao.findById(id);
            if (existing == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean deleted = feedBackDao.deleteById(id);

            if (deleted) {
                result.put("success", true);
                result.put("message", "Xóa phản hồi thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể xóa phản hồi!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi xóa phản hồi: " + e.getMessage());
        }

        return result;
    }
}