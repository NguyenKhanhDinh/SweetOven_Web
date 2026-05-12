package service;

import dao.UserDao;
import model.User;

public class UserService {
    private UserDao userDao = new UserDao();

    //for login
    public User login(String username, String password) {
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return null;
        }
        User user = userDao.findByUsername(username);
        if (user == null) {
            return null;
        }
        if (!utils.PasswordUtil.verifyPassword(password, user.getPassword())) {
            return null;
        }
        user.setPassword(null); // Xóa hash khỏi session cho an toàn
        return user;
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

    public enum ValidateResult {
        OK,
        USERNAME_EXISTS,
        EMAIL_EXISTS,
        WEAK_PASSWORD,
        PHONE_EXISTS,
        INVALID_INPUT,
        DB_ERROR
    }

    public ValidateResult validate(String fullName, String username, String email, String phone, String password) {
        if (isBlank(fullName) || isBlank(username) || isBlank(email) || isBlank(phone) || isBlank(password)) {
            return ValidateResult.INVALID_INPUT;
        }
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) {
            return ValidateResult.INVALID_INPUT;
        }
        if (!phone.matches("\\d{9,11}")) {
            return ValidateResult.INVALID_INPUT;
        }
        if (!isStrongPassword(password)) {
            return ValidateResult.WEAK_PASSWORD;
        }
        try {
            if (UserDao.isUsernameExists(username.trim())) {
                return ValidateResult.USERNAME_EXISTS;
            }
            if (UserDao.isEmailExists(email.trim())) {
                return ValidateResult.EMAIL_EXISTS;
            }
            if (UserDao.isPhoneExists(phone.trim())) {
                return ValidateResult.PHONE_EXISTS;
            }
            return ValidateResult.OK;
        } catch (Exception e) {
            return ValidateResult.DB_ERROR;
        }
    }

    public boolean createUser(String fullName, String username, String email, String phone, String password) {
        try {
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
            return userDao.insertUser(newUser);
        } catch (Exception e) {
            return false;
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
    public enum ChangePasswordResult {
        SUCCESS,
        WRONG_OLD_PASSWORD,
        WEAK_NEW_PASSWORD,
        CONFIRM_NOT_MATCH,
        ERROR
    }
    public ChangePasswordResult changePassword(int userId,String oldPassword, String newPassword, String confirmPassword) {
        if(!newPassword.equals(confirmPassword)) {
            return ChangePasswordResult.CONFIRM_NOT_MATCH;
        }
        if(!isStrongPassword(newPassword)) {
            return  ChangePasswordResult.WEAK_NEW_PASSWORD;
        }
        String storeHash = userDao.findPasswordById(userId);
        if(storeHash == null || !utils.PasswordUtil.verifyPassword(oldPassword, storeHash)) {
            return ChangePasswordResult.WRONG_OLD_PASSWORD;
        }
        String newHash = utils.PasswordUtil.hashPassword(newPassword);
        boolean ok = userDao.updatePassword(userId, newHash);
        return ok ? ChangePasswordResult.SUCCESS: ChangePasswordResult.ERROR;
    }
}
