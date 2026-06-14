package service;

import dao.BannerDao;
import model.Banner;

import java.time.LocalDateTime;
import java.util.List;

public class BannerService {
    private BannerDao bannerDao = new BannerDao();

    //get all banners for homepage
    public List<Banner> getAllBanners(){
        return bannerDao.getAllBanners();
    }
    // Thêm banner mới
    public int createBanner(Banner banner) {
        LocalDateTime now = LocalDateTime.now();
        banner.setCreatedAt(now);
        banner.setUpdatedAt(now);
        return bannerDao.insert(banner);
    }

    // Cập nhật banner
    public boolean updateBanner(Banner banner) {
        banner.setUpdatedAt(LocalDateTime.now());
        return bannerDao.update(banner);
    }

    // Lấy banner theo id
    public Banner getBannerById(int id) {
        return bannerDao.getById(id);
    }

    // Kích hoạt banner
    public boolean activateBanner(int id) {
        Banner banner = getBannerById(id);
        if (banner != null && !banner.isActive()) {
            return bannerDao.activate(id);
        }
        return false;
    }

    // Ngừng kích hoạt banner
    public boolean deactivateBanner(int id) {
        Banner banner = getBannerById(id);
        if (banner != null && banner.isActive()) {
            return bannerDao.deactivate(id);
        }
        return false;
    }

    // Xóa banner
    public boolean deleteBanner(int id) {
        return bannerDao.delete(id);
    }

    // Lấy tất cả banner cho admin
    public List<Banner> getAllBannersForAdmin() {
        return bannerDao.getAllBannersForAdmin();
    }
}
