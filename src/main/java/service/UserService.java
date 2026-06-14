package service;

import dao.PasswordResetTokenDao;
import dao.UserDao;
import model.PasswordResetToken;
import model.User;

import java.awt.*;
import java.time.LocalDateTime;
import java.util.UUID;

public class UserService {
    private UserDao userDao = new UserDao();
    private PasswordResetTokenDao tokenDao = new PasswordResetTokenDao();

    public enum LoginResult {SUCCESS, WRONG_CREDENTIALS, NOT_VERIFIED, BLOCKED}

    // login trả về enum để controller hiển thị đúng thông báo lỗi
    public LoginResult loginCheck(String username, String password) {
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return LoginResult.WRONG_CREDENTIALS;
        }
        User user = userDao.findByUsernameAny(username);
        if (user == null) return LoginResult.WRONG_CREDENTIALS;
        if (!utils.PasswordUtil.verifyPassword(password, user.getPassword())) return LoginResult.WRONG_CREDENTIALS;
        if (user.getStatus() == 0) return LoginResult.NOT_VERIFIED;
        if (user.isBlocked()) return LoginResult.BLOCKED;
        return LoginResult.SUCCESS;
    }

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
        user.setPassword(null);
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

    public User findOrCreateGoogleUser(String email, String fullName) {
        User existing = userDao.findByEmail(email);
        if (existing != null) {
            return existing;
        }
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setRoleId(2);
        newUser.setStatus(1);
        newUser.setBlocked(false);
        return userDao.insertGoogleUser(newUser);

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

    public ChangePasswordResult changePassword(int userId, String oldPassword, String newPassword, String confirmPassword) {
        if (!newPassword.equals(confirmPassword)) {
            return ChangePasswordResult.CONFIRM_NOT_MATCH;
        }
        if (!isStrongPassword(newPassword)) {
            return ChangePasswordResult.WEAK_NEW_PASSWORD;
        }
        String storeHash = userDao.findPasswordById(userId);
        if (storeHash == null || !utils.PasswordUtil.verifyPassword(oldPassword, storeHash)) {
            return ChangePasswordResult.WRONG_OLD_PASSWORD;
        }
        String newHash = utils.PasswordUtil.hashPassword(newPassword);
        boolean ok = userDao.updatePassword(userId, newHash);
        return ok ? ChangePasswordResult.SUCCESS : ChangePasswordResult.ERROR;
    }

    public boolean processForgotPassword(String email, String baseUrl) {
        try {
            User user = userDao.findByEmail(email.trim());
            if (user == null) {
                return true;
            }
            String token = UUID.randomUUID().toString();
            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);
            tokenDao.deleteByUserId(user.getId());
            tokenDao.insertToken(user.getId(), token, expiredAt);
            String resetLink = baseUrl + "/reset-password?token=" + token;
            utils.EmailUtil.sendResetPasswordEmail(user.getEmail(), user.getFullName(), resetLink);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public enum ResetPasswordResult {
        SUCCESS,
        INVALID_TOKEN,
        EXPIRED_TOKEN,
        WEAK_PASSWORD,
        COMFIRM_NOT_MATCH,
        ERROR
    }

    public ResetPasswordResult resetPassword(String token, String newPassword, String confirmPassword) {
        try {
            if (!newPassword.equals(confirmPassword)) {
                return ResetPasswordResult.COMFIRM_NOT_MATCH;
            }
            if (!isStrongPassword(newPassword)) {
                return ResetPasswordResult.WEAK_PASSWORD;
            }
            PasswordResetToken prt = tokenDao.findByToken(token);
            if (prt == null) {
                return ResetPasswordResult.INVALID_TOKEN;
            }
            if (prt.getExpiredAt().isBefore(LocalDateTime.now())) {
                tokenDao.deleteByToken(token);
                return ResetPasswordResult.EXPIRED_TOKEN;
            }
            String hashed = utils.PasswordUtil.hashPassword(newPassword);
            boolean ok = userDao.updatePassword(prt.getUserId(), hashed);
            if (ok) {
                tokenDao.deleteByToken(token);
                return ResetPasswordResult.SUCCESS;
            }
            return ResetPasswordResult.ERROR;
        } catch (Exception e) {
            return ResetPasswordResult.ERROR;
        }
    }

    public ResetPasswordResult validateToken(String token) {
        if (token == null || token.isBlank()) return ResetPasswordResult.INVALID_TOKEN;
        PasswordResetToken prt = tokenDao.findByToken(token);
        if (prt == null) return ResetPasswordResult.INVALID_TOKEN;
        if (prt.getExpiredAt().isBefore(LocalDateTime.now())) {
            tokenDao.deleteByToken(token);
            return ResetPasswordResult.EXPIRED_TOKEN;
        }
        return ResetPasswordResult.SUCCESS;
    }

    public boolean activateByEmail(String email) {
        return userDao.setStatusByEmail(email, 1);
    }

    public User findOrFacebookUser(String facebookId, String fullName) {
        User existing = userDao.findByFacebookId(facebookId);
        if (existing != null) {
            return existing;
        }
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setFacebookId(facebookId);
        newUser.setRoleId(2);
        newUser.setStatus(1);
        newUser.setBlocked(false);
        return userDao.insertFacebookUser(newUser);
    }
}
