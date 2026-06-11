package service;

import dao.AdminUserDao;
import model.User;
import utils.PasswordUtil;

import java.util.List;

public class AdminUserService {

    private final AdminUserDao adminUserDao = new AdminUserDao();

    public int countAllUsers() {
        return adminUserDao.countAllUsers();
    }

    public int countActiveUsers() {
        return adminUserDao.countActiveUsers();
    }

    public int countBlockedUsers() {
        return adminUserDao.countBlockedUsers();
    }

    public int countNewUsersThisMonth() {
        return adminUserDao.countNewUsersThisMonth();
    }

    public List<User> getUsers(String keyword, int status, int blocked, int page, int pageSize) {
        if (page < 1) page = 1;
        return adminUserDao.getUsers(keyword, status, blocked, page, pageSize);
    }

    public int countUsers(String keyword, int status, int blocked) {
        return adminUserDao.countUsers(keyword, status, blocked);
    }

    public User findById(int id) {
        return adminUserDao.findById(id);
    }

    public int countOrdersByUserId(int userId) {
        return adminUserDao.countOrdersByUserId(userId);
    }

    public enum BlockResult {SUCCESS, NOT_FOUND, SELF_BLOCK, ERROR}

    public BlockResult blockUser(int targetId, int adminId) {
        if (targetId == adminId) return BlockResult.SELF_BLOCK;
        User user = adminUserDao.findById(targetId);
        if (user == null) return BlockResult.NOT_FOUND;
        return adminUserDao.setBlocked(targetId, true) ? BlockResult.SUCCESS : BlockResult.ERROR;
    }

    public BlockResult unblockUser(int targetId, int adminId) {
        if (targetId == adminId) return BlockResult.SELF_BLOCK;
        User user = adminUserDao.findById(targetId);
        if (user == null) return BlockResult.NOT_FOUND;
        return adminUserDao.setBlocked(targetId, false) ? BlockResult.SUCCESS : BlockResult.ERROR;
    }

    public enum ResetPwdResult {SUCCESS, NOT_FOUND, ERROR}

    public static final String DEFAULT_RESET_PASSWORD = "SweetOven@2024";

    public ResetPwdResult resetPassword(int userId) {
        User user = adminUserDao.findById(userId);
        if (user == null) return ResetPwdResult.NOT_FOUND;
        String hashed = PasswordUtil.hashPassword(DEFAULT_RESET_PASSWORD);
        return adminUserDao.resetPassword(userId, hashed) ? ResetPwdResult.SUCCESS : ResetPwdResult.ERROR;
    }

    public enum CreateResult {
        SUCCESS, USERNAME_EXISTS, EMAIL_EXISTS, PHONE_EXISTS, WEAK_PASSWORD, INVALID_INPUT, ERROR
    }

    public CreateResult createUser(String fullName, String username, String email, String phone, String password, int gender, int roleId) {
        if (isBlank(fullName) || isBlank(username) || isBlank(email) || isBlank(phone) || isBlank(password)) {
            return CreateResult.INVALID_INPUT;
        }
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) return CreateResult.INVALID_INPUT;
        if (!phone.matches("\\d{9,11}")) return CreateResult.INVALID_INPUT;
        if (!isStrongPassword(password)) return CreateResult.WEAK_PASSWORD;

        try {
            if (adminUserDao.isUsernameExists(username.trim())) return CreateResult.USERNAME_EXISTS;
            if (adminUserDao.isEmailExists(email.trim())) return CreateResult.EMAIL_EXISTS;
            if (adminUserDao.isPhoneExists(phone.trim())) return CreateResult.PHONE_EXISTS;

            User user = new User();
            user.setFullName(fullName.trim());
            user.setUserName(username.trim());
            user.setEmail(email.trim());
            user.setPhoneNumber(phone.trim());
            user.setPassword(PasswordUtil.hashPassword(password));
            user.setGender(gender);
            user.setRoleId(roleId);
            user.setStatus(1);
            user.setBlocked(false);

            return adminUserDao.insertUser(user) ? CreateResult.SUCCESS : CreateResult.ERROR;
        } catch (Exception e) {
            return CreateResult.ERROR;
        }
    }

    public enum UpdateResult {
        SUCCESS, NOT_FOUND, EMAIL_TAKEN, INVALID_INPUT, ERROR
    }

    public UpdateResult updateUser(int id, String fullName, String email, String phone, int gender) {
        if (isBlank(fullName) || isBlank(email) || isBlank(phone)) return UpdateResult.INVALID_INPUT;
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.\\w+$")) return UpdateResult.INVALID_INPUT;
        if (!phone.matches("\\d{9,11}")) return UpdateResult.INVALID_INPUT;

        User existing = adminUserDao.findById(id);
        if (existing == null) return UpdateResult.NOT_FOUND;

        if (adminUserDao.isEmailExistsExcept(email.trim(), id)) return UpdateResult.EMAIL_TAKEN;

        existing.setFullName(fullName.trim());
        existing.setEmail(email.trim());
        existing.setPhoneNumber(phone.trim());
        existing.setGender(gender);

        return adminUserDao.updateUser(existing) ? UpdateResult.SUCCESS : UpdateResult.ERROR;
    }

    public boolean promoteToAdmin(int userId, int adminId) {
        if (userId == adminId) return false;
        return adminUserDao.setRole(userId, 1);
    }

    public boolean demoteToUser(int userId, int adminId) {
        if (userId == adminId) return false;
        return adminUserDao.setRole(userId, 2);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean isStrongPassword(String pwd) {
        return pwd.length() >= 8 && pwd.matches(".*[A-Z].*") && pwd.matches(".*[a-z].*") && pwd.matches(".*[0-9].*") && pwd.matches(".*[^A-Za-z0-9].*");
    }
}