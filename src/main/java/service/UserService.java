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
    public enum RegisterResult {
        SUCCESS,
        USERNAME_EXISTS,
        EMAIL_EXISTS,
        WEAK_PASSWORD,
        PHONE_EXISTS,
        INVALID_INPUT,
        DB_ERROR
    }
    public RegisterResult register(String fullName, String username, String email, String phone, String password) {
    if (isBlank(fullName) || isBlank(username) || isBlank(email) || isBlank(phone) || isBlank(password)) {
        return RegisterResult.INVALID_INPUT;
    }
    if (!email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) {
        return RegisterResult.INVALID_INPUT;
    }
    if (!phone.matches("\\d{9,11}")) {
        return RegisterResult.INVALID_INPUT;}
    if (!isStrongPassword(password)) {
        return RegisterResult.WEAK_PASSWORD;}
    try{
        if (UserDao.isUsernameExists(username.trim())) {
            return RegisterResult.USERNAME_EXISTS;
        }
        if (UserDao.isEmailExists(email.trim())) {
            return RegisterResult.EMAIL_EXISTS;}
        if (UserDao.isPhoneExists(phone.trim())) {
            return RegisterResult.PHONE_EXISTS;}
        String hashed = utils.PasswordUtil.hashPassword(password);
        User newUser = new User();
        newUser.setFullName(fullName.trim());
        newUser.setUserName(username.trim());
        newUser.setEmail(email.trim());
        newUser.setPhoneNumber(phone.trim());
        newUser.setPassword(hashed);
        newUser.setGender(0);
        newUser.setRoleId(2);
        newUser.setStatus(1);
        newUser.setBlocked(false);
        boolean ok = userDao.insertUser(newUser);
        return ok ? RegisterResult.SUCCESS : RegisterResult.DB_ERROR;
    } catch (Exception e) {
        return RegisterResult.DB_ERROR;
    }
}
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean isStrongPassword(String pwd) {
        return pwd.length() >= 8
                && pwd.matches(".*[A-Z].*")
                && pwd.matches(".*[a-z].*")
                && pwd.matches(".*[0-9].*")
                && pwd.matches(".*[^A-Za-z0-9].*");
    }
}
