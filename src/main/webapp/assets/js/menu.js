
const PRODUCTS_PER_PAGE = 8;
let currentPage = 1;
let currentCategory = 'all';
let currentSort = 'default';

// Get all product cards from the DOM
function getAllProducts() {
const productsGrid = document.querySelector('.products-grid');
if (!productsGrid) return [];
return Array.from(productsGrid.querySelectorAll('.product-card'));
}

function filterAndSortProducts() {
const allProducts = getAllProducts();
let filteredProducts = filterProducts(allProducts);
filteredProducts = sortProducts(filteredProducts);

updateProductsDisplay(filteredProducts);
updateResultsCount(filteredProducts.length);
buildPagination(filteredProducts.length);
}

function filterProducts(products) {
if (currentCategory === 'all') return products;

return products.filter(function (product) {
    return product.getAttribute('data-category') === currentCategory;
});
}

function sortProducts(products) {
const sortedProducts = products.slice();

switch (currentSort) {
    case 'price-asc':
        return sortedProducts.sort(function (a, b) {
            return parseInt(a.getAttribute('data-price')) - parseInt(b.getAttribute('data-price'));
        });
    case 'price-desc':
        return sortedProducts.sort(function (a, b) {
            return parseInt(b.getAttribute('data-price')) - parseInt(a.getAttribute('data-price'));
        });
    case 'name-asc':
        return sortedProducts.sort(function (a, b) {
            return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
        });
    case 'name-desc':
        return sortedProducts.sort(function (a, b) {
            return b.getAttribute('data-name').localeCompare(a.getAttribute('data-name'));
        });
    default:
        return products;
}
}

function updateProductsDisplay(products) {
const container = document.getElementById('products-container');
const productsGrid = container.querySelector('.products-grid');

const allProducts = getAllProducts();
allProducts.forEach(function (product) {
    product.style.display = 'none';
});

const startIndex = (currentPage - 1) * PRODUCTS_PER_PAGE;
const endIndex = startIndex + PRODUCTS_PER_PAGE;
const productsToShow = products.slice(startIndex, endIndex);

productsToShow.forEach(function (product) {
    product.style.display = 'flex';
});

if (productsToShow.length === 0) {
    showEmptyState(container);
}
}

function showEmptyState(container) {
const existingEmptyState = container.querySelector('.no-results');
if (existingEmptyState) {
    existingEmptyState.remove();
}

const noResultsDiv = document.createElement('div');
noResultsDiv.className = 'no-results';

const icon = document.createElement('i');
icon.className = 'fas fa-search';

const heading = document.createElement('h4');
heading.textContent = 'Không tìm thấy sản phẩm nào';

const paragraph = document.createElement('p');
paragraph.textContent = 'Hãy thử tìm kiếm với danh mục khác';

noResultsDiv.appendChild(icon);
noResultsDiv.appendChild(heading);
noResultsDiv.appendChild(paragraph);
container.appendChild(noResultsDiv);
}

function buildPagination(totalProducts) {
const totalPages = Math.ceil(totalProducts / PRODUCTS_PER_PAGE);
const pagination = document.getElementById('pagination');

while (pagination.firstChild) {
    pagination.removeChild(pagination.firstChild);
}

if (totalPages <= 1) {
    return;
}

const prevLi = document.createElement('li');
prevLi.className = currentPage === 1 ? 'page-item disabled' : 'page-item';

const prevLink = document.createElement('a');
prevLink.className = 'page-link';
prevLink.href = '#';
prevLink.textContent = '‹';
if (currentPage > 1) {
    prevLink.addEventListener('click', function (e) {
        e.preventDefault();
        changePage(currentPage - 1);
    });
}

prevLi.appendChild(prevLink);
pagination.appendChild(prevLi);

for (let i = 1; i <= totalPages; i++) {
    const pageLi = document.createElement('li');
    pageLi.className = i === currentPage ? 'page-item active' : 'page-item';

    const pageLink = document.createElement('a');
    pageLink.className = 'page-link';
    pageLink.href = '#';
    pageLink.textContent = i;
    pageLink.addEventListener('click', function (e) {
        e.preventDefault();
        changePage(i);
    });

    pageLi.appendChild(pageLink);
    pagination.appendChild(pageLi);
}

const nextLi = document.createElement('li');
nextLi.className = currentPage === totalPages ? 'page-item disabled' : 'page-item';

const nextLink = document.createElement('a');
nextLink.className = 'page-link';
nextLink.href = '#';
nextLink.textContent = '›';
if (currentPage < totalPages) {
    nextLink.addEventListener('click', function (e) {
        e.preventDefault();
        changePage(currentPage + 1);
    });
}

nextLi.appendChild(nextLink);
pagination.appendChild(nextLi);
}

function updateResultsCount(count) {
const resultsCount = document.getElementById('results-count');
resultsCount.textContent = count + ' sản phẩm';
}

function changePage(page) {
currentPage = page;
filterAndSortProducts();
window.scrollTo({ top: 0, behavior: 'smooth' });
}

function goToProductDetail(productId) {
sessionStorage.setItem('selectedProductId', productId);
window.location.href = 'product?id=' + productId;

};
// ── Add to cart từ menu (AJAX, không reload trang) ──────────────────────────
(function () {
    var contextPath = document.querySelector('meta[name="contextPath"]')
        ? document.querySelector('meta[name="contextPath"]').content
        : '';

    document.querySelectorAll('form[action*="add-cart"]').forEach(function (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            e.stopPropagation();

            var productIdInput = form.querySelector('input[name="productId"]');
            if (!productIdInput) return;
            var productId = productIdInput.value;

            var btn = form.querySelector('button[type="submit"]');
            if (btn) btn.disabled = true;

            fetch(contextPath + '/add-cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'productId=' + encodeURIComponent(productId) + '&quantity=1'
            })
                .then(function (res) { return res.json(); })
                .then(function (result) {
                    if (typeof window.showGlobalToast === 'function') {
                        window.showGlobalToast(result.success ? 'success' : 'error', result.message);
                    }
                    if (result.success) {
                        var badge = document.getElementById('cart-badge');
                        if (badge) {
                            badge.textContent = result.cartTotalQuantity;
                            badge.style.display = 'inline-block';
                        } else if (result.cartTotalQuantity > 0) {
                            var cartLink = document.querySelector('a[href*="my-cart"]');
                            if (cartLink) {
                                var newBadge = document.createElement('span');
                                newBadge.id = 'cart-badge';
                                newBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill';
                                newBadge.style.display = 'inline-block';
                                newBadge.textContent = result.cartTotalQuantity;
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
        });
    });
})();

