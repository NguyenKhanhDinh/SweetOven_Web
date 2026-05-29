package service;

import dao.DiscountDao;
import model.Discount;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class DiscountService {
    private DiscountDao discountDao = new DiscountDao();

    //get all discounts for homepage
    public List<Discount> getAllDiscounts() {
        List<Discount> allDiscounts = discountDao.getAllDiscounts();
        LocalDateTime now = LocalDateTime.now();

        return allDiscounts.stream()
                .filter(discount -> {
                    // Kiểm tra start_date
                    boolean startValid = discount.getStartDate() == null ||
                            discount.getStartDate().isBefore(now);
                    // Kiểm tra end_date
                    boolean endValid = discount.getEndDate() == null ||
                            discount.getEndDate().isAfter(now);
                    return startValid && endValid;
                })
                .collect(Collectors.toList());
    }

    // Lấy discount đang hiệu lực cho sản phẩm
    public List<Discount> getValidDiscountsForProductPrice(java.math.BigDecimal price) {
        List<Discount> allDiscounts = discountDao.getAllDiscounts();
        LocalDateTime now = LocalDateTime.now();

        return allDiscounts.stream()
                .filter(discount -> {
                    boolean startValid = discount.getStartDate() == null ||
                            discount.getStartDate().isBefore(now);
                    boolean endValid = discount.getEndDate() == null ||
                            discount.getEndDate().isAfter(now);
                    // Kiểm tra giá trị đơn hàng tối thiểu
                    boolean minOrderValid = discount.getMinValueOrder() == null ||
                            price.compareTo(discount.getMinValueOrder()) >= 0;
                    return startValid && endValid && minOrderValid;
                })
                .collect(Collectors.toList());
    }

    public Discount getDiscountByCode(String code) {
        return discountDao.getDiscountByCode(code);
    }

    public Discount getDiscountById(int id) {
        return discountDao.getDiscountById(id);
    }

    public BigDecimal calculateDiscountAmount(Discount discount, BigDecimal subToTal) {
        if (discount == null) return null;
        if (!discount.isValid()) return null;
        if (discount.getMinValueOrder() != null && subToTal.compareTo(discount.getMinValueOrder()) < 0) return null;
        if (discount.getDiscountType() == 1) {
            return subToTal.multiply(discount.getValue().divide(BigDecimal.valueOf(100)));
        } else {
            BigDecimal amt = discount.getValue();
            return amt.compareTo(subToTal) > 0 ? subToTal : amt;
        }
    }
}
