package dao;
import model.User;
import utils.JdbiConnector;
public class UserDao {
    //check login
    public User login(String username, String password) {
        String sql = "SELECT u.id, u.avatar, u.full_name AS fullName, u.username, " +
                "u.gender, u.email, u.phone_number AS phoneNumber, u.password, " +
                "u.status, u.is_blocked AS blocked, u.role_id AS roleId " +
                "FROM `user` u " +
                "WHERE u.username = :username AND u.password = :password " +
                "AND u.status = 1 AND u.is_blocked = 0";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).bind("username", username).bind("password", password).mapToBean(User.class).findFirst().orElse(null)
        );
    }
}
