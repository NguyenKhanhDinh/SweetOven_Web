package service;

import dao.UserFavoritesDao;

public class UserFavoriteService {
    UserFavoritesDao userFavoritesDao = new UserFavoritesDao() ;

    public boolean removeFavorites(int productId, int userId){
        return userFavoritesDao.removeUserFavorites(productId,userId);
    }
}
