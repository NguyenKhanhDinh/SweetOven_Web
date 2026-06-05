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


// ── Add to cart AJAX ────────────────────────────────────────────────────────
(function () {
    var contextPath = document.querySelector('meta[name="contextPath"]')
        ? document.querySelector('meta[name="contextPath"]').content
        : '';

    function addToCart(productId, btn) {
        if (btn) btn.disabled = true;

        fetch(contextPath + '/add-cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + encodeURIComponent(productId) + '&quantity=1'
        })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (typeof window.showGlobalToast === 'function') {
                    window.showGlobalToast(data.success ? 'success' : 'error', data.message);
                }
                if (data.success) {
                    var badge = document.getElementById('cart-badge');
                    if (badge) {
                        badge.textContent = data.cartTotalQuantity;
                        badge.style.display = 'inline-block';
                    } else if (data.cartTotalQuantity > 0) {
                        var cartLink = document.querySelector('a[href*="my-cart"]');
                        if (cartLink) {
                            var newBadge = document.createElement('span');
                            newBadge.id = 'cart-badge';
                            newBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill';
                            newBadge.style.display = 'inline-block';
                            newBadge.textContent = data.cartTotalQuantity;
                            cartLink.appendChild(newBadge);
                        }
                    }
                }
            })
            .catch(function () {
                if (typeof window.showGlobalToast === 'function') {
                    window.showGlobalToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
                }
            })
            .finally(function () {
                if (btn) btn.disabled = false;
            });
    }

    // Nút thêm vào giỏ chính
    var mainBtn = document.querySelector('.btn-add[data-product-id]');
    if (mainBtn) {
        mainBtn.addEventListener('click', function () {
            addToCart(this.dataset.productId, this);
        });
    }

    // Nút sản phẩm liên quan
    document.querySelectorAll('.btn-related-cart[data-product-id]').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.stopPropagation(); // Không trigger goToProductDetail của thẻ cha
            addToCart(this.dataset.productId, this);
        });
    });
})();