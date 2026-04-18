package service;

import dao.FeedBackDao;
import model.FeedBack;

public class FeedBackService {
    private FeedBackDao feedBackDao = new FeedBackDao();
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
        return result?"SUCCESS":"Lỗi database";
    }
}
