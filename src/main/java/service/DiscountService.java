package service;

import dao.DiscountDao;
import model.Discount;

import java.util.List;

public class DiscountService {
    private DiscountDao discountDao;

    public DiscountService() {
        this.discountDao = new DiscountDao();
    }
    public List<Discount> getAllDiscounts() {
        return discountDao.getAllDiscounts();
    }
}
