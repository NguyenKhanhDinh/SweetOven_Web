package service;

import dao.UserDao;
import model.User;

public class UserService {
    private UserDao userDao = new UserDao();
    //for login
    public User login(String username, String password) {
        if(username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return null;
        }
        return userDao.login(username, password);
    }
   // dùng lấy thông tin hiển thị trang profile
    public User findById(int id) {
       return userDao.findById(id);
    }
    // dùng cập nhật thông tin trang profile
    public String updateProfile(User user) {
        if(user == null) {
            return "Dữ liệu rỗng";
        }
        if(user.getFullName() == null || user.getFullName().isBlank()) {
            return "Thiếu họ tên";
        }
        Integer gender = user.getGender();
        if (gender != 0 || gender !=1) {
            return "Giới tính không hợp lệ";
        }
        if(user.getEmail() == null || user.getEmail().isBlank()) {
            return "Thiếu email";
        }
        if(user.getPhoneNumber() == null || !user.getPhoneNumber().matches("\\d{9,11}")) {
            return "Số điện thoại không hợp lệ";
        }

        boolean result = userDao.updateProfile(user);
        return result?"SUCCESS": "Lỗi database";
    }
}
