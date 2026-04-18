package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private int quantity;
    private BigDecimal price;
    private Product product;
    private String imageUrl;

    public CartItem() {}

    public CartItem(int quantity, BigDecimal price, Product product, String imageUrl) {
        this.quantity = quantity;
        this.price = price;
        this.product = product;
        this.imageUrl = imageUrl;
    }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public void upQuantity(int quantity) {
        this.quantity += quantity;
    }

    public BigDecimal getTotalItemPrice() {
        if (this.price == null) return BigDecimal.ZERO;
        return this.price.multiply(new BigDecimal(this.quantity));
    }
}