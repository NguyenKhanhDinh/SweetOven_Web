package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class FeedBack implements Serializable {
    private int id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String content;
    private String reply;
    private LocalDateTime repliedAt;
    private String repliedBy;
    private LocalDateTime createdAt;
    private String sentiment;
    private LocalDateTime sentimentAnalyzedAt;
    private String status; // 'pending', 'replied'
    private String externalReplyStatus; // 'pending', 'opened', 'replied'
    public FeedBack() {}
    public FeedBack(int id, String fullName, String email, String phoneNumber,
                    String content, LocalDateTime createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.content = content;
        this.createdAt = createdAt;
    }
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public LocalDateTime getRepliedAt() { return repliedAt; }
    public void setRepliedAt(LocalDateTime repliedAt) { this.repliedAt = repliedAt; }
    public String getRepliedBy() { return repliedBy; }
    public void setRepliedBy(String repliedBy) { this.repliedBy = repliedBy; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getSentiment() { return sentiment; }
    public void setSentiment(String sentiment) { this.sentiment = sentiment; }
    public LocalDateTime getSentimentAnalyzedAt() { return sentimentAnalyzedAt; }
    public void setSentimentAnalyzedAt(LocalDateTime sentimentAnalyzedAt) { this.sentimentAnalyzedAt = sentimentAnalyzedAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getExternalReplyStatus() { return externalReplyStatus; }
    public void setExternalReplyStatus(String externalReplyStatus) { this.externalReplyStatus = externalReplyStatus; }
}