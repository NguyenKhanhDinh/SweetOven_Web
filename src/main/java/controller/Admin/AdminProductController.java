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
import java.util.List;

@WebServlet("/admin/products")
@MultipartConfig
public class AdminProductController extends HttpServlet {

    private ProductDao productDao;
    private CategoryDao categoryDao;
    private ProductImageDao productImageDao;

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
            // Xóa mềm - cập nhật status = 0
            int id = Integer.parseInt(req.getParameter("id"));
            productDao.updateStatus(id, 0);
            req.setAttribute("success", "Đã xóa sản phẩm!");
            listProducts(req, resp);
        } else if ("get-detail".equals(action)) {
            // Lấy chi tiết sản phẩm (JSON)
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
        String pageParam = req.getParameter("page");
        int page = pageParam == null ? 1 : Integer.parseInt(pageParam);
        int pageSize = 10;

        List<Product> products;
        int totalProducts;

        if (search != null && !search.isEmpty()) {
            products = productDao.searchByName(search, page, pageSize);
            totalProducts = productDao.countSearch(search);
        } else {
            products = productDao.findAll(page, pageSize);
            totalProducts = productDao.countAll();
        }

        req.setAttribute("products", products);
        req.setAttribute("categories", categoryDao.findAll());
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalPages", (int) Math.ceil((double) totalProducts / pageSize));
        req.setAttribute("currentPage", page);
        req.setAttribute("searchKeyword", search);

        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
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

            // Upload ảnh chính
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

            // Upload ảnh mới nếu có
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