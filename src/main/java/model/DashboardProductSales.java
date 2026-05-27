package model;

import java.math.BigDecimal;

public class DashboardProductSales {
    private int id;
    private String name;
    private String productCode;
    private String image;
    private int totalSold;
    private BigDecimal totalRevenue;

    public DashboardProductSales() {}
    public DashboardProductSales(int id, String name, String productCode, String image, int totalSold, BigDecimal totalRevenue) {
        this.id = id; this.name = name; this.productCode = productCode; this.image = image;
        this.totalSold = totalSold; this.totalRevenue = totalRevenue;
    }
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public int getTotalSold() { return totalSold; }
    public void setTotalSold(int totalSold) { this.totalSold = totalSold; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
}