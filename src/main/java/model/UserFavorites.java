package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class UserFavorites implements Serializable {
    private int id;
    private int userId;
    private int productId;
    private LocalDateTime createdAt;

    public UserFavorites() {
    }

    public UserFavorites(int id, int userId, int productId, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.createdAt = createdAt;
    }
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
    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
