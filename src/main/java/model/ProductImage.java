package model;

import java.io.Serializable;

public class ProductImage implements Serializable {
    private int id;
    private int productId;
    private String ImageUrl;
    private boolean isPrimary;

    public ProductImage(int id, int productId, String ImageUrl, boolean isPrimary) {
        this.id = id;
        this.productId = productId;
        this.ImageUrl = ImageUrl;
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
        return ImageUrl;
    }
    public void setImageUrl(String imageUrl) {
        ImageUrl = imageUrl;
    }
    public boolean isPrimary() {
        return isPrimary;
    }
    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }
}
