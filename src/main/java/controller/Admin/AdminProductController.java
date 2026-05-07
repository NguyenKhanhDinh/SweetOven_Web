package controller.Admin;

import dao.*;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/products")
@MultipartConfig
public class AdminProductController extends HttpServlet {

    private ProductDao productDao;
    private CategoryDao categoryDao;
    private ProductImageDao productImageDao;

    private static final Map<Integer, String> CATEGORY_CODE_MAP = new HashMap<>();
    static {
        CATEGORY_CODE_MAP.put(1, "BN");   // Bánh ngọt
        CATEGORY_CODE_MAP.put(2, "BM");   // Bánh mặn
        CATEGORY_CODE_MAP.put(3, "DN");   // Đồ nướng
        CATEGORY_CODE_MAP.put(4, "CB");   // Combo
    }

    private String generateProductCode(int categoryId) {
        String prefix = CATEGORY_CODE_MAP.getOrDefault(categoryId, "SP");
        int maxSeq = productDao.getMaxSequenceByPrefix(prefix);
        int nextSeq = maxSeq + 1;
        return String.format("%s-%04d", prefix, nextSeq);
    }

    @Override
    public void init() {
        productDao = new ProductDao();
        categoryDao = new CategoryDao();
        productImageDao = new ProductImageDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            productDao.updateStatus(id, 0);
            req.setAttribute("success", "Đã xóa sản phẩm!");
            listProducts(req, resp);
        } else if ("get-detail".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Product p = productDao.findById(id);
            List<ProductImage> images = productImageDao.findByProductId(id);

            resp.setContentType("application/json");
            resp.getWriter().write("{\"id\":" + p.getId() +
                    ",\"productCode\":\"" + p.getProductCode() + "\"" +
                    ",\"name\":\"" + p.getName() + "\"" +
                    ",\"categoryId\":" + p.getCategoryId() +
                    ",\"originalPrice\":" + p.getOriginalPrice() +
                    ",\"discountPrice\":" + (p.getDiscountPrice() == null ? "null" : p.getDiscountPrice()) +
                    ",\"stockQuantity\":" + p.getStockQuantity() +
                    ",\"status\":" + p.getStatus() +
                    ",\"featured\":" + p.isFeatured() +
                    ",\"description\":\"" + (p.getDescription() == null ? "" : p.getDescription().replace("\"", "\\\"")) + "\"" +
                    ",\"ingredients\":\"" + (p.getIngredients() == null ? "" : p.getIngredients().replace("\"", "\\\"")) + "\"" +
                    ",\"image\":\"" + (p.getImage() == null ? "" : p.getImage()) + "\"" +
                    "}");
        } else {
            listProducts(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addProduct(req, resp);
        } else if ("edit".equals(action)) {
            editProduct(req, resp);
        } else {
            listProducts(req, resp);
        }
    }

    private void listProducts(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String search = req.getParameter("search");
        String categoryIdParam = req.getParameter("categoryId");
        String statusParam = req.getParameter("status");
        String featuredParam = req.getParameter("featured");
        String sort = req.getParameter("sort");
        String pageParam = req.getParameter("page");

        int page = pageParam == null ? 1 : Integer.parseInt(pageParam);
        int pageSize = 10;

        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            categoryId = Integer.parseInt(categoryIdParam);
        }

        Integer status = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            status = Integer.parseInt(statusParam);
        }

        Boolean featured = null;
        if (featuredParam != null && !featuredParam.isEmpty()) {
            featured = Boolean.parseBoolean(featuredParam);
        }

        int totalProducts = productDao.countWithFilters(search, categoryId, status, featured);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<Product> products = productDao.findAllWithFilters(search, categoryId, status, featured, sort, page, pageSize);

        req.setAttribute("products", products);
        req.setAttribute("categories", categoryDao.findAll());
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("searchKeyword", search);
        req.setAttribute("filterCategoryId", categoryIdParam);
        req.setAttribute("filterStatus", statusParam);
        req.setAttribute("filterFeatured", featuredParam);
        req.setAttribute("sortOrder", sort);

        req.getRequestDispatcher("/adminPage/admin_products.jsp").forward(req, resp);
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // SỬA LỖI: Khai báo categoryId TRƯỚC khi dùng
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String productCode = generateProductCode(categoryId);
            String name = req.getParameter("name");
            BigDecimal originalPrice = new BigDecimal(req.getParameter("originalPrice"));
            String discountPriceStr = req.getParameter("discountPrice");
            BigDecimal discountPrice = discountPriceStr.isEmpty() ? null : new BigDecimal(discountPriceStr);
            int stock = Integer.parseInt(req.getParameter("stockQuantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            boolean featured = "true".equals(req.getParameter("featured"));
            String description = req.getParameter("description");
            String ingredients = req.getParameter("ingredients");

            Product p = new Product();
            p.setProductCode(productCode);
            p.setName(name);
            p.setCategoryId(categoryId);
            p.setOriginalPrice(originalPrice);
            p.setDiscountPrice(discountPrice);
            p.setStockQuantity(stock);
            p.setStatus(status);
            p.setFeatured(featured);
            p.setDescription(description);
            p.setIngredients(ingredients);
            p.setCreatedAt(LocalDateTime.now());

            int id = productDao.addProduct(p);

            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = saveFile(imagePart, "products");
                productDao.updateImage(id, fileName);
            }

            req.setAttribute("success", "Thêm sản phẩm thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        listProducts(req, resp);
    }

    private void editProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String productCode = req.getParameter("productCode");
            String name = req.getParameter("name");
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            BigDecimal originalPrice = new BigDecimal(req.getParameter("originalPrice"));
            String discountPriceStr = req.getParameter("discountPrice");
            BigDecimal discountPrice = discountPriceStr.isEmpty() ? null : new BigDecimal(discountPriceStr);
            int stock = Integer.parseInt(req.getParameter("stockQuantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            boolean featured = "true".equals(req.getParameter("featured"));
            String description = req.getParameter("description");
            String ingredients = req.getParameter("ingredients");

            Product p = productDao.findById(id);
            p.setProductCode(productCode);
            p.setName(name);
            p.setCategoryId(categoryId);
            p.setOriginalPrice(originalPrice);
            p.setDiscountPrice(discountPrice);
            p.setStockQuantity(stock);
            p.setStatus(status);
            p.setFeatured(featured);
            p.setDescription(description);
            p.setIngredients(ingredients);
            p.setUpdatedAt(LocalDateTime.now());

            productDao.update(p);

            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = saveFile(imagePart, "products");
                productDao.updateImage(id, fileName);
            }

            req.setAttribute("success", "Cập nhật thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        listProducts(req, resp);
    }

    private String saveFile(Part part, String folder) throws IOException {
        String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
        String appPath = getServletContext().getRealPath("/");
        String savePath = appPath + File.separator + "uploads" + File.separator + folder;

        File dir = new File(savePath);
        if (!dir.exists()) dir.mkdirs();

        part.write(savePath + File.separator + fileName);
        return "/uploads/" + folder + "/" + fileName;
    }
}