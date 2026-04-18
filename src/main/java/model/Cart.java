package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Cart implements Serializable {
    private Map<Long, CartItem> items = new HashMap<>();

    public void add(CartItem item) {
        long id = item.getProduct().getId();
        if (items.containsKey(id)) {
            items.get(id).upQuantity(item.getQuantity());
        } else {
            items.put(id, item);
        }
    }

    public void remove(long productId) {
        items.remove(productId);
    }

    public void update(long productId, int quantity) {
        if (items.containsKey(productId)) {
            items.get(productId).setQuantity(quantity);
        }
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public int getTotalQuantity() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public BigDecimal getTotalCartPrice() {
        return items.values().stream()
                .map(CartItem::getTotalItemPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}