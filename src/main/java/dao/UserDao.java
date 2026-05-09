package dao;
import model.User;
import org.jdbi.v3.core.Handle;
import utils.JdbiConnector;
public class UserDao {
    //check login
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
    public User findById(int id) {
        String sql = "SELECT * FROM `user` WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).bind("id", id).mapToBean(User.class).findFirst().orElse(null));
    }
    public boolean updateProfile(User user) {
        String sql = """
                    
                UPDATE user SET full_name = :fullName, email = :email, phone_number = :phone, gender = :gender WHERE id = :id """;
        try {
            Handle handle = JdbiConnector.getJdbi().open();
            int rows = handle.createUpdate( sql).bind("fullName",user.getFullName())
                    .bind("email" ,user.getEmail())
                    .bind("phone", user.getPhoneNumber())
                    .bind("gender",user.getGender())
                    .bind("id", user.getId())
                    .execute();
            return (rows > 0);

    } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    public boolean updateAvatar(int userId, String avatar) {
        String sql = """
                UPDATE user SET avatar = :avatar
                WHERE id = :id
        """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(sql).bind("avatar",avatar).bind("id",userId).execute())>0;
    }
}
