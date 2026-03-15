package model;

import java.math.BigDecimal;

public class Discount {
    private int id;
    private String code;
    private String description;
    private int discountType;
    private BigDecimal value;
    private BigDecimal minValueOrder;
    private Deprecated startDate;
    private Deprecated endDate;
    private Deprecated createdAt;
    private Deprecated updatedAt;

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
    public Deprecated getStartDate() {
        return startDate;
    }
    public void setStartDate(Deprecated startDate) {
        this.startDate = startDate;
    }
    public Deprecated getEndDate() {
        return endDate;
    }
    public void setEndDate(Deprecated endDate) {
        this.endDate = endDate;
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
