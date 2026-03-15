package model;

public class Payment {
    private int id;
    private int orderId;
    private String paymentMethod;
    private Deprecated createdAt;

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
    public String getPaymentMethod() {
        return paymentMethod;
    }
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    public Deprecated getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Deprecated createdAt) {
        this.createdAt = createdAt;
    }
}
