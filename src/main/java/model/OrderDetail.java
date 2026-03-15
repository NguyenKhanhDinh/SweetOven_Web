package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class OrderDetail implements Serializable {
private int id;
private int orderId;
private int productId;
private String productName;
private BigDecimal buyPrice;
private int quantity;
private BigDecimal totalPrice;
private LocalDateTime createdAt;
private LocalDateTime updatedAt;

public OrderDetail(int id, int orderId, int productId, String productName, BigDecimal buyPrice, int quantity, BigDecimal totalPrice, LocalDateTime createdAt, LocalDateTime updatedAt) {
    this.id = id;
    this.orderId = orderId;
    this.productId = productId;
    this.productName = productName;
    this.buyPrice = buyPrice;
    this.quantity = quantity;
    this.totalPrice = totalPrice;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
}

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
