package service;

import dao.FeedBackDao;
import model.FeedBack;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class FeedBackService {

    private final FeedBackDao feedBackDao;

    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)[0-9]{9,10}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    public FeedBackService() {
        this.feedBackDao = new FeedBackDao();
    }

    public String insertFeedBack(FeedBack feedBack) {
        if (feedBack == null) return "Dữ liệu rỗng";

        if (feedBack.getFullName() == null || feedBack.getFullName().isBlank()) {
            return "Thiếu họ tên";
        }

        if (feedBack.getEmail() == null || feedBack.getEmail().isBlank()) {
            return "Thiếu email";
        }

        if (feedBack.getPhoneNumber() == null || !feedBack.getPhoneNumber().matches("\\d{9,11}")) {
            return "Số điện thoại không hợp lệ";
        }

        boolean result = feedBackDao.insert(feedBack);
        return result ? "SUCCESS" : "Lỗi database";
    }

    // Lấy danh sách phản hồi, phân trang và lọc
    public Map<String, Object> getFeedbacksWithPagination(String keyword, String dateFrom,
                                                          String dateTo, int page, int pageSize) {
        Map<String, Object> result = new HashMap<>();

        try {
            int offset = (page - 1) * pageSize;
            List<FeedBack> feedbacks = feedBackDao.findAllWithFilters(
                    keyword, dateFrom, dateTo, offset, pageSize
            );
            long totalFeedbacks = feedBackDao.countWithFilters(keyword, dateFrom, dateTo);
            int totalPages = (int) Math.ceil((double) totalFeedbacks / pageSize);

            result.put("success", true);
            result.put("feedbacks", feedbacks);
            result.put("totalFeedbacks", totalFeedbacks);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("pageSize", pageSize);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy danh sách phản hồi: " + e.getMessage());
        }

        return result;
    }

    // Lấy thống kê
    public Map<String, Object> getStatistics() {
        Map<String, Object> result = new HashMap<>();

        try {
            long total = feedBackDao.getTotalFeedbacks();
            long today = feedBackDao.getTodayFeedbacks();
            long week = feedBackDao.getWeekFeedbacks();
            long month = feedBackDao.getMonthFeedbacks();
            long pending = feedBackDao.getPendingFeedbacks();

            result.put("success", true);
            result.put("totalFeedbacks", total);
            result.put("todayFeedbacks", today);
            result.put("weekFeedbacks", week);
            result.put("monthFeedbacks", month);
            result.put("pendingFeedbacks", pending);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy thống kê: " + e.getMessage());
        }

        return result;
    }

    // Lấy chi tiết feedback
    public Map<String, Object> getFeedbackDetail(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);

            if (feedback != null) {
                result.put("success", true);
                result.put("id", feedback.getId());
                result.put("fullName", feedback.getFullName());
                result.put("email", feedback.getEmail());
                result.put("phoneNumber", feedback.getPhoneNumber());
                result.put("content", feedback.getContent());
                result.put("reply", feedback.getReply());
                result.put("status", feedback.getStatus());
                result.put("externalReplyStatus", feedback.getExternalReplyStatus());
                result.put("createdAt", feedback.getCreatedAt() != null ? feedback.getCreatedAt().toString() : "");
                result.put("repliedAt", feedback.getRepliedAt() != null ? feedback.getRepliedAt().toString() : "");
                result.put("repliedBy", feedback.getRepliedBy());
            } else {
                result.put("success", false);
                result.put("message", "Không tìm thấy phản hồi!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi lấy chi tiết phản hồi: " + e.getMessage());
        }

        return result;
    }

    // Mở Gmail
    public Map<String, Object> markAsOpened(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);
            if (feedback == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean updated = feedBackDao.updateExternalReplyStatusOpened(id);

            if (updated) {
                result.put("success", true);
                result.put("message", "Đã mở Gmail");
                result.put("email", feedback.getEmail());
                result.put("fullName", feedback.getFullName());
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        return result;
    }

    // Xác nhận đã gửi email
    public Map<String, Object> confirmReplied(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);
            if (feedback == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean updated = feedBackDao.updateExternalReplyStatusReplied(id);

            if (updated) {
                result.put("success", true);
                result.put("message", "Đã xác nhận gửi email phản hồi!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        return result;
    }

    // Lưu nội dung reply và cập nhật trạng thái
    public Map<String, Object> saveReplyAndConfirm(int id, String replyContent, String repliedBy) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack feedback = feedBackDao.findById(id);
            if (feedback == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean updated = feedBackDao.updateRepliedStatus(id, replyContent, repliedBy);

            if (updated) {
                result.put("success", true);
                result.put("message", "Đã lưu phản hồi và cập nhật trạng thái!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể lưu phản hồi!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        return result;
    }

    // Xóa feedback
    public Map<String, Object> deleteFeedback(int id) {
        Map<String, Object> result = new HashMap<>();

        try {
            FeedBack existing = feedBackDao.findById(id);
            if (existing == null) {
                result.put("success", false);
                result.put("message", "Phản hồi không tồn tại!");
                return result;
            }

            boolean deleted = feedBackDao.deleteById(id);

            if (deleted) {
                result.put("success", true);
                result.put("message", "Xóa phản hồi thành công!");
            } else {
                result.put("success", false);
                result.put("message", "Không thể xóa phản hồi!");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi xóa phản hồi: " + e.getMessage());
        }

        return result;
    }
    public List<FeedBack> getAllFeedbacksForExport(String keyword, String dateFrom, String dateTo) {
        try {
            return feedBackDao.findAllForExport(keyword, dateFrom, dateTo);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi lấy dữ liệu xuất Excel: " + e.getMessage());
        }
    }

    public byte[] exportToExcel(String keyword, String dateFrom, String dateTo) {
        List<FeedBack> feedbacks = getAllFeedbacksForExport(keyword, dateFrom, dateTo);
        return generateExcelFile(feedbacks);
    }

    private byte[] generateExcelFile(List<FeedBack> feedbacks) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh sách phản hồi");

            // Tạo style cho header
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);

            // Tạo style cho cell bình thường
            CellStyle cellStyle = workbook.createCellStyle();
            cellStyle.setBorderBottom(BorderStyle.THIN);
            cellStyle.setBorderTop(BorderStyle.THIN);
            cellStyle.setBorderLeft(BorderStyle.THIN);
            cellStyle.setBorderRight(BorderStyle.THIN);
            cellStyle.setWrapText(true);

            // Tạo style cho cell trạng thái
            CellStyle pendingStyle = workbook.createCellStyle();
            pendingStyle.cloneStyleFrom(cellStyle);
            pendingStyle.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.getIndex());
            pendingStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            CellStyle repliedStyle = workbook.createCellStyle();
            repliedStyle.cloneStyleFrom(cellStyle);
            repliedStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
            repliedStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // Tạo header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {
                    "STT", "Họ tên", "Email", "Số điện thoại",
                    "Nội dung phản hồi", "Phản hồi của Admin",
                    "Ngày gửi", "Ngày phản hồi", "Người phản hồi",
                    "Trạng thái", "Trạng thái phản hồi qua email", "Sentiment"
            };

            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Tạo data rows
            int rowNum = 1;
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

            for (int i = 0; i < feedbacks.size(); i++) {
                FeedBack fb = feedbacks.get(i);
                Row row = sheet.createRow(rowNum++);

                // STT
                createCell(row, 0, String.valueOf(i + 1), cellStyle);

                // Họ tên
                createCell(row, 1, fb.getFullName() != null ? fb.getFullName() : "", cellStyle);

                // Email
                createCell(row, 2, fb.getEmail() != null ? fb.getEmail() : "", cellStyle);

                // Số điện thoại
                createCell(row, 3, fb.getPhoneNumber() != null ? fb.getPhoneNumber() : "", cellStyle);

                // Nội dung phản hồi
                createCell(row, 4, fb.getContent() != null ? fb.getContent() : "", cellStyle);

                // Phản hồi của Admin
                createCell(row, 5, fb.getReply() != null ? fb.getReply() : "", cellStyle);

                // Ngày gửi
                String createdAt = fb.getCreatedAt() != null ?
                        fb.getCreatedAt().format(dateFormatter) : "";
                createCell(row, 6, createdAt, cellStyle);

                // Ngày phản hồi
                String repliedAt = fb.getRepliedAt() != null ?
                        fb.getRepliedAt().format(dateFormatter) : "";
                createCell(row, 7, repliedAt, cellStyle);

                // Người phản hồi
                createCell(row, 8, fb.getRepliedBy() != null ? fb.getRepliedBy() : "", cellStyle);

                // Trạng thái (status) với màu sắc
                String statusText = getStatusText(fb.getStatus());
                Cell statusCell = row.createCell(9);
                statusCell.setCellValue(statusText);
                if ("Đã phản hồi".equals(statusText)) {
                    statusCell.setCellStyle(repliedStyle);
                } else if ("Chưa phản hồi".equals(statusText)) {
                    statusCell.setCellStyle(pendingStyle);
                } else {
                    statusCell.setCellStyle(cellStyle);
                }

                // Trạng thái phản hồi qua email
                String externalStatusText = getExternalStatusText(fb.getExternalReplyStatus());
                Cell externalCell = row.createCell(10);
                externalCell.setCellValue(externalStatusText);
                if ("Đã phản hồi qua email".equals(externalStatusText)) {
                    externalCell.setCellStyle(repliedStyle);
                } else if ("Đã mở email".equals(externalStatusText)) {
                    externalCell.setCellStyle(pendingStyle);
                } else {
                    externalCell.setCellStyle(cellStyle);
                }

                // Sentiment
                String sentimentText = getSentimentText(fb.getSentiment());
                createCell(row, 11, sentimentText, cellStyle);
            }

            // Auto-size tất cả các cột
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                int width = sheet.getColumnWidth(i);
                if (width < 4000) sheet.setColumnWidth(i, 4000);
                if (width > 15000) sheet.setColumnWidth(i, 15000);
            }

            // Freeze header row
            sheet.createFreezePane(0, 1);

            // Ghi workbook vào byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();

        } catch (IOException e) {
            throw new RuntimeException("Lỗi tạo file Excel: " + e.getMessage());
        }
    }

    private void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private String getStatusText(String status) {
        if (status == null) return "Chưa phản hồi";
        switch (status) {
            case "replied": return "Đã phản hồi";
            case "pending": return "Chưa phản hồi";
            default: return status;
        }
    }

    private String getExternalStatusText(String externalStatus) {
        if (externalStatus == null) return "Chưa phản hồi";
        switch (externalStatus) {
            case "replied": return "Đã phản hồi qua email";
            case "opened": return "Đã mở email";
            case "pending": return "Chưa phản hồi";
            default: return externalStatus;
        }
    }

    private String getSentimentText(String sentiment) {
        if (sentiment == null) return "Chưa phân tích";
        switch (sentiment.toLowerCase()) {
            case "positive": return "Tích cực";
            case "negative": return "Tiêu cực";
            case "neutral": return "Trung lập";
            default: return sentiment;
        }
    }
}