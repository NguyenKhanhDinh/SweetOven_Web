package model;

import java.io.Serializable;

public class ProductImage implements Serializable {
    private int id;
    private int productId;
    private String imageUrl;
    private boolean isPrimary;

    public ProductImage(int id, int productId, String imageUrl, boolean isPrimary) {
        this.id = id;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.isPrimary = false;
    }
    public ProductImage(){}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        imageUrl = imageUrl;
    }
    public boolean isPrimary() {
        return isPrimary;
    }
    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }
}
