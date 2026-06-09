package dao;

import model.Cart;
import model.CartItem;
import model.Product;
import utils.JdbiConnector;

import java.math.BigDecimal;
import java.util.List;

public class CartDao {
public int getOrCreateCartId(int userId){
    return JdbiConnector.getJdbi().withHandle(handle -> {
        Integer cartId = handle.createQuery("SELECT id FROM cart WHERE user_id = :userId").bind("userId", userId).mapTo(Integer.class).findFirst().orElse(null);
        if (cartId != null) return cartId;
        return handle.createUpdate("INSERT INTO cart (user_id) VALUES (:userId)").bind("userId", userId).executeAndReturnGeneratedKeys("id").mapTo(Integer.class).one();
    });
}
public void saveCartToDB(int userId, Cart cart){
    int cartId = getOrCreateCartId(userId);
    JdbiConnector.getJdbi().useTransaction(handle -> {
        handle.createUpdate("DELETE FROM cart_item WHERE cart_id = :cartId").bind("cartId", cartId).execute();
        for(CartItem item : cart.getItems()){
            handle.createUpdate("""
                    INSERT INTO cart_item(cart_id,product_id,quantity,price)
                    VALUES (:cartId,:productId,:quantity,:price)
                """).bind("cartId", cartId).bind("productId", item.getProduct().getId()).bind("quantity", item.getQuantity()).bind("price", item.getPrice()).execute();
        }
        handle.createUpdate("UPDATE cart SET updated_at = NOW() WHERE id=:cartId").bind("cartId", cartId).execute();
    });
}
public Cart loadCartFromDB(int userId){
    int cartId = getOrCreateCartId(userId);
    Cart cart = new Cart();
    ProductDao productDao = new ProductDao();
    ProductImageDao productImageDao = new ProductImageDao();

    List<CartItem> items = JdbiConnector.getJdbi().withHandle(handle -> handle.createQuery("SELECT product_id,quantity,price FROM cart_item WHERE cart_id =:cartId").bind("cartId",cartId)
            .map((rs,ctx)->{ int productId = rs.getInt("product_id");
                int quantity = rs.getInt("quantity");
                BigDecimal price = rs.getBigDecimal("price");

                Product product = productDao.findById(productId);
                if(product == null){ return null;}

                String imageUrl = productImageDao.getPrimaryImage(productId);
                return new CartItem(quantity,price,product,imageUrl);
            }).list());
    for(CartItem item : items){
        if(item != null){
            cart.getData().put(item.getProduct().getId(), item);
        }
    }
    return cart;
}
public Cart mergeDBCartIntoSession(int userId, Cart sessionCart){
    Cart dbCart = loadCartFromDB(userId);

    for(CartItem dbItem : dbCart.getItems()){
        int productId = dbItem.getProduct().getId();
        if(!sessionCart.getData().containsKey(productId)){
            sessionCart.getData().put(productId, dbItem);
        }else {
            CartItem sessionItem = sessionCart.getData().get(productId);
            int mergedQty = sessionItem.getQuantity() + dbItem.getQuantity();
            int stock = dbItem.getProduct().getStockQuantity();
            if(mergedQty > stock) mergedQty = stock;
            sessionItem.setQuantity(mergedQty);
        }
    }
    return sessionCart;
}
public void clearCartInDB(int userId){
    int cartId = getOrCreateCartId(userId);
    JdbiConnector.getJdbi().useHandle(handle -> {
        handle.createUpdate("DELETE FROM cart_item WHERE cart_id = :cartId").bind("cartId", cartId).execute();
    });
}
public Cart builCartForReorder(List<int[]> items){
    Cart cart = new Cart();
    ProductDao productDao = new ProductDao();
    ProductImageDao productImageDao = new ProductImageDao();

    for(int[] item : items){
        int productId = item[0];
        int quantity = item[1];

        Product product = productDao.findById(productId);
        if(product == null || !"active".equalsIgnoreCase(String.valueOf(product.getStatus())))continue;
        if(quantity>product.getStockQuantity()) quantity = product.getStockQuantity();
        if(quantity<0) continue;

        String imageUrl = productImageDao.getPrimaryImage(productId);
        CartItem cartItem = new CartItem(quantity,product.getDisplayPrice(),product,imageUrl);
        cart.getData().put(productId, cartItem);
    }
    return cart;
}
}
