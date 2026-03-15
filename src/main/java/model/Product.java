package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;


public class Product {
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
    private Deprecated createdAt;
    private Deprecated updatedAt;
    private List<ProductImage> listImages = new ArrayList<>();

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
    public List<ProductImage> getListImages() {
        return listImages;
    }
    public void setListImages(List<ProductImage> listImages) {
        this.listImages = listImages;
    }
}

