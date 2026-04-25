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
    public boolean updateProfile(User user) {

        if (user == null) {
            return false;
        }

        if (user.getFullName() == null || user.getFullName().isBlank()) {
            return false;
        }

        Integer gender = user.getGender();
        if (gender != 0 && gender != 1 && gender != 2) {
            return false;
        }

        if (user.getEmail() == null || user.getEmail().isBlank()) {
            return false;
        }

        if (user.getPhoneNumber() == null || !user.getPhoneNumber().matches("\\d{9,11}")) {
            return false;
        }

        return userDao.updateProfile(user);
    }
    public boolean updateAvatar(int userId, String avatarPath) {
        if (avatarPath == null || avatarPath.isBlank()) {
            return false;
        }
        return userDao.updateAvatar(userId, avatarPath);
    }
}
