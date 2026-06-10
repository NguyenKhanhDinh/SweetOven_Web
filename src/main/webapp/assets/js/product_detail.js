// ── Add to cart AJAX ────────────────────────────────────────────────────────
(function () {
    var contextPath = document.querySelector('meta[name="contextPath"]')
        ? document.querySelector('meta[name="contextPath"]').content
        : '';

    function addToCart(productId, btn) {
        if (btn) btn.disabled = true;

        var qtyInput = document.getElementById('pdQty');
        var quantity = qtyInput ? parseInt(qtyInput.value) || 1 : 1;

        fetch(contextPath + '/add-cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + encodeURIComponent(productId) + '&quantity=' + quantity
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
            e.stopPropagation();
            addToCart(this.dataset.productId, this);
        });
    });
})();

// ── Navigate to product detail ───────────────────────────────────────────────
function goToProductDetail(productId) {
    sessionStorage.setItem('selectedProductId', productId);
    window.location.href = 'product?id=' + productId;
}

// ── Favorite toggle ──────────────────────────────────────────────────────────
(function () {
    var contextPath = document.querySelector('meta[name="contextPath"]')
        ? document.querySelector('meta[name="contextPath"]').content
        : '';

    window.toggleFavorite = function (btn, productId) {
        if (event) event.stopPropagation();
        fetch(contextPath + '/toggle-favorite', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + productId
        })
            .then(function (res) {
                if (res.status === 401) {
                    window.location.href = contextPath + '/login';
                    return null;
                }
                return res.json();
            })
            .then(function (data) {
                if (!data) return;
                if (data.isFavorite) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
                btn.classList.remove('heart-pop');
                void btn.offsetWidth; // reflow để restart animation
                btn.classList.add('heart-pop');
            })
            .catch(function (err) { console.error('Favorite error:', err); });
    };
})();