package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Discount implements Serializable {
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


    public Discount() {}
    public Discount(int id, String code, String description, int discountType, BigDecimal value, BigDecimal minValueOrder, LocalDateTime startDate, LocalDateTime endDate, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.code = code;
        this.description = description;
        this.discountType = discountType;
        this.value = value;
        this.minValueOrder = minValueOrder;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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
    public String getFormattedEndDate() {
        if (this.endDate != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return this.endDate.format(formatter);
        }
        return "Chưa có ngày kết thúc";
    }
    public boolean isValid() {
        LocalDateTime now = LocalDateTime.now();
        return (startDate == null || now.isAfter(startDate)) &&
                (endDate == null || now.isBefore(endDate));
    }

    public String getFormattedStartDate() {
        if (this.startDate != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            return this.startDate.format(formatter);
        }
        return "Không có";
    }public String getDisplayValue() {
        if (discountType == 1) {
            return value.stripTrailingZeros().toPlainString() + "%";
        } else {
            return String.format("%,.0f VNĐ", value);
        }
    }

    public String getDisplayMinOrder() {
        if (minValueOrder == null || minValueOrder.compareTo(BigDecimal.ZERO) == 0) {
            return "0đ";
        }
        return String.format("%,.0fđ", minValueOrder);
    }
    public boolean isPercentage() {
        return discountType == 1;
    }
    public String getIconClass() {
        return discountType == 1 ? "fa-percent" : "fa-hand-holding-usd";
    }
    public String getDisplayTitle() {
        return discountType == 1 ? "Ưu Đãi Đặc Biệt" : "Giảm Trực Tiếp";
    }



}
