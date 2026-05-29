package utils;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

public class PasswordUtil {
    //hash password with SHA-256 and salt
    public static String hashPassword(String plainPassword) {
        try{
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(plainPassword.getBytes("UTF-8"));

            return Base64.getEncoder().encodeToString(salt)+ ":" + Base64.getEncoder().encodeToString(hashed);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi hash password",e);
        }

    }
    public static boolean verifyPassword(String plainPassword, String storeHash) {
        try{
            if(!storeHash.contains(":")){
                return plainPassword.equals(storeHash);
            }
            String[] parts = storeHash.split(":");
            if(parts.length != 2) return false;
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(plainPassword.getBytes("UTF-8"));
            return parts[1].equals(Base64.getEncoder().encodeToString(hashed));
        } catch (Exception e) {
            return false;
        }
    }
}
