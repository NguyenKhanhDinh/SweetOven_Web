package dao;

import model.UserAddress;
import utils.JdbiConnector;

import java.util.List;

public class UserAddressDao {
    public List<UserAddress> findByUserId(int userId) {
        String sql = """
                SELECT id,user_id as userId,address_detail as addressDetail,ward,district,province,is_default as isDefault,lat,lng
                FROM user_address WHERE user_id = :userId
                ORDER BY is_default DESC, id DESC
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).mapToBean(UserAddress.class).list());
    }

    public boolean insertUserAddress(UserAddress userAddress) {
        String sql = """
                INSERT INTO user_address (user_id, address_detail, ward, district, province, is_default) 
                                     VALUES (:userId, :addressDetail, :ward, :district, :province, :isDefault)
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bindBean(userAddress).execute()) > 0;
    }

    public boolean updateUserAddress(UserAddress userAddress) {
        String sql = """
                UPDATE user_address 
                SET address_detail = :addressDetail, ward = :ward, district = :district, province = :province
                WHERE id = :id AND user_id = :userId
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bindBean(userAddress).execute()) > 0;
    }

    public boolean deleteUserAddress(int id, int userId) {
        String sql = """
                DELETE FROM user_address WHERE id = :id AND user_id = :userId
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("id", id).bind("userId", userId).execute()) > 0;
    }

    public void clearDefaultUserAddress(int userId) {
        JdbiConnector.getJdbi().withHandle(handle ->
                handle.createUpdate("UPDATE user_address SET is_default = false WHERE user_id = :userId")
                        .bind("userId", userId)
                        .execute()
        );
    }

    public boolean setDefaultUserAddress(int id, int userId) {
       return JdbiConnector.getJdbi().withHandle(handle -> {
           handle.createUpdate("UPDATE user_address SET is_default = false WHERE user_id = :userId")
                   .bind("userId", userId)
                   .execute();
           return handle.createUpdate("UPDATE user_address SET  is_default = true WHERE id =:id AND user_id = :userId")
                   .bind("id",id)
                   .bind("userId", userId)
                   .execute()>0;
       });
    }
    public void saveCoords(int id,double lat,double lng) {
        String sql = "UPDATE user_address SET lat = :lat, lng = :lng WHERE id = :id ";
        JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bind("lat", lat).bind("lng", lng).bind("id",id).execute());
    }
}

