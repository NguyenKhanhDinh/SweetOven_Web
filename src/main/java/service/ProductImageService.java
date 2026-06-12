package service;

import dao.ProductImageDao;
import model.ProductImage;
import java.util.List;

public class ProductImageService {

    private final ProductImageDao productImageDao = new ProductImageDao();

    public void insertImage(int productId, String imageUrl, boolean isPrimary) {
        productImageDao.insertImage(productId, imageUrl, isPrimary);
    }

    public void deleteByProductId(int productId) {
        productImageDao.deleteByProductId(productId);
    }

    public String getPrimaryImage(int productId) {
        return productImageDao.getPrimaryImage(productId);
    }

    public List<ProductImage> getProductImages(int productId) {
        return productImageDao.getProductImages(productId);
    }

    public void deleteImage(int imageId) {
        productImageDao.deleteImage(imageId);
    }

    public List<ProductImage> findByProductId(int productId) {
        return productImageDao.findByProductId(productId);
    }

    public void update(ProductImage image) {
        productImageDao.update(image);
    }

    public int insert(ProductImage image) {
        return productImageDao.insert(image);
    }
}