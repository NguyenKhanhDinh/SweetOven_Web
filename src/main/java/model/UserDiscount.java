package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class UserDiscount extends Discount implements Serializable {
    private int userDiscountId;
    private int userId;
    private boolean isUsed;
    private LocalDateTime savedAt;

    public  UserDiscount() {}

    public int getUserDiscountId() {
        return userDiscountId;
    }
    public void setUserDiscountId(int userDiscountId) {
        this.userDiscountId = userDiscountId;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public boolean isUsed() {
        return isUsed;
    }
    public void setUsed(boolean used) {
        isUsed = used;
    }
    public LocalDateTime getSavedAt() {
        return savedAt;
    }
    public void setSavedAt(LocalDateTime savedAt) {
        this.savedAt = savedAt;
    }
    public String getStatusLable(){
        if(isUsed) return "Đã sử dụng!";
        if(!isValid()) return "Hết hạn!";
        return "Còn hiệu lực!";
    }
    public String getStatusClass(){
        if(isUsed) return "bg-secondary";
        if(!isValid()) return "bg-danger";
        return "bg-success";
    }

}
