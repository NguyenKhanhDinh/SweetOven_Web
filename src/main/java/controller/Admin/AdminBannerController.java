package controller.Admin;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import model.Banner;
import service.BannerService;
import utils.CloudinaryUtil;

@WebServlet("/admin/banners")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminBannerController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BannerService bannerService = new BannerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("api".equals(action)) {
            handleApi(request, response);
            return;
        }

        if ("activate".equals(action)) {
            handleActivate(request, response);
            return;
        }
        if ("deactivate".equals(action)) {
            handleDeactivate(request, response);
            return;
        }
        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }

        showListPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            handleCreate(request, response);
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        }else if ("updateStatusAjax".equals(action)) {
            handleUpdateStatusAjax(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/banners");
        }
    }

    // XỬ LÝ THÊM BANNER MỚI (Dùng Cloudinary)
    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String isActiveParam = request.getParameter("isActive");

        System.out.println("isActiveParam = '" + isActiveParam + "'");

        boolean isActive = "on".equals(isActiveParam);

        System.out.println("isActive = " + isActive);

        if (title == null || title.trim().isEmpty()) {
            request.getSession().setAttribute("errorMsg", "Tiêu đề banner không được để trống!");
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        Part filePart = request.getPart("imageFile");
        String imageUrl = null;

        if (filePart != null && filePart.getSize() > 0) {
            imageUrl = CloudinaryUtil.uploadImage(filePart);
            if (imageUrl == null) {
                request.getSession().setAttribute("errorMsg", "Lỗi upload ảnh lên Cloudinary! Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/admin/banners");
                return;
            }
        } else {
            request.getSession().setAttribute("errorMsg", "Vui lòng chọn hình ảnh cho banner!");
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        Banner banner = new Banner();
        banner.setTitle(title.trim());
        banner.setDescription(description != null ? description.trim() : "");
        banner.setImageUrl(imageUrl);
        banner.setActive(isActive);

        int generatedId = bannerService.createBanner(banner);

        if (generatedId > 0) {
            request.getSession().setAttribute("successMsg", "Thêm banner thành công!");
        } else {
            request.getSession().setAttribute("errorMsg", "Thêm banner thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/banners");
    }

    // XỬ LÝ CẬP NHẬT BANNER (Dùng Cloudinary)
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String isActiveParam = request.getParameter("isActive");
        String existingImageUrl = request.getParameter("existingImageUrl");
        boolean isActive = "on".equals(isActiveParam);

        if (idParam == null || title == null || title.trim().isEmpty()) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        int id = Integer.parseInt(idParam);
        Banner existingBanner = bannerService.getBannerById(id);

        if (existingBanner == null) {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy banner!");
            response.sendRedirect(request.getContextPath() + "/admin/banners");
            return;
        }

        // Xử lý upload ảnh mới lên Cloudinary (nếu có)
        Part filePart = request.getPart("imageFile");
        String imageUrl = existingImageUrl;

        if (filePart != null && filePart.getSize() > 0) {
            // Upload ảnh mới
            String newImageUrl = CloudinaryUtil.uploadImage(filePart);
            if (newImageUrl == null) {
                request.getSession().setAttribute("errorMsg", "Lỗi upload ảnh mới lên Cloudinary!");
                response.sendRedirect(request.getContextPath() + "/admin/banners");
                return;
            }
            imageUrl = newImageUrl;
            // LƯU Ý: Cloudinary tự động quản lý, không cần xóa ảnh cũ thủ công
        }

        existingBanner.setTitle(title.trim());
        existingBanner.setDescription(description != null ? description.trim() : "");
        existingBanner.setImageUrl(imageUrl);
        existingBanner.setActive(isActive);

        boolean updated = bannerService.updateBanner(existingBanner);

        if (updated) {
            request.getSession().setAttribute("successMsg", "Cập nhật banner thành công!");
        } else {
            request.getSession().setAttribute("errorMsg", "Cập nhật banner thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/banners" + getFilterQueryString(request));
    }

    // XỬ LÝ KÍCH HOẠT
    private void handleActivate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                if (bannerService.activateBanner(id)) {
                    request.getSession().setAttribute("successMsg", "Kích hoạt banner thành công!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Kích hoạt banner thất bại!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "ID banner không hợp lệ!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/banners" + getFilterQueryString(request));
    }

    // XỬ LÝ NGỪNG KÍCH HOẠT
    private void handleDeactivate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                if (bannerService.deactivateBanner(id)) {
                    request.getSession().setAttribute("successMsg", "Đã ngừng hoạt động banner!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Ngừng hoạt động banner thất bại!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "ID banner không hợp lệ!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/banners" + getFilterQueryString(request));
    }

    // XỬ LÝ XÓA
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                if (bannerService.deleteBanner(id)) {
                    request.getSession().setAttribute("successMsg", "Xóa banner thành công!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Xóa banner thất bại!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "ID banner không hợp lệ!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/banners" + getFilterQueryString(request));
    }

    // LẤY FILTER QUERY STRING
    private String getFilterQueryString(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String page = request.getParameter("page");

        StringBuilder qs = new StringBuilder();
        if (keyword != null && !keyword.isEmpty()) {
            qs.append("?keyword=").append(keyword);
            if (status != null && !status.equals("-1")) {
                qs.append("&status=").append(status);
            }
            if (page != null && !page.isEmpty()) {
                qs.append("&page=").append(page);
            }
        } else if (status != null && !status.equals("-1")) {
            qs.append("?status=").append(status);
            if (page != null && !page.isEmpty()) {
                qs.append("&page=").append(page);
            }
        }

        return qs.toString();
    }

    // HIỂN THỊ DANH SÁCH
    private void showListPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Banner> allBanners = bannerService.getAllBannersForAdmin();

        if (allBanners == null || allBanners.isEmpty()) {
            request.setAttribute("banners", null);
            request.setAttribute("totalBanners", 0);
            request.setAttribute("activeBanners", 0);
            request.setAttribute("inactiveBanners", 0);
            request.setAttribute("newBannersThisMonth", 0);
            request.setAttribute("totalBannersCount", 0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("keyword", "");
            request.setAttribute("statusFilter", -1);
            request.getRequestDispatcher("/adminPage/admin_banner.jsp").forward(request, response);
            return;
        }

        int totalBanners = allBanners.size();
        int activeBanners = (int) allBanners.stream().filter(Banner::isActive).count();
        int inactiveBanners = totalBanners - activeBanners;

        LocalDateTime now = LocalDateTime.now();
        int currentMonth = now.getMonthValue();
        int currentYear = now.getYear();
        int newBannersThisMonth = (int) allBanners.stream()
                .filter(b -> b.getCreatedAt() != null)
                .filter(b -> b.getCreatedAt().getMonthValue() == currentMonth
                        && b.getCreatedAt().getYear() == currentYear)
                .count();

        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");

        List<Banner> filteredBanners = allBanners;

        if (keyword != null && !keyword.isEmpty()) {
            String finalKeyword = keyword.toLowerCase();
            filteredBanners = filteredBanners.stream()
                    .filter(b -> (b.getTitle() != null && b.getTitle().toLowerCase().contains(finalKeyword))
                            || (b.getDescription() != null && b.getDescription().toLowerCase().contains(finalKeyword)))
                    .collect(Collectors.toList());
        }

        if (statusFilter != null && !statusFilter.equals("-1")) {
            boolean showActive = "1".equals(statusFilter);
            filteredBanners = filteredBanners.stream()
                    .filter(b -> b.isActive() == showActive)
                    .collect(Collectors.toList());
        }

        int pageSize = 5;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalBannersCount = filteredBanners.size();
        int totalPages = (int) Math.ceil((double) totalBannersCount / pageSize);

        if (totalPages == 0) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalBannersCount);

        List<Banner> pageBanners = filteredBanners;
        if (start < end) {
            pageBanners = filteredBanners.subList(start, end);
        } else if (totalBannersCount > 0) {
            pageBanners = filteredBanners.subList(0, Math.min(pageSize, totalBannersCount));
        }

        request.setAttribute("banners", pageBanners);
        request.setAttribute("totalBanners", totalBanners);
        request.setAttribute("activeBanners", activeBanners);
        request.setAttribute("inactiveBanners", inactiveBanners);
        request.setAttribute("newBannersThisMonth", newBannersThisMonth);
        request.setAttribute("totalBannersCount", totalBannersCount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("statusFilter", statusFilter != null ? Integer.parseInt(statusFilter) : -1);

        request.getRequestDispatcher("/adminPage/admin_banner.jsp").forward(request, response);
    }

    private void handleApi(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Missing id\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Invalid id\"}");
            return;
        }

        Banner banner = bannerService.getBannerById(id);

        if (banner == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Banner not found\"}");
            return;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String createdAtStr = banner.getCreatedAt() != null ? banner.getCreatedAt().format(formatter) : "";
        String updatedAtStr = banner.getUpdatedAt() != null ? banner.getUpdatedAt().format(formatter) : "";

        String json = String.format(
                "{"
                        + "\"id\": %d,"
                        + "\"title\": \"%s\","
                        + "\"description\": \"%s\","
                        + "\"bannerImageUrl\": \"%s\","
                        + "\"isActive\": %b,"
                        + "\"createdAt\": \"%s\","
                        + "\"updatedAt\": \"%s\""
                        + "}",
                banner.getId(),
                escapeJson(banner.getTitle()),
                escapeJson(banner.getDescription()),
                banner.getImageUrl() != null ? banner.getImageUrl() : "",
                banner.isActive(),
                createdAtStr,
                updatedAtStr
        );

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
    private void handleUpdateStatusAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if (idParam == null || statusParam == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            boolean isActive = "active".equals(statusParam);

            boolean updated = bannerService.updateBannerStatus(id, isActive);

            if (updated) {
                String message = isActive ? "Kích hoạt banner thành công!" : "Đã ngừng hoạt động banner!";
                response.getWriter().write(String.format(
                        "{\"success\": true, \"message\": \"%s\"}", message
                ));
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại!\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ!\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}