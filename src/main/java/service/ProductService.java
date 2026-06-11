package service;

import dao.ProductDao;
import model.Product;
import java.util.List;

public class ProductService {

    private ProductDao productDao = new ProductDao();

    // Đếm tổng số sản phẩm
    public int countAllProducts() {
        return productDao.countAll();
    }

    // featured products for homepage
    public List<Product> getFeaturedProducts() {
        return productDao.getFeaturedProducts();
    }

    // lấy tất cả sản phẩm
    public List<Product> getListProduct() {
        return productDao.getListProduct();
    }

    // tìm sản phẩm theo category
    public List<Product> getProductsByCategoryId(int categoryId) {
        return productDao.getProductsByCategory(categoryId);
    }

    public Product findById(int id) {
        return productDao.findById(id);
    }

    public List<Product> getRelatedProducts(int categoryId, int currentProductId) {
        int limit = 8;
        return productDao.getRelatedProducts(categoryId, currentProductId, limit);
    }

    public List<Product> getFavoriteProducts(List<Integer> productIds) {
        return productDao.getFavoriteProducts(productIds);
    }

    public List<Product> findAllWithFilters(String search,
                                            Integer categoryId,
                                            Integer status,
                                            Boolean featured,
                                            String sort,
                                            int page,
                                            int pageSize) {

        return productDao.findAllWithFilters(
                search,
                categoryId,
                status,
                featured,
                sort,
                page,
                pageSize
        );
    }

    public int countWithFilters(String search,
                                Integer categoryId,
                                Integer status,
                                Boolean featured) {

        return productDao.countWithFilters(
                search,
                categoryId,
                status,
                featured
        );
    }

    public List<Product> searchByKeyword(String keyword, int limit) {
        return productDao.findAllWithFilters(keyword, null, 1, null, null, 1, limit);
    }

    // Thêm sản phẩm mới
    public int addProduct(Product product) {
        return productDao.addProduct(product);
    }

    // Cập nhật sản phẩm
    public boolean updateProduct(Product product) {
        try {
            productDao.update(product);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa sản phẩm theo ID
    public boolean deleteProductById(int id) {
        try {
            productDao.deleteById(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật trạng thái sản phẩm
    public boolean updateProductStatus(int productId, int status) {
        try {
            productDao.updateStatus(productId, status);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy số sequence tiếp theo cho mã sản phẩm
    public int getNextProductSequence() {
        return productDao.getNextProductSequence();
    }

    // Kiểm tra mã sản phẩm đã tồn tại chưa
    public boolean isProductCodeExists(String productCode) {
        return productDao.isProductCodeExists(productCode);
    }

    // Lấy danh sách ảnh của sản phẩm
    public List<String> getProductImages(int productId) {
        return productDao.getProductImages(productId);
    }

    // Tạo mã sản phẩm tự động
    public String generateProductCode() {
        int nextSeq = getNextProductSequence();
        return String.format("SP%06d", nextSeq);
    }
}