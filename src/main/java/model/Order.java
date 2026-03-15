package model;

import java.math.BigDecimal;

public class Order {
    private int id;
    private String orderCode;
    private int userId;
    private String fullName;
    private String phoneNumber;
    private String address;
    private int discountId;
    private BigDecimal subTotal;
    private BigDecimal discountAmount;
    private BigDecimal shippingFee;
    private BigDecimal toltalAmount;
    private String note;
    private int paymentMethod;
    private int orderStatus;
    private  Deprecated orderDate;
    private  Deprecated updatedAt;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getOrderCode() {
        return orderCode;
    }
    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public int getDiscountId() {
        return discountId;
    }
    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }
    public BigDecimal getSubTotal() {
        return subTotal;
    }
    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal;
    }
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    public BigDecimal getShippingFee() {
        return shippingFee;
    }
    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }
    public BigDecimal getToltalAmount() {
        return toltalAmount;
    }
    public void setToltalAmount(BigDecimal toltalAmount) {
        this.toltalAmount = toltalAmount;
    }
    public String getNote() {
        return note;
    }
    public void setNote(String note) {
        this.note = note;
    }
    public int getPaymentMethod() {
        return paymentMethod;
    }
    public void setPaymentMethod(int paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    public int getOrderStatus() {
        return orderStatus;
    }
    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }
    public Deprecated getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(Deprecated orderDate) {
        this.orderDate = orderDate;
    }
    public Deprecated getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Deprecated updatedAt) {
        this.updatedAt = updatedAt;
    }
}
