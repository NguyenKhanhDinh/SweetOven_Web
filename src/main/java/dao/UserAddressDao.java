package dao;

import model.UserAddress;
import utils.JdbiConnector;

import java.util.List;

public class UserAddressDao {
    public List<UserAddress> findByUserId(int userId){
        String sql = """
                SELECT id,user_id as userId,address_detail as addressDetail,ward,district,province,is_default as isDefault
                FROM user_address WHERE user_id = :userId
                ORDER BY is_default DESC, id DESC
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createQuery(sql).bind("userId",userId).mapToBean(UserAddress.class).list());
    }
    public boolean insertUserAddress(UserAddress userAddress){
        String sql = """
                INSERT INTO user_address (user_id, address_detail, ward, district, province, is_default) 
                                     VALUES (:userId, :addressDetail, :ward, :district, :province, :default)
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bindBean(userAddress).execute())>0;
    }
    public boolean updateUserAddress(UserAddress userAddress){
        String sql = """
                UPDATE user_address 
                SET address_detail = :addressDetail, ward = :ward, district = :district, province = :province
                WHERE id = :id AND user_id = :userId
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(sql).bindBean(userAddress).execute())>0;
    }
    public boolean deleteUserAddress(int id,int userId){
        String sql = """
                DELETE FROM user_address WHERE id = :id AND user_id = :userId
                """;
        return JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(sql).bind("id",id).bind("userId",userId).execute())>0;
    }
}
