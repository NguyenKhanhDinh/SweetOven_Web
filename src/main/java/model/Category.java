package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Category implements Serializable {
    private int id;
    private String name;
    private int status;
    private String description;
    private String thumbnail;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private int productCount;

    public Category(int id, String name,int status, String description, String thumbnail, LocalDateTime createdAt, LocalDateTime updatedAt, int productCount) {
        this.id = id;
        this.name = name;
        this.status = status;
        this.description = description;
        this.thumbnail = thumbnail;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.productCount = productCount;
    }
    public Category() {}
    public int getProductCount() {
        return productCount;
    }
    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getThumbnail() {
        return thumbnail;
    }
    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
