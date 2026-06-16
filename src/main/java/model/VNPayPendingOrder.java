package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

public class VNPayPendingOrder implements Serializable {
    public String orderCode;
    public User user;
    public Integer userId;
    public String guestEmail;
    public String fullName;
    public String phone;
    public String fullAddr;
    public String ward;
    public String district;
    public String province;
    public String note;
    public int ghnDistrictId;
    public String ghnWardCode;
    public Integer discountId;
    public BigDecimal subTotal;
    public BigDecimal discountAmount;
    public BigDecimal shippingFee;
    public BigDecimal totalAmount;
    public List<CartItem> checkoutItems;
    public String checkoutSelectedIds;
}