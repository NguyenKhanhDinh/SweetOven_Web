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

    // SINH MÃ SẢN PHẨM TỰ ĐỘNG - SP000001, SP000002,...
    private String generateProductCode() {
        int nextSeq = productDao.getNextProductSequence();
        return String.format("SP%06d", nextSeq);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            deleteProductPermanently(id, req, resp);
        } else if ("get-detail".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            getProductDetailJson(id, resp);
        } else {
            listProducts(req, resp);
        }
    }

    private void deleteProductPermanently(int id, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Product p = productDao.findById(id);
            if (p != null) {
                String realPath = getServletContext().getRealPath("/");

                // Xóa ảnh đại diện
                if (p.getImage() != null && !p.getImage().isEmpty()) {
                    File imgFile = new File(realPath + p.getImage());
                    if (imgFile.exists()) imgFile.delete();
                }

                // Xóa ảnh phụ
                List<ProductImage> images = productImageDao.findByProductId(id);
                for (ProductImage img : images) {
                    if (img.getImageUrl() != null && !img.getImageUrl().isEmpty()) {
                        File imgFile = new File(realPath + img.getImageUrl());
                        if (imgFile.exists()) imgFile.delete();
                    }
                }

                // Xóa trong database
                productImageDao.deleteByProductId(id);
                productDao.deleteById(id);

                req.setAttribute("success", "Đã xóa sản phẩm thành công!");
            } else {
                req.setAttribute("error", "Không tìm thấy sản phẩm!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xóa: " + e.getMessage());
        }
        listProducts(req, resp);
    }

    private void getProductDetailJson(int id, HttpServletResponse resp) throws IOException {
        Product p = productDao.findById(id);
        List<ProductImage> images = productImageDao.findByProductId(id);

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"id\":").append(p.getId()).append(",");
        json.append("\"productCode\":\"").append(escapeJson(p.getProductCode())).append("\",");
        json.append("\"name\":\"").append(escapeJson(p.getName())).append("\",");
        json.append("\"categoryId\":").append(p.getCategoryId()).append(",");
        json.append("\"originalPrice\":").append(p.getOriginalPrice()).append(",");
        json.append("\"discountPrice\":").append(p.getDiscountPrice() == null ? "null" : p.getDiscountPrice()).append(",");
        json.append("\"stockQuantity\":").append(p.getStockQuantity()).append(",");
        json.append("\"status\":").append(p.getStatus()).append(",");
        json.append("\"featured\":").append(p.isFeatured()).append(",");
        json.append("\"description\":\"").append(escapeJson(p.getDescription() == null ? "" : p.getDescription())).append("\",");
        json.append("\"ingredients\":\"").append(escapeJson(p.getIngredients() == null ? "" : p.getIngredients())).append("\",");
        json.append("\"image\":\"").append(escapeJson(p.getImage() == null ? "" : p.getImage())).append("\"");
        json.append("}");

        resp.setContentType("application/json");
        resp.getWriter().write(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
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
        List<Category> categories = categoryDao.findAll();

        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("searchKeyword", search == null ? "" : search);
        req.setAttribute("filterCategoryId", categoryIdParam);
        req.setAttribute("filterStatus", statusParam);
        req.setAttribute("filterFeatured", featuredParam);
        req.setAttribute("sortOrder", sort);

        req.getRequestDispatcher("/adminPage/admin_products.jsp").forward(req, resp);
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // Tự động sinh mã sản phẩm
            String productCode = generateProductCode();

            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String name = req.getParameter("name");
            BigDecimal originalPrice = new BigDecimal(req.getParameter("originalPrice"));
            String discountPriceStr = req.getParameter("discountPrice");
            BigDecimal discountPrice = (discountPriceStr == null || discountPriceStr.isEmpty()) ? null : new BigDecimal(discountPriceStr);
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

            // Upload ảnh
            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = saveFile(imagePart, "products");
                productImageDao.insertImage(id, fileName, true);
            }

            Part subImage1 = req.getPart("imageFileSub1");
            if (subImage1 != null && subImage1.getSize() > 0) {
                String fileName = saveFile(subImage1, "products");
                productImageDao.insertImage(id, fileName, false);
            }

            Part subImage2 = req.getPart("imageFileSub2");
            if (subImage2 != null && subImage2.getSize() > 0) {
                String fileName = saveFile(subImage2, "products");
                productImageDao.insertImage(id, fileName, false);
            }

            req.setAttribute("success", "Thêm sản phẩm thành công! Mã SP: " + productCode);

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
            BigDecimal discountPrice = (discountPriceStr == null || discountPriceStr.isEmpty()) ? null : new BigDecimal(discountPriceStr);
            int stock = Integer.parseInt(req.getParameter("stockQuantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            boolean featured = "true".equals(req.getParameter("featured"));
            String description = req.getParameter("description");
            String ingredients = req.getParameter("ingredients");

            Product p = productDao.findById(id);
            if (p == null) {
                req.setAttribute("error", "Không tìm thấy sản phẩm!");
                listProducts(req, resp);
                return;
            }

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

            // Xử lý upload ảnh mới nếu có
            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                // Xóa ảnh cũ
                List<ProductImage> oldImages = productImageDao.findByProductId(id);
                for (ProductImage oldImg : oldImages) {
                    if (oldImg.isPrimary()) {
                        String realPath = getServletContext().getRealPath("/");
                        File oldFile = new File(realPath + oldImg.getImageUrl());
                        if (oldFile.exists()) oldFile.delete();
                        productImageDao.deleteImage(oldImg.getId());
                        break;
                    }
                }
                // Thêm ảnh mới
                String fileName = saveFile(imagePart, "products");
                productImageDao.insertImage(id, fileName, true);
            }

            req.setAttribute("success", "Cập nhật sản phẩm thành công!");

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