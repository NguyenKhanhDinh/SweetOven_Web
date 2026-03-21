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
    public Map<String, Object> getProductsPaging(int page, int pageSize, String keyword, Integer categoryId, String sort) {
       int offset = (page - 1) * pageSize;
       //lấy danh sách sản phẩm
        List<Product> products = productDao.getProductsPaging(offset,pageSize,keyword,categoryId,sort);
        // đếm tổng sản phẩm
        int totalProducts = productDao.countPrducts(keyword,categoryId);
        //tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        //trả về dạng map
        Map<String, Object> result = new HashMap<>();
        result.put("products", products);
        result.put("totalProducts", totalProducts);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);

        return  result;
    }
// lấy sản phẩm theo id
    public Product getProductById(int id) {
        return productDao.findById(id);
    }
// lâý sản phẩm liên quan
    public List<Product> getRelatedProducts(int categoryId,int currentProductId) {
        int limit = 8;
        return productDao.getRelatedProducts(categoryId,limit,currentProductId);
    }
//lấy sản phẩm nổi bật
public List<Product> getFeaturedProducts() {
     return productDao.getFeaturedProducts();
}
    }

