package service;

import dao.DiscountDao;
import dao.ProductDao;
import model.Discount;
import model.Product;
import utils.JdbiConnector;


import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

public class ProductService {
    private ProductDao productDao = new ProductDao();
    private DiscountDao discountDao = new DiscountDao();
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
// lâý sản phẩm liên quan
    public List<Product> getRelatedProducts(int categoryId,int currentProductId) {
        int limit = 8;
        return productDao.getRelatedProducts(categoryId,limit,currentProductId);
    }

    // Áp dụng discount tốt nhất cho một sản phẩm
    public void applyBestDiscountToProduct(Product product) {
        if (product == null) return;

        List<Discount> validDiscounts = getAllValidDiscounts();
        Discount bestDiscount = findBestDiscountForProduct(product, validDiscounts);

        if (bestDiscount != null) {
            product.setActiveDiscount(bestDiscount);
        }
    }

    // Áp dụng discount cho danh sách sản phẩm
    public void applyBestDiscountToProducts(List<Product> products) {
        if (products == null || products.isEmpty()) return;

        List<Discount> validDiscounts = getAllValidDiscounts();

        for (Product product : products) {
            Discount bestDiscount = findBestDiscountForProduct(product, validDiscounts);
            if (bestDiscount != null) {
                product.setActiveDiscount(bestDiscount);
            }
        }
    }

    // Tìm discount tốt nhất cho sản phẩm (dựa trên giá trị giảm nhiều nhất)
    private Discount findBestDiscountForProduct(Product product, List<Discount> discounts) {
        if (discounts == null || discounts.isEmpty()) return null;

        Discount bestDiscount = null;
        BigDecimal maxSavedAmount = BigDecimal.ZERO;

        for (Discount discount : discounts) {
            if (!discount.isValid()) continue;

            // Kiểm tra điều kiện đơn hàng tối thiểu
            if (discount.getMinValueOrder() != null &&
                    product.getPrice().compareTo(discount.getMinValueOrder()) < 0) {
                continue;
            }

            BigDecimal savedAmount = calculateSavedAmount(product.getPrice(), discount);

            // Chỉ chọn discount nếu số tiền saved > 0
            if (savedAmount.compareTo(BigDecimal.ZERO) > 0 &&
                    savedAmount.compareTo(maxSavedAmount) > 0) {
                maxSavedAmount = savedAmount;
                bestDiscount = discount;
            }
        }

        return bestDiscount;
    }

    // Tính số tiền được giảm
    private BigDecimal calculateSavedAmount(BigDecimal originalPrice, Discount discount) {
        if (discount.isPercentage()) {
            return originalPrice.multiply(discount.getValue())
                    .divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
        } else {
            BigDecimal saved = discount.getValue();
            return saved.compareTo(originalPrice) > 0 ? originalPrice : saved;
        }
    }

    // Lấy tất cả discount còn hiệu lực
    private List<Discount> getAllValidDiscounts() {
        List<Discount> allDiscounts = discountDao.getAllDiscounts();
        LocalDateTime now = LocalDateTime.now();

        return allDiscounts.stream()
                .filter(discount -> discount.getEndDate() == null ||
                        discount.getEndDate().isAfter(now))
                .filter(discount -> discount.getStartDate() == null ||
                        discount.getStartDate().isBefore(now))
                .collect(Collectors.toList());
    }

    // Lấy sản phẩm nổi bật kèm giá đã giảm
    public List<Product> getFeaturedProductsWithDiscount() {
        List<Product> products = productDao.getFeaturedProducts();
        applyBestDiscountToProducts(products);
        return products;
    }

    // Lấy sản phẩm theo danh mục kèm giá đã giảm
    public List<Product> getProductsByCategoryWithDiscount(int categoryId) {
        List<Product> products = productDao.getProductsByCategory(categoryId);
        applyBestDiscountToProducts(products);
        return products;
    }

    // Lấy sản phẩm liên quan kèm giá đã giảm
    public List<Product> getRelatedProductsWithDiscount(int categoryId, int currentProductId) {
        int limit = 8;
        List<Product> products = productDao.getRelatedProducts(categoryId, currentProductId, limit);
        applyBestDiscountToProducts(products);
        return products;
    }

    // Lấy chi tiết sản phẩm kèm giá đã giảm
    public Product getProductDetailWithDiscount(int productId) {
        Product product = productDao.findById(productId);
        applyBestDiscountToProduct(product);
        return product;
    }
    public boolean isValidDiscountForOrder(Discount discount, BigDecimal orderTotal) {
        if (discount == null) return false;
        if (!discount.isValid()) return false;
        if (discount.getMinValueOrder() != null &&
                orderTotal.compareTo(discount.getMinValueOrder()) < 0) {
            return false;
        }
        return true;
    }
    }

