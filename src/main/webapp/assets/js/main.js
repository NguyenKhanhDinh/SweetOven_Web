function goToProductDetail(productId) {
    sessionStorage.setItem('selectedProductId', productId);
    window.location.href = 'product?id=' + productId;
}