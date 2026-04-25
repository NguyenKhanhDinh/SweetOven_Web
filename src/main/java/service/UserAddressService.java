package service;

import dao.UserAddressDao;
import model.UserAddress;

import java.util.List;

public class UserAddressService {
    UserAddressDao userAddressDao = new UserAddressDao();

    public List<UserAddress> getUserAddressByUserId(int userId) {
           return userAddressDao.findByUserId(userId);
    }
    public boolean addUserAddress(UserAddress userAddress) {
        return userAddressDao.insertUserAddress(userAddress);
    }
}
