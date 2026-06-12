package dao;

import model.User;
import utils.JdbiConnector;

import java.util.List;

public class AdminUserDao {

    public int countAllUsers() {
        String sql = "SELECT COUNT(*) FROM `user`";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countActiveUsers() {
        String sql = "SELECT COUNT(*) FROM `user` WHERE role_id = 2 AND status = 1 AND is_blocked = 0";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countBlockedUsers() {
        String sql = "SELECT COUNT(*) FROM `user` WHERE role_id = 2 AND is_blocked = 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countNewUsersThisMonth() {
        String sql = "SELECT COUNT(*) FROM `user` WHERE role_id = 2 " + "AND MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public List<User> getUsers(String keyword, int blocked, int roleId, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT id, avatar, full_name AS fullName, username AS userName, gender, email, " + "phone_number AS phoneNumber, status, is_blocked AS isBlocked, role_id AS roleId, " + "created_at AS createdAt, updated_at AS updatedAt " + "FROM `user` WHERE 1=1 ");

        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (full_name LIKE :kw OR username LIKE :kw OR email LIKE :kw OR phone_number LIKE :kw) ");
        }
        if (blocked >= 0) {
            sql.append("AND is_blocked = :blocked ");
        }
        if (roleId >= 0) {
            sql.append("AND role_id = :roleId ");
        }
        sql.append("ORDER BY created_at DESC LIMIT :limit OFFSET :offset");

        int offset = (page - 1) * pageSize;
        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (keyword != null && !keyword.isBlank()) query.bind("kw", kw);
            if (blocked >= 0) query.bind("blocked", blocked);
            if (roleId >= 0) query.bind("roleId", roleId);
            query.bind("limit", pageSize).bind("offset", offset);
            return query.mapToBean(User.class).list();
        });
    }

    public int countUsers(String keyword, int blocked, int roleId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM `user` WHERE 1=1 ");

        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (full_name LIKE :kw OR username LIKE :kw OR email LIKE :kw OR phone_number LIKE :kw) ");
        }
        if (blocked >= 0) {
            sql.append("AND is_blocked = :blocked ");
        }
        if (roleId >= 0) {
            sql.append("AND role_id = :roleId ");
        }

        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (keyword != null && !keyword.isBlank()) query.bind("kw", kw);
            if (blocked >= 0) query.bind("blocked", blocked);
            if (roleId >= 0) query.bind("roleId", roleId);
            return query.mapTo(Integer.class).one();
        });
    }

    public User findById(int id) {
        String sql = "SELECT id, avatar, full_name AS fullName, username AS userName, gender, email, " + "phone_number AS phoneNumber, status, is_blocked AS isBlocked, role_id AS roleId, " + "created_at AS createdAt, updated_at AS updatedAt " + "FROM `user` WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id", id).mapToBean(User.class).findFirst().orElse(null));
    }

    public boolean setBlocked(int userId, boolean blocked) {
        String sql = "UPDATE `user` SET is_blocked = :blocked, updated_at = NOW() WHERE id = :id AND role_id = 2";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("blocked", blocked ? 1 : 0).bind("id", userId).execute()) > 0;
    }

    public boolean setRole(int userId, int roleId) {
        String sql = "UPDATE `user` SET role_id = :roleId, updated_at = NOW() WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("roleId", roleId).bind("id", userId).execute()) > 0;
    }

    public boolean setStatus(int userId, int status) {
        String sql = "UPDATE `user` SET status = :status, updated_at = NOW() WHERE id = :id AND role_id = 2";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql).bind("status", status).bind("id", userId).execute()) > 0;
    }

    public boolean insertUser(User user) {
        String sql = "INSERT INTO `user` (full_name, username, email, phone_number, password, " + "gender, role_id, status, is_blocked, created_at) " + "VALUES (:fullName, :username, :email, :phone, :password, :gender, :roleId, :status, 0, NOW())";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("fullName", user.getFullName()).bind("username", user.getUserName()).bind("email", user.getEmail()).bind("phone", user.getPhoneNumber()).bind("password", user.getPassword()).bind("gender", user.getGender()).bind("roleId", user.getRoleId()).bind("status", user.getStatus()).execute()) > 0;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE `user` SET full_name = :fullName, email = :email, " + "phone_number = :phone, gender = :gender, updated_at = NOW() " + "WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("fullName", user.getFullName()).bind("email", user.getEmail()).bind("phone", user.getPhoneNumber()).bind("gender", user.getGender()).bind("id", user.getId()).execute()) > 0;
    }

    public boolean resetPassword(int userId, String hashedPassword) {
        String sql = "UPDATE `user` SET password = :password, updated_at = NOW() WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("password", hashedPassword).bind("id", userId).execute()) > 0;
    }

    public int countOrdersByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM `order` WHERE user_id = :userId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).mapTo(Integer.class).one());
    }

    public boolean isEmailExistsExcept(String email, int excludeId) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE email = :email AND id != :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("email", email).bind("id", excludeId).mapTo(Integer.class).one()) > 0;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE username = :username";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("username", username).mapTo(Integer.class).one()) > 0;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE email = :email";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("email", email).mapTo(Integer.class).one()) > 0;
    }

    public boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE phone_number = :phone";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("phone", phone).mapTo(Integer.class).one()) > 0;
    }
}