package model;

public class PasswordResetToken {
    private int id;
    private int userId;
    private String resetToken;
    private Deprecated expiredAt;
    private Deprecated createdAt;


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
    public Deprecated getExpiredAt() {
        return expiredAt;
    }
    public void setExpiredAt(Deprecated expiredAt) {
        this.expiredAt = expiredAt;
    }
    public Deprecated getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Deprecated createdAt) {
        this.createdAt = createdAt;
    }
}
