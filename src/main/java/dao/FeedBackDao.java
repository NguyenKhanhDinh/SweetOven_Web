package dao;

import model.FeedBack;
import org.jdbi.v3.core.Handle;
import utils.JdbiConnector;

import java.time.LocalDateTime;
import java.util.List;

public class FeedBackDao {

    public boolean insert(FeedBack feedBack) {
        String sql = """
                    INSERT INTO feedback(full_name, email, phone_number, content, created_at, 
                                         sentiment, sentiment_analyzed_at)
                    VALUES (:fullName, :email, :phoneNumber, :content, NOW(), 
                           :sentiment, :sentimentAnalyzedAt)
                """;
        try (Handle handle = JdbiConnector.getJdbi().open()) {
            int rows = handle.createUpdate(sql)
                    .bind("fullName", feedBack.getFullName())
                    .bind("email", feedBack.getEmail())
                    .bind("phoneNumber", feedBack.getPhoneNumber())
                    .bind("content", feedBack.getContent())
                    .bind("sentiment", feedBack.getSentiment())
                    .bind("sentimentAnalyzedAt", feedBack.getSentimentAnalyzedAt())
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

    // Only get positive feedbacks for homepage - optimized with LIMIT
    public List<FeedBack> getPositiveFeedbacks(int limit) {
        String sql = """
                    SELECT * FROM feedback 
                    WHERE sentiment = 'POSITIVE' 
                    ORDER BY created_at DESC 
                    LIMIT :limit
                    """;
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .mapToBean(FeedBack.class)
                        .list()
        );
    }

    public boolean updateSentiment(int feedbackId, String sentiment, LocalDateTime analyzedAt) {
        String sql = """
                    UPDATE feedback 
                    SET sentiment = :sentiment, sentiment_analyzed_at = :analyzedAt 
                    WHERE id = :id
                    """;
        try (Handle handle = JdbiConnector.getJdbi().open()) {
            int rows = handle.createUpdate(sql)
                    .bind("sentiment", sentiment)
                    .bind("analyzedAt", analyzedAt)
                    .bind("id", feedbackId)
                    .execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Update sentiment failed", e);
        }
    }
}