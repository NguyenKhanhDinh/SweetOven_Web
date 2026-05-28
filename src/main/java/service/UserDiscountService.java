package service;

import dao.UserDiscountDao;
import model.UserDiscount;

import java.util.List;

public class UserDiscountService {
    UserDiscountDao userDiscountDao = new UserDiscountDao();

    public List<UserDiscount> getSavedDiscounts(int userId) {
        return userDiscountDao.getSavedDiscounts(userId);
    }

    public List<Integer> getSavedDiscountIds(int userId) {
        return userDiscountDao.getSavedDiscountIds(userId);
    }

    public boolean isAlreadySaved(int userId, int discountId) {
        return userDiscountDao.isAlreadySaved(userId, discountId);
    }

    public boolean saveDiscount(int userId, int discountId) {
        if (isAlreadySaved(userId, discountId)) {
            return false;
        }
        return userDiscountDao.saveDiscount(userId, discountId);
    }

    public boolean markAsUsed(int userId, int discountId) {
        return userDiscountDao.markAsUsed(userId, discountId);
    }

}
