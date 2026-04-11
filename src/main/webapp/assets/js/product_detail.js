let currentIndex = 0;

function showImage(index) {
    const images = document.querySelectorAll('.slide-img');
    images.forEach(img => img.classList.remove('active'));
    images[index].classList.add('active');
}

function nextImage() {
    const images = document.querySelectorAll('.slide-img');
    currentIndex = (currentIndex + 1) % images.length;
    showImage(currentIndex);
}

function prevImage() {
    const images = document.querySelectorAll('.slide-img');
    currentIndex = (currentIndex - 1 + images.length) % images.length;
    showImage(currentIndex);
}
function goToProductDetail(productId) {
    sessionStorage.setItem('selectedProductId', productId);
    window.location.href = 'product?id=' + productId;
}
