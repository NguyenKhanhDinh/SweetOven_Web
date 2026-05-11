package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class UserDiscount  implements Serializable {
    private int userDiscountId;
    private int userId;
    private boolean isUsed;
    private LocalDateTime savedAt;

    private int id;
    private String code;
    private String description;
    private int discountType;
    private BigDecimal value;
    private BigDecimal minValueOrder;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;


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
    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public LocalDateTime getSavedAt() {
        return savedAt;
    }
    public void setSavedAt(LocalDateTime savedAt) {
        this.savedAt = savedAt;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public int getDiscountType() {
        return discountType;
    }
    public void setDiscountType(int discountType) {
        this.discountType = discountType;
    }
    public BigDecimal getValue() {
        return value;
    }
    public void setValue(BigDecimal value) {
        this.value = value;
    }
    public BigDecimal getMinValueOrder() {
        return minValueOrder;
    }
    public void setMinValueOrder(BigDecimal minValueOrder) {
        this.minValueOrder = minValueOrder;
    }
    public LocalDateTime getStartDate() {
        return startDate;
    }
    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }
    public LocalDateTime getEndDate() {
        return endDate;
    }
    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
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
    public boolean isValid() {
        LocalDateTime now = LocalDateTime.now();
        return (startDate==null||now.isAfter(startDate)) && (endDate==null||now.isBefore(endDate));
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
    public String getFormattedEndDate() {
        if (endDate != null)
            return endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        return "Không có";
    }

    public String getDisplayValue() {
        if (discountType == 1)
            return value.stripTrailingZeros().toPlainString() + "%";
        return String.format("%,.0f VNĐ", value);
    }

    public String getDisplayMinOrder() {
        if (minValueOrder == null || minValueOrder.compareTo(BigDecimal.ZERO) == 0)
            return "0đ";
        return String.format("%,.0fVNĐ", minValueOrder);
    }

    public String getIconClass() {
        return discountType == 1 ? "fa-percent" : "fa-hand-holding-usd";
    }
}
