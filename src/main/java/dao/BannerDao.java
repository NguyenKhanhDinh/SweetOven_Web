package dao;

import model.Banner;
import utils.JdbiConnector;

import java.util.List;

public class BannerDao {
    //banners for homepage
    public List<Banner> getAllBanners() {
        String sql = "SELECT id, title, description, " +
                "image_url AS imageUrl, " +
                "is_active, " +
                "created_at AS createdAt, " +
                "updated_at AS updatedAt " +
                "FROM banner " +
                "WHERE is_active = 1 " +
                "ORDER BY created_at DESC";
    return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).mapToBean(Banner.class).list());
    }



}
