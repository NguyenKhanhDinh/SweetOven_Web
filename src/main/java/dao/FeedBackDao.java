package dao;

import model.FeedBack;
import org.jdbi.v3.core.Handle;
import utils.JdbiConnector;

import java.util.List;

public class FeedBackDao {
    public boolean insert(FeedBack feedBack) {
        String sql = """
                    INSERT INTO feedback(full_name, email, phone_number, content, created_at)
                    VALUES (:fullName,:email,:phoneNumber,:content, NOW())
                """;
        try (Handle handle = JdbiConnector.getJdbi().open()) {
            int rows = handle.createUpdate(sql).bind("fullName", feedBack.getFullName())
                    .bind("email", feedBack.getEmail())
                    .bind("phoneNumber", feedBack.getPhoneNumber())
                    .bind("content", feedBack.getContent())
                    .execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Insert feedback failed", e);
        }
    }
    public List<FeedBack> getAllFeedbacks() {
        String sql = "SELECT * FROM feedback ORDER BY created_at DESC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapToBean(FeedBack.class).list()
        );
    }
}
