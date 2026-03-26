package service;

import dao.DiscountDao;
import model.Discount;

import java.util.List;

public class DiscountService {
    private DiscountDao discountDao = new  DiscountDao();

    //get all discounts for homepage
    public List<Discount> getAllDiscounts() {
        return discountDao.getAllDiscounts();
    }
}
