package service;

import dao.UserDiscountDao;
import model.UserDiscount;

import java.util.List;

public class UserDiscountService {
    UserDiscountDao userDiscountDao = new UserDiscountDao();
    public List<UserDiscount> getSavedDiscounts(int userId){
        return userDiscountDao.getSavedDiscounts(userId);
    }
}
