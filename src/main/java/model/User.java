package model;

public class User {
    private int id;
    private String avatar;
    private String fullName;
    private String userName;
    private int gender;
    private String eamil;
    private String phoneNumber;
    private String password;
    private int status;
    private boolean isBlocked;
    private int roleId;
    private  Deprecated createdAt;
    private  Deprecated updatedAt;

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
    public String getEamil() {
        return eamil;
    }
    public void setEamil(String eamil) {
        this.eamil = eamil;
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
    public void setBlocked(boolean blocked) {
        isBlocked = blocked;
    }
    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }
    public Deprecated getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Deprecated createdAt) {
        this.createdAt = createdAt;
    }
    public Deprecated getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Deprecated updatedAt) {
        this.updatedAt = updatedAt;
    }
}
