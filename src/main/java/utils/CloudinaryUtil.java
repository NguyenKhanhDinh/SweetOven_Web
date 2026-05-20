package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;

import java.io.InputStream;
import java.util.Map;

public class CloudinaryUtil {
    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap("cloud_name", "dizizbyj6", "api_key", "149488434966434", "api_secret", "Q6Pk8IuPTqcLJYYY4DmlIc3o36w"));
    public static String uploadImage(Part filePart){
        try{
          InputStream fileContext = filePart.getInputStream();
          byte[] bytes = fileContext.readAllBytes();
          Map uploadResult = cloudinary.uploader().upload(bytes,ObjectUtils.emptyMap());
          return (String) uploadResult.get("secure_url");
        } catch (Exception e) {
            System.out.println("Lỗi upload ở CloudinaryUtil: " + e.getMessage());
            return null;
        }
    }

}
