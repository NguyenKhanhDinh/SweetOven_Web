package service;

import dao.UserDao;
import model.User;

public class UserService {
    private UserDao userDao = new UserDao();
    //for login
    public User login(String username, String password) {
        if(username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return null;
        }
        return userDao.login(username, password);
    }

}
