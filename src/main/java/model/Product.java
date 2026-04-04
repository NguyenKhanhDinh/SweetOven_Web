package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


public class Product implements Serializable {
    private int id;
    private String productCode;
    private String productName;
    private int categoryId;
    private String name;
    private BigDecimal price;
    private int stockQuantity;
    private int status;
    private String description;
    private String ingredients;
    private boolean featured;
    private String image;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<ProductImage> listImages = new ArrayList<>();
    private BigDecimal discountedPrice;
    private Discount activeDiscount;
    private BigDecimal discountPercent;

    public  Product(int id, String productCode, int categoryId, String name, double price, int stock_quantity,
                    int status, String description, String ingredients) {
        this.id = id;
        this.productCode = productCode;
        this.categoryId = categoryId;
        this.name = name;
        this.price = new BigDecimal(price);
        this.stockQuantity = stock_quantity;
        this.status = status;
        this.description = description;
        this.ingredients = ingredients;
        this.featured = false;
    }
    public Product(){}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getProductCode() {
        return productCode;
    }
    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }
    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }
    public int getCategoryId() {
        return categoryId;
    }
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public BigDecimal getPrice() {
        return price;
    }
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    public int getStockQuantity() {
        return stockQuantity;
    }
    public void setStockQuantity(int stock_quantity) {
        this.stockQuantity = stock_quantity;
    }
    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getIngredients() {
        return ingredients;
    }
    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }
    public boolean isFeatured() {
        return featured;
    }
    public void setFeatured(boolean featured) {
        this.featured = featured;
    }
    public  String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
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
    public List<ProductImage> getListImages() {
        return listImages;
    }
    public void setListImages(List<ProductImage> listImages) {
        this.listImages = listImages;
    }
    public BigDecimal getDiscountedPrice() {
        return discountedPrice;
    }
    public void setDiscountedPrice(BigDecimal discountedPrice) {
        this.discountedPrice = discountedPrice;
    }
    public Discount getActiveDiscount() {
        return activeDiscount;
    }
    public void setActiveDiscount(Discount activeDiscount) {
        this.activeDiscount = activeDiscount;
        if (activeDiscount != null && activeDiscount.isValid()) {
            calculateDiscountedPrice();
        }
    }
    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }
    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }
    // Tính giá sau khi giảm
    private void calculateDiscountedPrice() {
        if (activeDiscount == null || !activeDiscount.isValid()) {
            this.discountedPrice = this.price;
            this.discountPercent = BigDecimal.ZERO;
            return;
        }

        if (activeDiscount.isPercentage()) {
            BigDecimal discountValue = this.price.multiply(activeDiscount.getValue())
                    .divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
            this.discountedPrice = this.price.subtract(discountValue);
            this.discountPercent = activeDiscount.getValue(); // Lưu % giảm
        } else {
            BigDecimal discountAmount = activeDiscount.getValue();
            if (discountAmount.compareTo(this.price) >= 0) {
                this.discountedPrice = BigDecimal.ZERO;
                this.discountPercent = new BigDecimal(100);
            } else {
                this.discountedPrice = this.price.subtract(discountAmount);
                // Tính phần trăm giảm tương đương
                this.discountPercent = discountAmount
                        .multiply(new BigDecimal(100))
                        .divide(this.price, 0, RoundingMode.HALF_UP);
            }
        }

        if (this.discountedPrice.compareTo(BigDecimal.ZERO) < 0) {
            this.discountedPrice = BigDecimal.ZERO;
        }
    }

    public boolean hasDiscount() {
        return activeDiscount != null && activeDiscount.isValid() &&
                discountedPrice != null &&
                discountedPrice.compareTo(BigDecimal.ZERO) >= 0 &&
                discountedPrice.compareTo(price) < 0;
    }

    public int getDiscountPercentInt() {
        if (discountPercent == null || !hasDiscount()) {
            return 0;
        }
        return discountPercent.intValue();
    }


    public BigDecimal getSavedAmount() {
        if (hasDiscount()) {
            return price.subtract(discountedPrice);
        }
        return BigDecimal.ZERO;
    }

    // Format giá gốc
    public String getFormattedPrice() {
        return String.format("%,.0f VNĐ", price);
    }

    // Format giá sau giảm
    public String getFormattedDiscountedPrice() {
        if (hasDiscount()) {
            return String.format("%,.0f VNĐ", discountedPrice);
        }
        return getFormattedPrice();
    }
}

