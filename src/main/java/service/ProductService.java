package service;

import dao.ProductDao;
import model.Product;
import utils.JdbiConnector;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class ProductService {
    private ProductDao productDao = new ProductDao();
    ///Lấy sản phẩm phân trang +search+sort
   public List<Product> getProductsPaging(int offset, int limit){
    return  productDao.getProductsPaging(offset,limit);
   }
   public List<Product>  searchProducts(int offset, int limit, String keyword){
       return productDao.searchProducts(offset,limit,keyword);
   }
   public List<Product>  getProductsSort(int offset, int limit, String sort){
       return productDao.getProductsSort(offset,limit,sort);
   }
   public int countProducts(String keyword, Integer categoryId){
       return productDao.countPrducts(keyword,categoryId);
   }
    //featured products for homepage
    public List<Product> getFeaturedProducts() {
        return productDao.getFeaturedProducts();
    }

    // tìm sản phẩm theo category
    public List<Product> getProductsByCategoryId(int categoryId) {
       return productDao.getProductsByCategory(categoryId);
    }
    public List<Product> getProducts(int offset, int limit, String keyword, String sort, Integer categoryId) {
       return productDao.getProducts(offset, limit,keyword, sort, categoryId);
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
    }

