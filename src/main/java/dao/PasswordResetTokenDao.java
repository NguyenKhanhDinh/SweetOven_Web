package dao;

import model.PasswordResetToken;
import utils.JdbiConnector;

import java.time.LocalDateTime;

public class PasswordResetTokenDao {
    public boolean deleteByUserId(int userId) {
        String sql = "DELETE FROM password_reset_token WHERE user_id = :userId";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("userId", userId).execute()) >= 0;
    }

    public boolean insertToken(int userId, String token, LocalDateTime expiredAt) {
        String sql = "INSERT INTO password_reset_token(user_id, reset_token, expired_at,created_at) " +
                "VALUES (:userId, :token, :expiredAt, NOW())";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("userId", userId).bind("token", token).bind("expiredAt", expiredAt).execute()) > 0;
    }
    public PasswordResetToken findByToken(String token) {
        String sql ="SELECT id, user_id AS userId, reset_token AS resetToken, " +
                "expired_at AS expiredAt, created_at AS createdAt " +
                "FROM password_reset_token WHERE reset_token = :token";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("token", token).mapToBean(PasswordResetToken.class).findFirst().orElse(null));
    }
    public boolean deleteByToken(String token) {
        String sql = "DELETE FROM password_reset_token WHERE reset_token = :token";
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("token", token).execute()) > 0;
    }
}
