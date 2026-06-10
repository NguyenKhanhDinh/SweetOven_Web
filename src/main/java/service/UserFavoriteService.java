package service;

import dao.UserFavoritesDao;
import model.UserFavorites;

import java.util.List;

public class UserFavoriteService {
    UserFavoritesDao userFavoritesDao = new UserFavoritesDao() ;

    public boolean removeFavorites(int productId, int userId){
        return userFavoritesDao.removeUserFavorites(productId,userId);
    }
    public boolean addFavorite(int productId, int userId){
        return userFavoritesDao.addFavorite(productId,userId);
    }
    public boolean isFavorite(int productId, int userId){
        return userFavoritesDao.isFavorite(productId,userId);
    }
    public List<Integer> getFavoriteProductIds(int userId){
        return userFavoritesDao.getUserFavoritesProductIds(userId);
    }
    public List<UserFavorites> getUserFavorites(int userId){
        return userFavoritesDao.getUserFavoritesByUserId(userId);
    }

}
