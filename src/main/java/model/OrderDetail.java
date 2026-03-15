package model;

import java.math.BigDecimal;

public class OrderDetail {
private int id;
private int orderId;
private int productId;
private String productName;
private BigDecimal buyPrice;
private int quantity;
private BigDecimal totalPrice;
private Deprecated createdAt;
private Deprecated updatedAt;

public int getId() {
return id;
}
public void setId(int id) {
this.id = id;
}
public int getOrderId() {
    return orderId;
}
public void setOrderId(int orderId) {
    this.orderId = orderId;
}
public int getProductId() {
    return productId;
}
public void setProductId(int productId) {
    this.productId = productId;
}
public String getProductName() {
    return productName;
}
public void setProductName(String productName) {
    this.productName = productName;
}
public BigDecimal getBuyPrice() {
    return buyPrice;
}
public void setBuyPrice(BigDecimal buyPrice) {
    this.buyPrice = buyPrice;
}
public int getQuantity() {
    return quantity;
}
public void setQuantity(int quantity) {
    this.quantity = quantity;
}
public BigDecimal getTotalPrice() {
    return totalPrice;
}
public void setTotalPrice(BigDecimal totalPrice) {
    this.totalPrice = totalPrice;
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
