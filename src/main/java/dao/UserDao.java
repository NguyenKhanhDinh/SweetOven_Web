package dao;

import model.User;
import org.jdbi.v3.core.Handle;
import utils.JdbiConnector;

public class UserDao {
    //check login - chỉ trả về user đã xác thực và không bị khoá
    public User findByUsername(String username) {
        String sql = "SELECT u.id, u.avatar, u.full_name AS fullName, u.username, " +
                "u.gender, u.email, u.phone_number AS phoneNumber, u.password, " +
                "u.status, u.is_blocked AS blocked, u.role_id AS roleId " +
                "FROM `user` u " +
                "WHERE u.username = :username AND u.status = 1 AND u.is_blocked = 0";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).bind("username", username).mapToBean(User.class).findFirst().orElse(null)
        );
    }

    // tìm user theo username bất kể status/blocked - dùng để kiểm tra lý do login thất bại
    public User findByUsernameAny(String username) {
        String sql = "SELECT u.id, u.avatar, u.full_name AS fullName, u.username, " +
                "u.gender, u.email, u.phone_number AS phoneNumber, u.password, " +
                "u.status, u.is_blocked AS isBlocked, u.role_id AS roleId " +
                "FROM `user` u WHERE u.username = :username";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).bind("username", username).mapToBean(User.class).findFirst().orElse(null)
        );
    }

    public User findById(int id) {
        String sql = "SELECT * FROM `user` WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id", id).mapToBean(User.class).findFirst().orElse(null));
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE user SET full_name = :fullName, email = :email, phone_number = :phone, gender = :gender WHERE id = :id ";
        try {
            return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("fullName", user.getFullName())
                    .bind("email", user.getEmail())
                    .bind("phone", user.getPhoneNumber())
                    .bind("gender", user.getGender())
                    .bind("id", user.getId())
                    .execute() )>0;
        } catch (Exception e) {
           return false;
        }
    }

    public boolean updateAvatar(int userId, String avatar) {
        String sql = """
                        UPDATE user SET avatar = :avatar
                        WHERE id = :id
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("avatar", avatar).bind("id", userId).execute()) > 0;
    }

    public static boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE username = :username";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("username", username).mapTo(Integer.class).one()) > 0;
    }

    public static boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE email = :email";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("email", email).mapTo(Integer.class).one()) > 0;
    }

    public static boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM `user` WHERE phone_number = :phone";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("phone", phone).mapTo(Integer.class).one()) > 0;
    }

    //insert account to DB
    public boolean insertUser(User user) {
        String sql = "INSERT INTO `user` (full_name, username, email, phone_number, password, gender, role_id, status, is_blocked) VALUES (:fullName, :username, :email, :phone, :password, :gender, :roleId, :status, :blocked) ";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("fullName", user.getFullName())
                        .bind("username", user.getUserName())
                        .bind("email", user.getEmail())
                        .bind("phone", user.getPhoneNumber())
                        .bind("password", user.getPassword())
                        .bind("gender", user.getGender())
                        .bind("roleId", user.getRoleId())
                        .bind("status", user.getStatus())
                        .bind("blocked", user.isBlocked())
                        .execute()
        ) > 0;
    }

    public String findPasswordById(int id) {
        String sql = "SELECT password FROM `user` WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("id", id).mapTo(String.class).findFirst().orElse(null));
    }

    public boolean updatePassword(int id, String newPassword) {
        String sql = "UPDATE `user` SET password = :password WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("password", newPassword).bind("id", id).execute()) > 0;
    }

    public User findByEmailAny(String email) {
        String sql = "SELECT u.id, u.avatar, u.full_name AS fullName, u.username,u.gender, u.email, u.phone_number AS phoneNumber, u.password,u.status, u.is_blocked AS blocked, u.role_id AS roleId FROM `user` u WHERE u.email = :email LIMIT 1";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("email", email).mapToBean(User.class).findFirst().orElse(null));
    }

    public User insertGoogleUser(User user) {
        String sql = "INSERT INTO `user` (full_name, email, avatar, gender, role_id, status, is_blocked) VALUES (:fullName, :email, :avatar, 0, :roleId, :status, 0)";
        return JdbiConnector.getJdbi().withHandle(handle -> {
            int generatedId = handle.createUpdate(sql)
                    .bind("fullName", user.getFullName())
                    .bind("email", user.getEmail())
                    .bind("avatar", user.getAvatar())
                    .bind("roleId", user.getRoleId())
                    .bind("status", user.getStatus())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
            user.setId(generatedId);
            return user;
        });
    }

    public User findByEmail(String email) {
        String sql = "SELECT u.id, u.avatar, u.full_name AS fullName, u.username, " +
                "u.gender, u.email, u.phone_number AS phoneNumber, u.password, " +
                "u.status, u.is_blocked AS blocked, u.role_id AS roleId " +
                "FROM `user` u " +
                "WHERE u.email = :email AND u.status = 1 AND u.is_blocked = 0";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("email", email).mapToBean(User.class).findFirst().orElse(null)
        );
    }

    public boolean setStatusByEmail(String email, int status) {
        String sql = "UPDATE `user` SET status = :status WHERE email = :email";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("email", email)
                        .execute()) > 0;
    }

    public User findByFacebookId(String facebookId) {
        String sql = "SELECT u.id, u.avatar, u.full_name AS fullName, u.username, " +
                "u.gender, u.email, u.phone_number AS phoneNumber, u.password, " +
                "u.status, u.is_blocked AS blocked, u.role_id AS roleId, u.facebook_id AS facebookId " +
                "FROM `user` u WHERE u.facebook_id = :facebookId AND u.is_blocked = 0";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("facebookId", facebookId).mapToBean(User.class).findFirst().orElse(null));
    }

    public User insertFacebookUser(User user) {
        String sql = "INSERT INTO `user` (full_name, facebook_id, gender, role_id, status, is_blocked) " +
                "VALUES (:fullName, :facebookId, 0, :roleId, :status, 0)";
        return JdbiConnector.getJdbi().withHandle(handle -> {
            int generatedId = handle.createUpdate(sql)
                    .bind("fullName", user.getFullName())
                    .bind("facebookId", user.getFacebookId())
                    .bind("roleId", user.getRoleId())
                    .bind("status", user.getStatus())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
            user.setId(generatedId);
            return user;
        });
    }
}