package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class FeedBack implements Serializable {
private int id;
private String fullName;
private String email;
private String phoneNumber;
private String content;
private LocalDateTime createdAt;
private String reply;
private LocalDateTime repliedAt;
private String repliedBy;
private String status; // 'pending', 'replied'private String externalReplyStatus; // 'pending', 'opened', 'replied'
public  FeedBack(int id, String fullName, String email, String phoneNumber, String content, LocalDateTime createdAt) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.content = content;
    this.createdAt = createdAt;

}
public FeedBack() {}


    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
    }

}
