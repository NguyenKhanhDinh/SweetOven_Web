package model;
import java.io.Serializable;
import java.time.LocalDateTime;

public class User implements Serializable {
    private int id;
    private String avatar;
    private String fullName;
    private String userName;
    private int gender;
    private String email;
    private String phoneNumber;
    private String password;
    private int status;
    private boolean isBlocked;
    private int roleId;
    private LocalDateTime createdAt;
    private  LocalDateTime updatedAt;

    public User(int id, String avatar, String fullName, String userName, int gender, String email,String phoneNumber,String password,int status,boolean isBlocked,int roleId,LocalDateTime createdAt,LocalDateTime updatedAt) {
        this.id = id;
        this.avatar = avatar;
        this.fullName = fullName;
        this.userName = userName;
        this.gender = gender;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.status = status;
        this.isBlocked = isBlocked;
        this.roleId = roleId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    public User() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getAvatar() {
        return avatar;
    }
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
    public int getGender() {
        return gender;
    }
    public void setGender(int gender) {
        this.gender = gender;
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
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }
    public boolean isBlocked() {
return isBlocked;
    }
    public boolean getBlocked() {
        return isBlocked;
    }
    public void setBlocked(boolean blocked) {
        isBlocked = blocked;
    }
    public void setIsBlocked(boolean blocked) {
        isBlocked = blocked;
    }
    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
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