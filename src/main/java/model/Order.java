package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class Order implements Serializable {
    private int id;
    private String orderCode;
    private Integer userId;
    private String fullName;
    private String phoneNumber;
    private String address;
    private Integer discountId;
    private BigDecimal subTotal;
    private BigDecimal discountAmount;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount;
    private String note;
    private int paymentMethod;
    private int orderStatus;
    private LocalDateTime orderDate;
    private  LocalDateTime updatedAt;

    public Order(int id,String orderCode,Integer userId,String fullName,String phoneNumber,String address,Integer discountId,BigDecimal subTotal
    ,BigDecimal discountAmount,BigDecimal shippingFee,BigDecimal totalAmount,String note,int paymentMethod,int orderStatus,LocalDateTime orderDate,LocalDateTime updatedAt){
        this.id = id;
        this.orderCode = orderCode;
        this.userId = userId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.discountId = discountId;
        this.subTotal = subTotal;
        this.discountAmount = discountAmount;
        this.shippingFee = shippingFee;
        this.totalAmount = totalAmount;
        this.note = note;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.orderDate = orderDate;
        this.updatedAt = updatedAt;
    }
    public Order(){}

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
    public Integer getUserId() {
        return userId;
    }
    public void setUserId(Integer userId) {
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
    public Integer getDiscountId() {
        return discountId;
    }
    public void setDiscountId(Integer discountId) {
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
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(BigDecimal toltalAmount) {
        this.totalAmount = toltalAmount;
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
    public LocalDateTime getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getOrderDateFormatted() {
        if (orderDate == null) return "";
        return orderDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy "));
    }

    public String getUpdatedAtFormatted() {
        if (updatedAt == null) return "";
        return updatedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }


    private String formatMoney(BigDecimal value) {
        if (value == null) return "0 đ";

        NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));
        return nf.format(value) + " đ";
    }

    public String getSubTotalFormatted() {
        return formatMoney(subTotal);
    }

    public String getDiscountAmountFormatted() {
        return formatMoney(discountAmount);
    }

    public String getShippingFeeFormatted() {
        return formatMoney(shippingFee);
    }

    public String getTotalAmountFormatted() {
        return formatMoney(totalAmount);
    }
}
