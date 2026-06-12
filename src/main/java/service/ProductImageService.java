package service;

import dao.ProductImageDao;
import model.ProductImage;

import java.util.List;

public class ProductImageService {

    private final ProductImageDao productImageDao = new ProductImageDao();

    public void insertImage(int productId, String imageUrl, boolean isPrimary) {
        productImageDao.insertImage(productId, imageUrl, isPrimary);
    }

    public int insert(ProductImage image) {
        return productImageDao.insert(image);
    }

    public void update(ProductImage image) {
        productImageDao.update(image);
    }

    public String getPrimaryImage(int productId) {
        return productImageDao.getPrimaryImage(productId);
    }

    public List<ProductImage> getProductImages(int productId) {
        return productImageDao.getProductImages(productId);
    }

    public List<ProductImage> findByProductId(int productId) {
        return productImageDao.findByProductId(productId);
    }

    public void deleteImage(int imageId) {
        productImageDao.deleteImage(imageId);
    }

    public void deleteByProductId(int productId) {
        productImageDao.deleteByProductId(productId);
    }

    public void replaceAllWithSingle(int productId, String imageUrl) {
        deleteByProductId(productId);
        insertImage(productId, imageUrl, true);
    }
}