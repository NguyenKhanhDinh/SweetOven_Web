package dao;

import model.FeedBack;
import org.jdbi.v3.core.Handle;
import utils.JdbiConnector;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static utils.JdbiConnector.jdbi;

public class FeedBackDao {

    public boolean insert(FeedBack feedBack) {
        String sql = """
                    INSERT INTO feedback(full_name, email, phone_number, content, created_at, status, external_reply_status)
                    VALUES (:fullName, :email, :phoneNumber, :content, NOW(), 'pending', 'pending')
                """;
        try (Handle handle = JdbiConnector.getJdbi().open()) {
            int rows = handle.createUpdate(sql)
                    .bind("fullName", feedBack.getFullName())
                    .bind("email", feedBack.getEmail())
                    .bind("phoneNumber", feedBack.getPhoneNumber())
                    .bind("content", feedBack.getContent())
                    .execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Insert feedback failed", e);
        }
    }

    // Lấy danh sách feedback
    public List<FeedBack> findAllWithFilters(String keyword, String dateFrom, String dateTo,
                                             int offset, int limit) {
        StringBuilder sql = new StringBuilder("""
            SELECT id, full_name, email, phone_number, content, reply, replied_at, 
                   replied_by, created_at, sentiment, sentiment_analyzed_at, status, external_reply_status
            FROM feedback WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR content LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND DATE(created_at) >= ?");
            params.add(dateFrom);
        }

        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(dateTo);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Handle handle = jdbi.open()) {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }

            return query.map((rs, ctx) -> {
                FeedBack fb = new FeedBack(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("content"),
                        rs.getTimestamp("created_at") != null
                                ? rs.getTimestamp("created_at").toLocalDateTime()
                                : null
                );
                fb.setReply(rs.getString("reply"));
                fb.setRepliedAt(rs.getTimestamp("replied_at") != null
                        ? rs.getTimestamp("replied_at").toLocalDateTime() : null);
                fb.setRepliedBy(rs.getString("replied_by"));
                fb.setStatus(rs.getString("status"));
                fb.setExternalReplyStatus(rs.getString("external_reply_status"));
                fb.setSentiment(rs.getString("sentiment"));
                fb.setSentimentAnalyzedAt(rs.getTimestamp("sentiment_analyzed_at") != null
                        ? rs.getTimestamp("sentiment_analyzed_at").toLocalDateTime() : null);
                return fb;
            }).list();
        } catch (Exception e) {
            throw new RuntimeException("Find all feedbacks failed", e);
        }
    }

    // Đếm tổng số feedback
    public long countWithFilters(String keyword, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM feedback WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR content LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND DATE(created_at) >= ?");
            params.add(dateFrom);
        }

        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(dateTo);
        }

        try (Handle handle = jdbi.open()) {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.mapTo(Long.class).one();
        } catch (Exception e) {
            throw new RuntimeException("Count feedbacks failed", e);
        }
    }

    // Lấy tổng số feedback
    public long getTotalFeedbacks() {
        String sql = "SELECT COUNT(*) FROM feedback";
        try (Handle handle = jdbi.open()) {
            return handle.createQuery(sql).mapTo(Long.class).one();
        }
    }

    // Lấy số feedback hôm nay
    public long getTodayFeedbacks() {
        String sql = "SELECT COUNT(*) FROM feedback WHERE DATE(created_at) = CURDATE()";
        try (Handle handle = jdbi.open()) {
            return handle.createQuery(sql).mapTo(Long.class).one();
        }
    }

    // Lấy số feedback trong 7 ngày qua
    public long getWeekFeedbacks() {
        String sql = "SELECT COUNT(*) FROM feedback WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        try (Handle handle = jdbi.open()) {
            return handle.createQuery(sql).mapTo(Long.class).one();
        }
    }

    // Lấy số feedback trong tháng này
    public long getMonthFeedbacks() {
        String sql = "SELECT COUNT(*) FROM feedback WHERE MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())";
        try (Handle handle = jdbi.open()) {
            return handle.createQuery(sql).mapTo(Long.class).one();
        }
    }

    // Lấy số feedback chưa trả lời
    public long getPendingFeedbacks() {
        String sql = "SELECT COUNT(*) FROM feedback WHERE status = 'pending' OR status IS NULL";
        try (Handle handle = jdbi.open()) {
            return handle.createQuery(sql).mapTo(Long.class).one();
        }
    }

    // Lấy chi tiết feedback theo ID
    public FeedBack findById(int id) {
        String sql = """
            SELECT id, full_name, email, phone_number, content, reply, replied_at, 
                   replied_by, created_at, sentiment, sentiment_analyzed_at, status, external_reply_status 
            FROM feedback WHERE id = ?
        """;
        try (Handle handle = jdbi.open()) {
            return handle.createQuery(sql)
                    .bind(0, id)
                    .map((rs, ctx) -> {
                        FeedBack fb = new FeedBack(
                                rs.getInt("id"),
                                rs.getString("full_name"),
                                rs.getString("email"),
                                rs.getString("phone_number"),
                                rs.getString("content"),
                                rs.getTimestamp("created_at") != null
                                        ? rs.getTimestamp("created_at").toLocalDateTime()
                                        : null
                        );
                        fb.setReply(rs.getString("reply"));
                        fb.setRepliedAt(rs.getTimestamp("replied_at") != null
                                ? rs.getTimestamp("replied_at").toLocalDateTime() : null);
                        fb.setRepliedBy(rs.getString("replied_by"));
                        fb.setStatus(rs.getString("status"));
                        fb.setExternalReplyStatus(rs.getString("external_reply_status"));
                        fb.setSentiment(rs.getString("sentiment"));
                        fb.setSentimentAnalyzedAt(rs.getTimestamp("sentiment_analyzed_at") != null
                                ? rs.getTimestamp("sentiment_analyzed_at").toLocalDateTime() : null);
                        return fb;
                    })
                    .findOne()
                    .orElse(null);
        } catch (Exception e) {
            throw new RuntimeException("Find feedback by id failed", e);
        }
    }

    // Cập nhật đã
    public boolean updateExternalReplyStatusOpened(int id) {
        String sql = "UPDATE feedback SET external_reply_status = 'opened' WHERE id = ?";
        try (Handle handle = jdbi.open()) {
            int rows = handle.createUpdate(sql).bind(0, id).execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Update external reply status failed", e);
        }
    }

    // Cập nhật trạng thái đã trả lời
    public boolean updateRepliedStatus(int id, String replyContent, String repliedBy) {
        String sql = """
            UPDATE feedback 
            SET reply = ?, replied_at = NOW(), replied_by = ?, 
                status = 'replied', external_reply_status = 'replied'
            WHERE id = ?
        """;
        try (Handle handle = jdbi.open()) {
            int rows = handle.createUpdate(sql)
                    .bind(0, replyContent)
                    .bind(1, repliedBy)
                    .bind(2, id)
                    .execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Update replied status failed", e);
        }
    }

    //Cập nhật các feedback đ phản hồi dành cho admin
    public boolean updateExternalReplyStatusReplied(int id) {
        String sql = "UPDATE feedback SET external_reply_status = 'replied' WHERE id = ?";
        try (Handle handle = jdbi.open()) {
            int rows = handle.createUpdate(sql).bind(0, id).execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Update external reply status failed", e);
        }
    }

    // Xóa feedback
    public boolean deleteById(int id) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        try (Handle handle = jdbi.open()) {
            int rows = handle.createUpdate(sql).bind(0, id).execute();
            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("Delete feedback failed", e);
        }
    }
//Xất excel
    public List<FeedBack> findAllForExport(String keyword, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("""
        SELECT id, full_name, email, phone_number, content, reply, replied_at, 
               replied_by, created_at, sentiment, sentiment_analyzed_at, status, external_reply_status
        FROM feedback WHERE 1=1
    """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR content LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND DATE(created_at) >= ?");
            params.add(dateFrom);
        }

        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND DATE(created_at) <= ?");
            params.add(dateTo);
        }

        sql.append(" ORDER BY created_at DESC");

        try (Handle handle = jdbi.open()) {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }

            return query.map((rs, ctx) -> {
                FeedBack fb = new FeedBack(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("content"),
                        rs.getTimestamp("created_at") != null
                                ? rs.getTimestamp("created_at").toLocalDateTime()
                                : null
                );
                fb.setReply(rs.getString("reply"));
                fb.setRepliedAt(rs.getTimestamp("replied_at") != null
                        ? rs.getTimestamp("replied_at").toLocalDateTime() : null);
                fb.setRepliedBy(rs.getString("replied_by"));
                fb.setStatus(rs.getString("status"));
                fb.setExternalReplyStatus(rs.getString("external_reply_status"));
                fb.setSentiment(rs.getString("sentiment"));
                fb.setSentimentAnalyzedAt(rs.getTimestamp("sentiment_analyzed_at") != null
                        ? rs.getTimestamp("sentiment_analyzed_at").toLocalDateTime() : null);
                return fb;
            }).list();
        } catch (Exception e) {
            throw new RuntimeException("Find all feedbacks for export failed", e);
        }
    }
}