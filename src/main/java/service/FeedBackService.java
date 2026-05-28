package service;

import dao.FeedBackDao;
import model.FeedBack;

import java.time.LocalDateTime;
import java.util.List;

public class FeedBackService {
    private FeedBackDao feedBackDao = new FeedBackDao();
    private OpenAISentimentService sentimentService = new OpenAISentimentService();

    public String insertFeedBack(FeedBack feedBack) {
        if (feedBack == null) return "Dữ liệu rỗng";

        if (feedBack.getFullName() == null || feedBack.getFullName().isBlank()) {
            return "Thiếu họ tên";
        }

        if (feedBack.getEmail() == null || feedBack.getEmail().isBlank()) {
            return "Thiếu email";
        }

        if (feedBack.getPhoneNumber() != null && !feedBack.getPhoneNumber().isEmpty() &&
                !feedBack.getPhoneNumber().matches("\\d{9,11}")) {
            return "Số điện thoại không hợp lệ";
        }

        String sentiment = sentimentService.analyzeSentiment(feedBack.getContent());
        feedBack.setSentiment(sentiment);
        feedBack.setSentimentAnalyzedAt(LocalDateTime.now());

        boolean result = feedBackDao.insert(feedBack);

        return result ? "SUCCESS" : "Lỗi database";
    }

    public List<FeedBack> getAllFeedbacks() {
        return feedBackDao.getAllFeedbacks();
    }

    public List<FeedBack> getPositiveFeedbacksForHomepage() {
        return feedBackDao.getPositiveFeedbacks(6);
    }
}