let currentIndex = 0;
const modal = new bootstrap.Modal(document.getElementById('imageModal'));
const modalImage = document.getElementById('modalImage');

document.querySelectorAll('.slide-img').forEach(img => {
    img.addEventListener('click', function() {
        modalImage.src = this.src;
        modal.show();
    });
});
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
function switchTab(tabId, el) {
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });

    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });

    document.getElementById(tabId).classList.add('active');
    el.classList.add('active');
}