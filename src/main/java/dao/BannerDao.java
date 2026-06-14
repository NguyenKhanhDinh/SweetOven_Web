package dao;

import model.Banner;
import utils.JdbiConnector;

import java.time.LocalDateTime;
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
    // Lấy tất cả banner cho admin (bao gồm cả inactive)
    public List<Banner> getAllBannersForAdmin() {
        String sql = "SELECT id, title, description, " +
                "image_url AS imageUrl, " +
                "is_active, " +
                "created_at AS createdAt, " +
                "updated_at AS updatedAt " +
                "FROM banner " +
                "ORDER BY created_at DESC";
        return JdbiConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql).mapToBean(Banner.class).list());
    }
    // Thêm banner mới
    public int insert(Banner banner) {
        String sql = "INSERT INTO banner (title, description, image_url, is_active, created_at, updated_at) " +
                "VALUES (:title, :description, :imageUrl, :isActive, :createdAt, :updatedAt)";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            return handle.createUpdate(sql)
                    .bind("title", banner.getTitle())
                    .bind("description", banner.getDescription())
                    .bind("imageUrl", banner.getImageUrl())
                    .bind("isActive", banner.isActive())
                    .bind("createdAt", banner.getCreatedAt())
                    .bind("updatedAt", banner.getUpdatedAt())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    // Cập nhật banner
    public boolean update(Banner banner) {
        String sql = "UPDATE banner SET title = :title, description = :description, " +
                "image_url = :imageUrl, is_active = :isActive, updated_at = :updatedAt " +
                "WHERE id = :id";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            int rows = handle.createUpdate(sql)
                    .bind("title", banner.getTitle())
                    .bind("description", banner.getDescription())
                    .bind("imageUrl", banner.getImageUrl())
                    .bind("isActive", banner.isActive())
                    .bind("updatedAt", banner.getUpdatedAt())
                    .bind("id", banner.getId())
                    .execute();
            return rows > 0;
        });
    }

    // Lấy banner theo id
    public Banner getById(int id) {
        String sql = "SELECT id, title, description, " +
                "image_url AS imageUrl, " +
                "is_active, " +
                "created_at AS createdAt, " +
                "updated_at AS updatedAt " +
                "FROM banner WHERE id = :id";

        return JdbiConnector.getJdbi().withHandle(handle -> {
            List<Banner> result = handle.createQuery(sql)
                    .bind("id", id)
                    .mapToBean(Banner.class)
                    .list();
            return result.isEmpty() ? null : result.get(0);
        });
    }

    // Kích hoạt banner
    public boolean activate(int id) {
        String sql = "UPDATE banner SET is_active = 1, updated_at = :updatedAt WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> {
            int rows = handle.createUpdate(sql)
                    .bind("updatedAt", LocalDateTime.now())
                    .bind("id", id)
                    .execute();
            return rows > 0;
        });
    }

    // Ngừng kích hoạt banner
    public boolean deactivate(int id) {
        String sql = "UPDATE banner SET is_active = 0, updated_at = :updatedAt WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> {
            int rows = handle.createUpdate(sql)
                    .bind("updatedAt", LocalDateTime.now())
                    .bind("id", id)
                    .execute();
            return rows > 0;
        });
    }

    // Xóa banner
    public boolean delete(int id) {
        String sql = "DELETE FROM banner WHERE id = :id";
        return JdbiConnector.getJdbi().withHandle(handle -> {
            int rows = handle.createUpdate(sql).bind("id", id).execute();
            return rows > 0;
        });
    }




}
