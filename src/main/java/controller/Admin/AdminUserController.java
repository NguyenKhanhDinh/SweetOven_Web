package controller.Admin;

import dao.AdminUserDao;
import model.User;
import service.AdminUserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {

    private AdminUserService adminUserService;

    private static final int PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        adminUserService = new AdminUserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User adminUser = (User) session.getAttribute("user");
        if (adminUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "view":
                viewUser(req, resp, adminUser);
                break;
            case "api":
                apiGetUser(req, resp);
                break;
            case "block":
                blockUser(req, resp, adminUser);
                break;
            case "unblock":
                unblockUser(req, resp, adminUser);
                break;
            case "activate":
                activateUser(req, resp, adminUser);
                break;
            default:
                listUsers(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User adminUser = (User) session.getAttribute("user");
        if (adminUser.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        switch (action) {
            case "create":
                createUser(req, resp);
                break;
            case "update":
                updateUser(req, resp, adminUser);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                break;
        }
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String keyword = req.getParameter("keyword");

        String blockedParam = req.getParameter("blocked");
        String pageParam = req.getParameter("page");


        int blocked = parseIntOrDefault(blockedParam, -1);
        int page = parseIntOrDefault(pageParam, 1);
        if (page < 1) page = 1;

        String roleParam = req.getParameter("role");
        int roleFilter = parseIntOrDefault(roleParam, -1);
        List<User> users = adminUserService.getUsers(keyword, blocked, roleFilter, page, PAGE_SIZE);
        int totalUsers = adminUserService.countUsers(keyword, blocked, roleFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);

        req.setAttribute("totalAllUsers", adminUserService.countAllUsers());
        req.setAttribute("activeUsers", adminUserService.countActiveUsers());
        req.setAttribute("blockedUsers", adminUserService.countBlockedUsers());
        req.setAttribute("newUsersThisMonth", adminUserService.countNewUsersThisMonth());

        req.setAttribute("users", users);
        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", PAGE_SIZE);

        req.setAttribute("keyword", keyword == null ? "" : keyword);

        req.setAttribute("blocked", blocked);
        req.setAttribute("roleFilter", roleFilter);

        req.getRequestDispatcher("/adminPage/admin_users.jsp").forward(req, resp);
    }

    private void apiGetUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        int id = parseIntOrDefault(req.getParameter("id"), 0);
        if (id <= 0) {
            resp.getWriter().write("{\"error\":\"ID không hợp lệ\"}");
            return;
        }
        User user = adminUserService.findById(id);
        if (user == null) {
            resp.getWriter().write("{\"error\":\"Không tìm thấy người dùng\"}");
            return;
        }
        int orderCount = adminUserService.countOrdersByUserId(id);

        String avatar = user.getAvatar() != null ? "\"" + user.getAvatar().replace("\"", "\\\"") + "\"" : "null";
        String fullName = user.getFullName() != null ? "\"" + user.getFullName().replace("\"", "\\\"") + "\"" : "null";
        String username = user.getUserName() != null ? "\"" + user.getUserName().replace("\"", "\\\"") + "\"" : "null";
        String email = user.getEmail() != null ? "\"" + user.getEmail().replace("\"", "\\\"") + "\"" : "null";
        String phone = user.getPhoneNumber() != null ? "\"" + user.getPhoneNumber().replace("\"", "\\\"") + "\"" : "null";
        String createdAt = user.getCreatedAt() != null ? "\"" + user.getCreatedAt().toString() + "\"" : "null";

        String json = String.format("{\"id\":%d,\"avatar\":%s,\"fullName\":%s,\"username\":%s,\"email\":%s," + "\"phoneNumber\":%s,\"gender\":%d,\"status\":%d,\"blocked\":%b," + "\"roleId\":%d,\"createdAt\":%s,\"orderCount\":%d}", user.getId(), avatar, fullName, username, email, phone, user.getGender(), user.getStatus(), user.isBlocked(), user.getRoleId(), createdAt, orderCount);
        resp.getWriter().write(json);
    }

    private void viewUser(HttpServletRequest req, HttpServletResponse resp, User adminUser) throws ServletException, IOException {
        int id = parseIntOrDefault(req.getParameter("id"), 0);
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        User user = adminUserService.findById(id);
        if (user == null) {
            req.getSession().setAttribute("errorMsg", "Không tìm thấy người dùng!");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        int orderCount = adminUserService.countOrdersByUserId(id);
        req.setAttribute("viewUser", user);
        req.setAttribute("orderCount", orderCount);
        listUsers(req, resp);
    }

    private void activateUser(HttpServletRequest req, HttpServletResponse resp, User adminUser) throws IOException {
        int id = parseIntOrDefault(req.getParameter("id"), 0);
        AdminUserService.BlockResult result = adminUserService.activateUser(id);

        HttpSession session = req.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Đã kích hoạt tài khoản thành công!");
                break;
            case NOT_FOUND:
                session.setAttribute("errorMsg", "Không tìm thấy người dùng!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users" + buildQueryString(req));
    }

    private void blockUser(HttpServletRequest req, HttpServletResponse resp, User adminUser) throws ServletException, IOException {
        int id = parseIntOrDefault(req.getParameter("id"), 0);
        AdminUserService.BlockResult result = adminUserService.blockUser(id, adminUser.getId());

        HttpSession session = req.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Đã khoá tài khoản thành công!");
                break;
            case SELF_BLOCK:
                session.setAttribute("errorMsg", "Bạn không thể tự khoá tài khoản của mình!");
                break;
            case NOT_FOUND:
                session.setAttribute("errorMsg", "Không tìm thấy người dùng!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users" + buildQueryString(req));
    }

    private void unblockUser(HttpServletRequest req, HttpServletResponse resp, User adminUser) throws ServletException, IOException {
        int id = parseIntOrDefault(req.getParameter("id"), 0);
        AdminUserService.BlockResult result = adminUserService.unblockUser(id, adminUser.getId());

        HttpSession session = req.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Đã mở khoá tài khoản thành công!");
                break;
            case NOT_FOUND:
                session.setAttribute("errorMsg", "Không tìm thấy người dùng!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users" + buildQueryString(req));
    }

    private void createUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        int gender = parseIntOrDefault(req.getParameter("gender"), 0);
        int roleId = parseIntOrDefault(req.getParameter("roleId"), 2);

        AdminUserService.CreateResult result = adminUserService.createUser(fullName, username, email, phone, password, gender, roleId);

        HttpSession session = req.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Tạo tài khoản thành công!");
                break;
            case USERNAME_EXISTS:
                session.setAttribute("errorMsg", "Tên đăng nhập đã tồn tại!");
                break;
            case EMAIL_EXISTS:
                session.setAttribute("errorMsg", "Email đã được sử dụng!");
                break;
            case PHONE_EXISTS:
                session.setAttribute("errorMsg", "Số điện thoại đã được sử dụng!");
                break;
            case WEAK_PASSWORD:
                session.setAttribute("errorMsg", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
                break;
            case INVALID_INPUT:
                session.setAttribute("errorMsg", "Thông tin không hợp lệ, vui lòng kiểm tra lại!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp, User adminUser) throws ServletException, IOException {

        int id = parseIntOrDefault(req.getParameter("id"), 0);
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        int gender = parseIntOrDefault(req.getParameter("gender"), 0);
        String newPassword = req.getParameter("newPassword");

        AdminUserService.UpdateResult result = adminUserService.updateUser(id, fullName, email, phone, gender, newPassword);

        HttpSession session = req.getSession();
        switch (result) {
            case SUCCESS:
                session.setAttribute("successMsg", "Cập nhật thông tin thành công!");
                break;
            case NOT_FOUND:
                session.setAttribute("errorMsg", "Không tìm thấy người dùng!");
                break;
            case EMAIL_TAKEN:
                session.setAttribute("errorMsg", "Email này đã được sử dụng bởi tài khoản khác!");
                break;
            case INVALID_INPUT:
                session.setAttribute("errorMsg", "Thông tin không hợp lệ, vui lòng kiểm tra lại!");
                break;
            case WEAK_PASSWORD:
                session.setAttribute("errorMsg", "Mật khẩu mới phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
                break;
            default:
                session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private int parseIntOrDefault(String param, int defaultVal) {
        if (param == null || param.isBlank()) return defaultVal;
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private String buildQueryString(HttpServletRequest req) {
        StringBuilder sb = new StringBuilder("?");
        String[] params = {"keyword", "blocked", "role", "page"};
        for (String p : params) {
            String v = req.getParameter(p);
            if (v != null && !v.isBlank()) sb.append(p).append("=").append(v).append("&");
        }
        String qs = sb.toString();
        return qs.equals("?") ? "" : qs.substring(0, qs.length() - 1);
    }
}