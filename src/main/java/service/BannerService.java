package service;

import dao.BannerDao;
import model.Banner;

import java.util.List;

public class BannerService {
    private BannerDao bannerDao;

    public BannerService() {
        this.bannerDao = new BannerDao();
    }

    //get all banners for homepage
    public List<Banner> getAllBanners(){
        return bannerDao.getAllBanners();
    }
}
