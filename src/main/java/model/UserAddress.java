package model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class UserAddress implements Serializable {
    private int id;
    private int userId;
    private String addressDetail;
    private String ward;
    private String district;
    private String province;
    private boolean isDefault;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Double lat;
    private Double lng;

    public UserAddress(int id, int userId, String addressDetail, String ward, String district, String province, boolean isDefault, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.userId = userId;
        this.addressDetail = addressDetail;
        this.ward = ward;
        this.district = district;
        this.province = province;
        this.isDefault = isDefault;
        this.createdAt = createdAt;
    }
    public UserAddress(){}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getAddressDetail() {
        return addressDetail;
    }
    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }
    public String getWard() {
        return ward;
    }
    public void setWard(String ward) {
        this.ward = ward;
    }
    public String getDistrict() {
        return district;
    }
    public void setDistrict(String district) {
        this.district = district;
    }
    public String getProvince() {
        return province;
    }
    public void setProvince(String province) {
        this.province = province;
    }
    public boolean isDefault() {
        return isDefault;
    }
    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }
    public boolean getIsDefault() {return isDefault;}
    public void setIsDefault(boolean isDefault) { this.isDefault = isDefault; }
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
    public Double getLat() {return lat;}
    public void setLat(Double lat) {this.lat = lat;}
    public Double getLng() {return lng;}
    public void setLng(Double lng) {this.lng = lng;}
}
