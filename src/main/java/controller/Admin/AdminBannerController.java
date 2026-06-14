package controller.Admin;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Banner;
import service.BannerService;

@WebServlet("/admin/banners")
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

        showListPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String successMsg = "Thao tác thành công!";
        request.getSession().setAttribute("successMsg", successMsg);
        response.sendRedirect(request.getContextPath() + "/admin/banners");
    }
    //Hiển thị danh sách banner
    private void showListPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Banner> allBanners = bannerService.getAllBanners();

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

        List<Banner> allBanners = bannerService.getAllBanners();
        Banner banner = null;

        if (allBanners != null) {
            for (Banner b : allBanners) {
                if (b.getId() == id) {
                    banner = b;
                    break;
                }
            }
        }

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

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}