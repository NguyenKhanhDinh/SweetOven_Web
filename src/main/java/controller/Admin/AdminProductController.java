package controller.Admin;

import dao.CategoryDao;
import dao.ProductDao;
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

    private ProductDao productDao;
    private CategoryDao categoryDao;

    @Override
    public void init() {
        productDao = new ProductDao();
        categoryDao = new CategoryDao();
    }

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
            deleteProduct(id, req, resp);
        } else {
            listProducts(req, resp);
        }
    }

    private void deleteProduct(int id, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Product p = productDao.findById(id);

            if (p != null) {

                if (p.getImage() != null && !p.getImage().isEmpty()) {
                    String realPath = getServletContext().getRealPath("/");
                    File imgFile = new File(realPath + p.getImage());

                    if (imgFile.exists()) {
                        imgFile.delete();
                    }
                }

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

            if (categoryIdParam != null
                    && !categoryIdParam.isEmpty()
                    && !"null".equals(categoryIdParam)) {

                try {
                    categoryId = Integer.parseInt(categoryIdParam);
                } catch (NumberFormatException ignored) {
                }
            }

            Integer status = null;

            if (statusParam != null
                    && !statusParam.isEmpty()
                    && !"null".equals(statusParam)) {

                try {
                    status = Integer.parseInt(statusParam);
                } catch (NumberFormatException ignored) {
                }
            }

            Boolean featured = null;

            if (featuredParam != null
                    && !featuredParam.isEmpty()
                    && !"null".equals(featuredParam)) {

                featured = Boolean.parseBoolean(featuredParam);
            }

            List<Product> products = productDao.findAllWithFilters(
                    searchKeyword,
                    categoryId,
                    status,
                    featured,
                    sortOrder,
                    page,
                    pageSize
            );

            int totalProducts = productDao.countWithFilters(
                    searchKeyword,
                    categoryId,
                    status,
                    featured
            );

            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            List<Category> categories = categoryDao.findAll();

            req.setAttribute("products", products != null ? products : List.of());
            req.setAttribute("categories", categories != null ? categories : List.of());
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("totalPages", totalPages > 0 ? totalPages : 1);
            req.setAttribute("currentPage", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
            req.setAttribute("filterCategoryId", categoryIdParam != null ? categoryIdParam : "");
            req.setAttribute("filterStatus", statusParam != null ? statusParam : "");
            req.setAttribute("filterFeatured", featuredParam != null ? featuredParam : "");
            req.setAttribute("sortOrder", sortOrder != null ? sortOrder : "");

            req.getRequestDispatcher("/adminPage/admin_products.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();

            req.setAttribute("error",
                    "Lỗi khi tải danh sách sản phẩm: " + e.getMessage());

            req.setAttribute("products", List.of());
            req.setAttribute("categories", List.of());

            req.getRequestDispatcher("/adminPage/admin_products.jsp")
                    .forward(req, resp);
        }
    }

    private void addProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            String productCode = generateProductCode();

            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String name = req.getParameter("name");

            BigDecimal originalPrice =
                    new BigDecimal(req.getParameter("originalPrice"));

            String discountPriceStr = req.getParameter("discountPrice");

            BigDecimal discountPrice =
                    (discountPriceStr == null || discountPriceStr.isEmpty())
                            ? null
                            : new BigDecimal(discountPriceStr);

            int stock = Integer.parseInt(req.getParameter("stockQuantity"));
            int status = Integer.parseInt(req.getParameter("status"));

            boolean featured =
                    "true".equals(req.getParameter("featured"));

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

            Part imagePart = req.getPart("imageFile");

            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = saveFile(imagePart, "products");
                p.setImage(fileName);
            }

            productDao.addProduct(p);

            req.setAttribute(
                    "success",
                    "Thêm sản phẩm thành công! Mã SP: " + productCode
            );

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

            int categoryId =
                    Integer.parseInt(req.getParameter("categoryId"));

            BigDecimal originalPrice =
                    new BigDecimal(req.getParameter("originalPrice"));

            String discountPriceStr =
                    req.getParameter("discountPrice");

            BigDecimal discountPrice =
                    (discountPriceStr == null || discountPriceStr.isEmpty())
                            ? null
                            : new BigDecimal(discountPriceStr);

            int stock =
                    Integer.parseInt(req.getParameter("stockQuantity"));

            int status =
                    Integer.parseInt(req.getParameter("status"));

            boolean featured =
                    "true".equals(req.getParameter("featured"));

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

            Part imagePart = req.getPart("imageFile");

            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = saveFile(imagePart, "products");
                p.setImage(fileName);
            }

            productDao.update(p);

            req.setAttribute(
                    "success",
                    "Cập nhật sản phẩm thành công!"
            );

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
        }

        listProducts(req, resp);
    }

    private String saveFile(Part part, String folder)
            throws IOException {

        String fileName =
                System.currentTimeMillis()
                        + "_"
                        + part.getSubmittedFileName();

        String appPath = getServletContext().getRealPath("/");

        String savePath =
                appPath
                        + File.separator
                        + "uploads"
                        + File.separator
                        + folder;

        File dir = new File(savePath);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        part.write(savePath + File.separator + fileName);

        return "/uploads/" + folder + "/" + fileName;
    }
}