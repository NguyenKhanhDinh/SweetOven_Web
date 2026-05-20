package service;

import dao.ProductDao;
import model.Product;

import java.util.List;

public class ProductService {

    private ProductDao productDao = new ProductDao();

    //featured products for homepage
    public List<Product> getFeaturedProducts() {
        return productDao.getFeaturedProducts();
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
}