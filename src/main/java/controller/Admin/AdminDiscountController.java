package controller.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Discount;
import model.User;
import service.DiscountService;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/discounts")
public class AdminDiscountController extends HttpServlet {

    private DiscountService discountService = new DiscountService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(!checkAdmin(request,response))return ;

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/discounts");
            return;
        }
        switch (action) {
            case "create" -> createDiscount(request,response);
            case "update" -> updateDiscount(request,response);
            case "delete" -> deleteDiscount(request,response);
            default -> response.sendRedirect(request.getContextPath() + "/admin/discounts");

        }
    }
    private void deleteDiscount(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        if (id <= 0) {
            session.setAttribute("errorMsg","ID không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/discounts");
            return;
        }
        Discount d = discountService.findById(id);
        String codeLable = d != null ? d.getCode() : "#" +id;

        DiscountService.DeleteResult result = discountService.deleteDiscount(id);
        switch (result){
            case  SUCCESS -> session.setAttribute("successMsg","Đã xóa mã khuyến mãi" + codeLable + "!");
            case NOT_FOUND -> session.setAttribute("errorMsg","Không tìm thấy mã khuyến mãi!");
            default -> session.setAttribute("errorMsg","Có lỗi xảy ra, vui lòng thử lại!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/discounts");
    }

    private void updateDiscount(HttpServletRequest request, HttpServletResponse response) throws  IOException {
        HttpSession session = request.getSession();
        int id = parseIntOrDefault(request.getParameter("id"), 0);
        if (id <= 0) {
            session.setAttribute("errorMsg","ID không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/admin/discounts");
            return;
        }
        try {
            String code = request.getParameter("code");
            String description = request.getParameter("description");
            int discountType = parseIntOrDefault(request.getParameter("discountType"),1);
            BigDecimal value = parseBigDecimal(request.getParameter("value"));
            BigDecimal minOrder = parseBigDecimal(request.getParameter("minOrderValue"));
            LocalDateTime startDate = parseDateTime(request.getParameter("startDate"));
            LocalDateTime endDate = parseDateTime(request.getParameter("endDate"));

            DiscountService.UpdateResult result = discountService.updateDiscount(id, code, description, discountType, value, minOrder, startDate, endDate);
            switch (result) {
                case SUCCESS -> session.setAttribute("successMsg", "Đã cập nhật thành công!");
                case NOT_FOUND -> session.setAttribute("errorMsg","Không tìm thấy mã khuyến mãi!");
                case CODE_TAKEN -> session.setAttribute("errorMsg","Mã\"" + ( code != null ? code.trim().toUpperCase() : "") + "\" đã được dùng bởi khuyến mãi khác!");
                case INVALID_INPUT -> session.setAttribute("errorMsg","Thông tin không hợp lệ, vui lòng kiểm tra lại!");
                default -> session.setAttribute("errorMsg","Có lỗi xảy ra, vui lòng thử lại!");
            }
        }catch (Exception e) {
            session.setAttribute("errorMsg","Có lỗi xảy ra: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/discounts");
    }

    private void createDiscount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        try {
            String code = request.getParameter("code");
            String description = request.getParameter("description");
            int discountType = parseIntOrDefault(request.getParameter("discountType"),1);
            BigDecimal value = parseBigDecimal(request.getParameter("value"));
            BigDecimal minOrder = parseBigDecimal(request.getParameter("minOrderValue"));
            LocalDateTime startDate = parseDateTime(request.getParameter("startDate"));
            LocalDateTime endDate = parseDateTime(request.getParameter("endDate"));

            DiscountService.CreateResult result = discountService.createDiscount(code, description, discountType, value, minOrder, startDate, endDate);

            switch (result) {
                case SUCCESS -> session.setAttribute("successMsg", "Đã tạo mã khuyến mãi" + (code != null ? code.trim().toUpperCase() : "") + " thành công!");
                case CODE_EXISTS -> session.setAttribute("errorMsg", "Mã khuyến mãi\"" + (code != null ? code.trim().toUpperCase() : "") + "\" đã tồn tại!");
                case INVALID_INPUT -> session.setAttribute("errorMsg","Thông tin không hợp lệ. Vui lòng kiểm tra lại mã, giá trị và loại giảm giá.");
                default -> session.setAttribute("errorMsg","Có lỗi xảy ra, vui lòng thử lại!");
            }
        }catch (Exception e) {
            session.setAttribute("errorMsg","Có lỗi xảy ra: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/discounts");
    }
    private BigDecimal parseBigDecimal(String s) {
        if (s == null || s.isBlank()) return BigDecimal.ZERO;
        try{
            return new BigDecimal(s.trim());
        }catch (NumberFormatException e){
            return BigDecimal.ZERO;
        }
    }

    private LocalDateTime parseDateTime(String s){
        if (s == null || s.isBlank()) return null;
        try{
            return LocalDateTime.parse(s.trim(),DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        }catch (Exception e){
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "api" -> apiGetDiscount(request, response);
            default -> listDiscounts(request, response);
        }
    }

    private void listDiscounts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = nvl(request.getParameter("keyword"),"").trim();
        int typeFilter = parseIntOrDefault(request.getParameter("type"),-1);
        String statusFilter = nvl(request.getParameter("status"),"-1");
        int page = Math.max(1,parseIntOrDefault(request.getParameter("page"),1));

        List<Discount> discounts = discountService.getDiscounts(keyword,typeFilter,statusFilter,page,PAGE_SIZE);
        int totalCount = discountService.countDiscounts(keyword,typeFilter,statusFilter);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));

        request.setAttribute("discounts", discounts);
        request.setAttribute("totalDiscount", totalCount);
        request.setAttribute("totalDiscounts",discountService.countAll());
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", Math.min(page,totalPages));
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("keyword", keyword);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("now", LocalDateTime.now());
        request.setAttribute("activeDiscounts", discountService.countByStatus(DiscountService.DiscountStatus.ACTIVE));
        request.setAttribute("expiredDiscounts", discountService.countByStatus(DiscountService.DiscountStatus.EXPIRED));
        request.setAttribute("percentDiscounts",discountService.countByType(1));
        request.setAttribute("fixedDiscounts",discountService.countByType(0));

        request.getRequestDispatcher("/adminPage/admin_discounts.jsp").forward(request, response);
    }

    private int parseIntOrDefault(String s, int def) {
        if (s == null || s.isBlank()) return def;
        try {
            return Integer.parseInt(s.trim());
        }catch (NumberFormatException e) {
            return def;
        }
    }

    private String nvl(String s,String def) {
        return s != null ? s : def;
    }

    private void apiGetDiscount(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        int id = parseIntOrDefault(request.getParameter("id"),0);
        if(id <= 0) {
            response.getWriter().write("{\"error\":\"ID không hợp lệ!\"}");
            return;
        }
        Discount d = discountService.findById(id);
        if(d == null) {
            response.getWriter().write("{\"error\":\"Không tìm thấy khuyến mãi\"}");
            return;
        }
        response.getWriter().write(discountService.builApiJson(d));
    }

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        return true;
    }
}
