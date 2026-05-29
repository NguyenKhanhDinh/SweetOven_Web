package utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class UploadUtils {

    private static final String UPLOAD_DIR = "uploads";

    public static String saveFile(Part filePart, ServletContext context, String subFolder)
            throws IOException {

        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = "";
        int dotIndex = originalFileName.lastIndexOf(".");
        if (dotIndex > 0) {
            fileExtension = originalFileName.substring(dotIndex);
        }

        String timeStamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String fileName = timeStamp + "_" + System.currentTimeMillis() + fileExtension;

        String uploadPath = context.getRealPath("") + File.separator + UPLOAD_DIR + File.separator + subFolder;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return UPLOAD_DIR + "/" + subFolder + "/" + fileName;
    }

    public static boolean deleteFile(ServletContext context, String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }
        String realPath = context.getRealPath("") + File.separator + filePath.replace("/", File.separator);
        File file = new File(realPath);
        return file.exists() && file.delete();
    }
}