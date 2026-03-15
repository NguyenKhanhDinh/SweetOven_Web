package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Category implements Serializable {
    private int id;
    private String name;
    private String description;
    private String thumnail;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Category(int id, String name, String description, String thumnail, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.thumnail = thumnail;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    public Category() {}

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
    public String getThumnail() {
        return thumnail;
    }
    public void setThumnail(String thumnail) {
        this.thumnail = thumnail;
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
