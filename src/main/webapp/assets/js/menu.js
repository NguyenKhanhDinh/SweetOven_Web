function goToProductDetail(productId) {
    sessionStorage.setItem('selectedProductId', productId);
    window.location.href = '/product?id=' + productId;
}

// Toast
window.onload = function () {
    const message = document.body.dataset.message;
    const error = document.body.dataset.error;

    if (message || error) {
        const toast = document.getElementById('toast');
        const text = document.getElementById('toast-message');

        text.textContent = message || error;

        toast.classList.add('show');

        setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);
    }
};