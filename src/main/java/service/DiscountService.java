package service;

import dao.DiscountDao;
import model.Discount;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class DiscountService {
    private DiscountDao discountDao = new  DiscountDao();

    //get all discounts for homepage
    public List<Discount> getAllDiscounts() {
        List<Discount> allDiscounts = discountDao.getAllDiscounts();
        LocalDateTime now = LocalDateTime.now();

        return allDiscounts.stream()
                .filter(discount -> discount.getEndDate() == null || discount.getEndDate().isAfter(now))
                .collect(Collectors.toList());
    }
}
