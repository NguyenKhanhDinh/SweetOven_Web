package service;

import dao.ProductDao;
import model.Product;

import java.util.List;

public class ProductService {
    private ProductDao productDao;
    public ProductService() {
        this.productDao = new ProductDao();
    }
    public List<Product> getFeaturedProducts() {
        return productDao.getFeaturedProducts();
    }
}
