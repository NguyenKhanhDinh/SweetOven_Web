function goToProductDetail(productId) {
    if (productId) {
        sessionStorage.setItem('selectedProductId', productId);
        window.location.href = 'product?id=' + productId;
    }
}

function addToCartAsync(productId, quantity, buttonElement) {
    if (!productId) return;

    const originalText = buttonElement.innerHTML;
    buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    buttonElement.disabled = true;

    // FIX: dùng window._contextPath (set bởi header.jsp) - URL tương đối 'add-cart' bị sai khi ở /menu, /product, v.v.
    var ctxPath = (window._contextPath !== undefined ? window._contextPath : '');
    fetch(ctxPath + '/add-cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'productId=' + productId + '&quantity=' + (quantity || 1)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                buttonElement.innerHTML = '<i class="fas fa-check"></i> Đã thêm!';
                updateCartBadge(data.cartTotalQuantity);
                setTimeout(() => {
                    buttonElement.innerHTML = originalText;
                    buttonElement.disabled = false;
                }, 2000);
            } else {
                buttonElement.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Thất bại';
                setTimeout(() => {
                    buttonElement.innerHTML = originalText;
                    buttonElement.disabled = false;
                }, 2000);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            buttonElement.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi';
            setTimeout(() => {
                buttonElement.innerHTML = originalText;
                buttonElement.disabled = false;
            }, 2000);
        });
}

function updateCartBadge(totalQuantity) {
    const cartBadge = document.getElementById('cart-badge');
    if (cartBadge) {
        if (totalQuantity > 0) {
            cartBadge.textContent = totalQuantity;
            cartBadge.style.display = 'inline-block';
        } else {
            cartBadge.style.display = 'none';
        }
    }
}

function setupSearchForm() {
    const searchForm = document.querySelector('.nav-icons form');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            const keywordInput = this.querySelector('input[name="keyword"]');
            if (keywordInput && keywordInput.value.trim() === '') {
                e.preventDefault();
                window.location.href = 'menu';
            }
        });
    }
}

function initCarousel() {
    const carousel = document.querySelector('#heroCarousel');
    if (carousel) {
        const bsCarousel = new bootstrap.Carousel(carousel, {
            interval: 5000,
            ride: 'carousel',
            pause: 'hover'
        });
    }
}

function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

function highlightActiveNavLink() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');

    navLinks.forEach(link => {
        const linkPath = link.getAttribute('href');
        if (linkPath && currentPath.endsWith(linkPath)) {
            link.classList.add('active');
        } else if (currentPath === '/' + linkPath) {
            link.classList.add('active');
        }
    });
}

function initUserDropdown() {
    const userIcon = document.getElementById('userIcon');
    if (userIcon) {
        userIcon.addEventListener('click', function(e) {
            // You can implement dropdown menu or profile check here
            console.log('User icon clicked');
        });
    }
}

function initScrollEffects() {
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 100) {
                navbar.style.boxShadow = '0 6px 20px rgba(0, 0, 0, 0.12)';
                navbar.style.backdropFilter = 'blur(10px)';
            } else {
                navbar.style.boxShadow = '0 6px 20px rgba(0, 0, 0, 0.08)';
                navbar.style.backdropFilter = 'blur(6px)';
            }
        });
    }
}

function initProductCardEffects() {
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transition = 'all 0.3s ease';
        });
    });
}
// Back to Top Button
function initBackToTop() {
    const backBtn = document.createElement('button');
    backBtn.className = 'btn-back-top';
    backBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
    document.body.appendChild(backBtn);

    window.addEventListener('scroll', function() {
        if (window.scrollY > 300) {
            backBtn.classList.add('show');
        } else {
            backBtn.classList.remove('show');
        }
    });

    backBtn.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

function initCopyCode() {
    document.querySelectorAll('.promo-code').forEach(el => {
        const code = el.textContent;
        const copyBtn = document.createElement('button');
        copyBtn.className = 'btn-copy-code';
        copyBtn.innerHTML = '<i class="fas fa-copy"></i> Sao chép';

        copyBtn.addEventListener('click', async function() {
            try {
                await navigator.clipboard.writeText(code);
                this.innerHTML = '<i class="fas fa-check"></i> Đã copy!';
                this.classList.add('copied');
                setTimeout(() => {
                    this.innerHTML = '<i class="fas fa-copy"></i> Sao chép';
                    this.classList.remove('copied');
                }, 2000);
            } catch (err) {
                console.error('Copy failed:', err);
            }
        });

        el.parentElement.appendChild(copyBtn);
    });
}

document.addEventListener('DOMContentLoaded', function() {
    initBackToTop();
    initCopyCode();
    initCarousel();
    initSmoothScroll();
    highlightActiveNavLink();
    initUserDropdown();
    initScrollEffects();
    initProductCardEffects();
    setupSearchForm();

    console.log('Sweet Oven Bakery - Website loaded successfully');
});

window.addEventListener('load', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const message = urlParams.get('message');
    if (message) {
        console.log('Notification:', message);
    }
});

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        goToProductDetail,
        addToCartAsync,
        updateCartBadge
    };

};