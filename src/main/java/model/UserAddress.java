package model;

public class UserAddress {
    private int id;
    private int userId;
    private String addressDetail;
    private String ward;
    private String district;
    private String province;
    private boolean isDefault;
    private Deprecated createdAt;
    private Deprecated updatedAt;
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
    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
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
