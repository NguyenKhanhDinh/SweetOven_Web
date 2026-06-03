package dao;

import model.UserAddress;
import utils.GHNUtil;
import utils.JdbiConnector;

import java.util.List;

public class UserAddressDao {
    public List<UserAddress> findByUserId(int userId) {
        String sql = """
                SELECT id,user_id as userId,address_detail as addressDetail,ward,district,province,is_default as isDefault,ghn_district_id AS ghnDistrictId,ghn_ward_code AS ghnWardCode
                FROM user_address WHERE user_id = :userId
                ORDER BY is_default DESC, id DESC
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery(sql).bind("userId", userId).mapToBean(UserAddress.class).list());
    }

    public boolean insertUserAddress(UserAddress userAddress) {
        lookupAndFillGhnData(userAddress);
        String sql = """
                INSERT INTO user_address (user_id, address_detail, ward, district, province, is_default,ghn_district_id, ghn_ward_code) 
                                     VALUES (:userId, :addressDetail, :ward, :district, :province, :isDefault,:ghnDistrictId, :ghnWardCode)
                """;
        return JdbiConnector.getJdbi().withHandle(handle -> handle.createUpdate(sql).bindBean(userAddress).execute()) > 0;
    }

    private void lookupAndFillGhnData(UserAddress userAddress) {
        try{
            String province = nvl(userAddress.getProvince());
            String district = nvl(userAddress.getDistrict());
            String ward = nvl(userAddress.getWard());
            if(province.isEmpty()) return;
            int districtId = GHNUtil.getDistrictId(province, district);
            if(districtId <=0 ) {
                userAddress.setGhnDistrictId(null);
                userAddress.setGhnWardCode(null);
                return;
            }
            userAddress.setGhnDistrictId(districtId);
            userAddress.setGhnWardCode(!ward.isEmpty() ? GHNUtil.getWardCode(districtId, ward) : null);
        }catch(Exception e){
            System.err.println("[GHN] Lỗi tra cứu khi lưu địa chỉ: "+e.getMessage());
            userAddress.setGhnDistrictId(null);
            userAddress.setGhnWardCode(null);
        }
    }

    private String nvl(String s) {
        return s == null ? "" : s.trim();
    }

    public boolean updateUserAddress(UserAddress userAddress) {
        lookupAndFillGhnData(userAddress);
        String sql = """
                UPDATE user_address 
                SET address_detail = :addressDetail, ward = :ward, district = :district, province = :province,ghn_district_id = :ghnDistrictId, ghn_ward_code = :ghnWardCode
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
    public void saveGhnData(int addressId,int ghnDistrictId,String  ghnWardCode) {
        JdbiConnector.getJdbi().withHandle(handle ->handle.createUpdate(
                "UPDATE user_address SET ghn_district_id = :ghnDistrictId,ghn_ward_code = :ghnWardCode WHERE id = :id")
                .bind("ghnDistrictId", ghnDistrictId).bind("ghnWardCode", ghnWardCode).bind("id", addressId).execute());
    }
}

