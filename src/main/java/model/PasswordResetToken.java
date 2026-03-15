package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class PasswordResetToken implements Serializable {
    private int id;
    private int userId;
    private String resetToken;
    private LocalDateTime expiredAt;
    private LocalDateTime createdAt;

public PasswordResetToken(int id, int userId, String resetToken, LocalDateTime expiredAt, LocalDateTime createdAt) {
    this.id = id;
    this.userId = userId;
    this.resetToken = resetToken;
    this.expiredAt = expiredAt;
    this.createdAt = createdAt;
}
public PasswordResetToken() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getResetToken() {
        return resetToken;
    }
    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }
    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }
    public void setExpiredAt(LocalDateTime expiredAt) {
        this.expiredAt = expiredAt;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
