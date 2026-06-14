package controller.Admin;

import service.ProductImageService;
import service.ProductService;
import service.CategoryService;
import model.Category;
import model.Product;

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

    private ProductService productService;
    private CategoryService categoryService;
    private ProductImageService productImageService;

    @Override
    public void init() {
        productService = new ProductService();
        categoryService = new CategoryService();
        productImageService = new ProductImageService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getParameter("action");

        if ("api".equals(action)) {
            handleApiRequest(req, resp);
            return;
        }

        if ("delete".equals(action)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam);
                    deleteProduct(id, req, resp);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID sản phẩm không hợp lệ!");
                    listProducts(req, resp);
                }
            } else {
                req.setAttribute("error", "Không tìm thấy ID sản phẩm!");
                listProducts(req, resp);
            }
        } else {
            listProducts(req, resp);
        }
    }

    private void handleApiRequest(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idParam = req.getParameter("id");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (idParam == null || idParam.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing product ID\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Product product = productService.findById(id);
            if (product != null) {
                resp.getWriter().write(convertProductToJson(product));
            } else {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\":\"Product not found\"}");
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid product ID\"}");
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

        try {
            String searchKeyword = req.getParameter("searchKeyword");
            String categoryIdParam = req.getParameter("categoryId");
            String statusParam = req.getParameter("status");
            String featuredParam = req.getParameter("featured");
            String sortOrder = req.getParameter("sort");
            String pageParam = req.getParameter("page");

            int page = 1;
            int pageSize = 10;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            Integer categoryId = null;
            if (categoryIdParam != null && !categoryIdParam.isEmpty() && !"null".equals(categoryIdParam)) {
                try {
                    categoryId = Integer.parseInt(categoryIdParam);
                } catch (NumberFormatException ignored) {}
            }

            Integer status = null;
            if (statusParam != null && !statusParam.isEmpty() && !"null".equals(statusParam)) {
                try {
                    status = Integer.parseInt(statusParam);
                } catch (NumberFormatException ignored) {}
            }

            Boolean featured = null;
            if (featuredParam != null && !featuredParam.isEmpty() && !"null".equals(featuredParam)) {
                featured = Boolean.parseBoolean(featuredParam);
            }

            List<Product> products = productService.findAllWithFilters(
                    searchKeyword, categoryId, status, featured, sortOrder, page, pageSize
            );

            int filteredCount = productService.countWithFilters(
                    searchKeyword, categoryId, status, featured
            );

            int totalPages = (int) Math.ceil((double) filteredCount / pageSize);

            List<Category> categories = categoryService.findAllCategories();

            int totalProducts      = productService.countAllProducts();
            int availableProducts  = productService.countAvailableProducts();
            int outOfStockProducts = productService.countOutOfStockProducts();
            int featuredProducts   = productService.countFeaturedProducts();

            req.setAttribute("products", products != null ? products : List.of());
            req.setAttribute("categories", categories != null ? categories : List.of());
            req.setAttribute("totalProducts", filteredCount);
            req.setAttribute("totalPages", totalPages > 0 ? totalPages : 1);
            req.setAttribute("currentPage", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
            req.setAttribute("filterCategoryId", categoryIdParam != null ? categoryIdParam : "");
            req.setAttribute("filterStatus", statusParam != null ? statusParam : "");
            req.setAttribute("filterFeatured", featuredParam != null ? featuredParam : "");
            req.setAttribute("sortOrder", sortOrder != null ? sortOrder : "");
            req.setAttribute("statTotalProducts", totalProducts);
            req.setAttribute("availableProducts", availableProducts);
            req.setAttribute("outOfStockProducts", outOfStockProducts);
            req.setAttribute("featuredProducts", featuredProducts);

            req.getRequestDispatcher("/adminPage/admin_products.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải danh sách sản phẩm: " + e.getMessage());
            req.setAttribute("products", List.of());
            req.setAttribute("categories", List.of());
            req.getRequestDispatcher("/adminPage/admin_products.jsp").forward(req, resp);
        }
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String productCode = productService.generateProductCode();

            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String name = req.getParameter("name");
            BigDecimal originalPrice = new BigDecimal(req.getParameter("originalPrice"));
            String discountPriceStr = req.getParameter("discountPrice");
            BigDecimal discountPrice = (discountPriceStr == null || discountPriceStr.isEmpty())
                    ? null : new BigDecimal(discountPriceStr);
            int stock = Integer.parseInt(req.getParameter("stockQuantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            boolean featured = "true".equals(req.getParameter("featured"));
            String description = req.getParameter("description");
            String ingredients = req.getParameter("ingredients");

            Product product = new Product();
            product.setProductCode(productCode);
            product.setName(name);
            product.setCategoryId(categoryId);
            product.setOriginalPrice(originalPrice);
            product.setDiscountPrice(discountPrice);
            product.setStockQuantity(stock);
            product.setStatus(status);
            product.setFeatured(featured);
            product.setDescription(description);
            product.setIngredients(ingredients);
            product.setCreatedAt(LocalDateTime.now());

            String uploadedFileUrl = null;

            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileUrl = utils.CloudinaryUtil.uploadImage(imagePart);
                if (fileUrl != null) {
                    product.setImage(fileUrl);
                    uploadedFileUrl = fileUrl;
                }
            }

            int generatedId = productService.addProduct(product);

            if (generatedId > 0) {
                if (uploadedFileUrl != null) {
                    productImageService.insertImage(generatedId, uploadedFileUrl, true);
                }
                req.setAttribute("success", "Thêm sản phẩm thành công! Mã SP: " + productCode);
            } else {
                req.setAttribute("error", "Thêm sản phẩm thất bại!");
            }

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
            BigDecimal discountPrice = (discountPriceStr == null || discountPriceStr.isEmpty())
                    ? null : new BigDecimal(discountPriceStr);
            int stock = Integer.parseInt(req.getParameter("stockQuantity"));
            int status = Integer.parseInt(req.getParameter("status"));
            boolean featured = "true".equals(req.getParameter("featured"));
            String description = req.getParameter("description");
            String ingredients = req.getParameter("ingredients");

            Product product = productService.findById(id);
            if (product == null) {
                req.setAttribute("error", "Không tìm thấy sản phẩm!");
                listProducts(req, resp);
                return;
            }

            product.setProductCode(productCode);
            product.setName(name);
            product.setCategoryId(categoryId);
            product.setOriginalPrice(originalPrice);
            product.setDiscountPrice(discountPrice);
            product.setStockQuantity(stock);
            product.setStatus(status);
            product.setFeatured(featured);
            product.setDescription(description);
            product.setIngredients(ingredients);
            product.setUpdatedAt(LocalDateTime.now());

            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileUrl = utils.CloudinaryUtil.uploadImage(imagePart);
                if (fileUrl != null) {
                    product.setImage(fileUrl);
                    productImageService.deleteByProductId(id);
                    productImageService.insertImage(id, fileUrl, true);
                }
            }

            boolean updated = productService.updateProduct(product);
            if (updated) {
                req.setAttribute("success", "Cập nhật sản phẩm thành công!");
            } else {
                req.setAttribute("error", "Cập nhật sản phẩm thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
        }

        listProducts(req, resp);
    }

    private void deleteProduct(int id, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Product product = productService.findById(id);

            if (product != null) {
                productImageService.deleteByProductId(id);
                boolean deleted = productService.deleteProductById(id);
                if (deleted) {
                    req.setAttribute("success", "Đã xóa sản phẩm thành công!");
                } else {
                    req.setAttribute("error", "Xóa sản phẩm thất bại!");
                }
            } else {
                req.setAttribute("error", "Không tìm thấy sản phẩm!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xóa: " + e.getMessage());
        }

        listProducts(req, resp);
    }

    private String saveFile(Part part, String folder) throws IOException {
        String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
        String appPath = getServletContext().getRealPath("/");
        String savePath = appPath + File.separator + "uploads" + File.separator + folder;

        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        part.write(savePath + File.separator + fileName);
        return "/uploads/" + folder + "/" + fileName;
    }

    private String convertProductToJson(Product p) {
        if (p == null) {
            return "{\"error\":\"Product not found\"}";
        }

        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"id\":").append(p.getId()).append(",");
        json.append("\"productCode\":\"").append(escapeJson(p.getProductCode())).append("\",");
        json.append("\"name\":\"").append(escapeJson(p.getName())).append("\",");
        json.append("\"categoryId\":").append(p.getCategoryId()).append(",");
        json.append("\"originalPrice\":").append(p.getOriginalPrice().intValue()).append(",");

        if (p.getDiscountPrice() != null) {
            json.append("\"discountPrice\":").append(p.getDiscountPrice().intValue()).append(",");
        } else {
            json.append("\"discountPrice\":null,");
        }

        json.append("\"stockQuantity\":").append(p.getStockQuantity()).append(",");
        json.append("\"status\":").append(p.getStatus()).append(",");
        json.append("\"featured\":").append(p.isFeatured()).append(",");
        json.append("\"description\":\"").append(escapeJson(p.getDescription())).append("\",");
        json.append("\"ingredients\":\"").append(escapeJson(p.getIngredients())).append("\",");
        json.append("\"image\":\"").append(p.getImage() != null ? escapeJson(p.getImage()) : "").append("\"");
        json.append("}");

        return json.toString();
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