package model;

import dao.ProductImageDao;

import java.io.Serializable;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class Cart implements Serializable {
    private Map<Integer, CartItem> data;
    private User user;

    public Cart() {
        this.data =new HashMap<>();
    }

    public void addItem(Product product,int quantity){
         if(quantity<=0){ quantity= 1;}
         int availbleStock = product.getStockQuantity();
         int currentQuantity =0;
         if(data.containsKey(product.getId())){
             currentQuantity = data.get(product.getId()).getQuantity();
         }
         int newQuantity =currentQuantity = quantity;
         if(newQuantity > availbleStock){
             newQuantity = availbleStock;
         }
         if(data.containsKey(product.getId())){
             data.get(product.getId()).setQuantity(newQuantity);
         }else{
             ProductImageDao imageDao = new ProductImageDao();
             String primaryImage = imageDao.getPrimaryImage(product.getId());
             data.put(product.getId(), new CartItem(newQuantity,product.getDisplayPrice(),product,primaryImage));
         }
   }
   public boolean updateItem(int productId,int quantity){
      CartItem cartItem = data.get(productId);
      if(cartItem == null){ return false;}
      if(quantity <= 0){ quantity= 1;}
      int availbleStock = cartItem.getProduct().getStockQuantity();
      if(quantity > availbleStock) { quantity = availbleStock;}

      cartItem.setQuantity(quantity);
      return true;
   }

   public CartItem removeItem(int productId){
        return  data.remove(productId);
   }
   public List<CartItem> removeAllItems() {
        List<CartItem> cartItems = new ArrayList<>(data.values());
        data.clear();
        return cartItems;
   }
   public List<CartItem> getItems() {
        return new ArrayList<>(data.values());
   }
   public CartItem get(int id){
        return data.get(id);
   }
   public int getTotalItems() {
        return data.size();
   }
   public int  getTotalQuantity(){
       AtomicInteger total = new AtomicInteger();
       getItems().forEach(cartItem -> total.addAndGet(cartItem.getQuantity()));
       return total.get();
   }
   public BigDecimal getTotalPrice(){
      BigDecimal total = BigDecimal.ZERO;
      for(CartItem cartItem : getItems()){
          total = total.add(cartItem.getPrice().multiply( BigDecimal.valueOf(cartItem.getQuantity())));
      }
      return total;
   }
   public void updateCustomerInfo(User user){
        this.user = user;
   }
   public void increase(int productId){
        CartItem cartItem = data.get(productId);
        if(cartItem == null){
            int availbleStock = cartItem.getProduct().getStockQuantity();
            if(cartItem.getQuantity() < availbleStock){
                cartItem.setQuantity(cartItem.getQuantity()+1);
            }
        }
   }
   public void decrease(int productId){
        CartItem cartItem = data.get(productId);
        if(cartItem != null && cartItem.getQuantity() > 1){
            cartItem.setQuantity(cartItem.getQuantity()-1);
        }
   }

    public Map<Integer, CartItem> getData() {
        return data;
    }
}