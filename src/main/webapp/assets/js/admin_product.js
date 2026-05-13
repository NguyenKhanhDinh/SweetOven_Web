// Category code mapping
const categoryCodeMap = {
    1: 'BN',   // Bánh ngọt
    2: 'BM',   // Bánh mặn
    3: 'DN',   // Đồ nướng
    4: 'CB'    // Combo
};

// Auto-generate product code based on category
function generateProductCode() {
    const categoryId = document.getElementById('addCategoryId').value;
    if (categoryId && categoryCodeMap[categoryId]) {
        const prefix = categoryCodeMap[categoryId];
        const timestamp = Date.now().toString().slice(-4);
        const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        document.getElementById('addProductCode').value = `${prefix}-${timestamp}${random}`;
    }
}

// Apply filters
function applyFilters() {
    const search = document.getElementById('searchKeyword').value;
    const categoryId = document.getElementById('filterCategory').value;
    const status = document.getElementById('filterStatus').value;
    const featured = document.getElementById('filterFeatured').value;
    const sort = document.getElementById('sortOrder').value;

    let url = '${pageContext.request.contextPath}/admin/products?';
    if (search) url += 'search=' + encodeURIComponent(search) + '&';
    if (categoryId) url += 'categoryId=' + categoryId + '&';
    if (status !== '') url += 'status=' + status + '&';
    if (featured) url += 'featured=' + featured + '&';
    if (sort) url += 'sort=' + sort + '&';

    window.location.href = url;
}

function resetFilters() {
    window.location.href = '${pageContext.request.contextPath}/admin/products';
}

function goToPage(page) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    window.location.href = '${pageContext.request.contextPath}/admin/products?' + urlParams.toString();
}

function resolveImageUrl(url) {
    if (!url) return '';
    if (url.startsWith('http')) return url;
    if (url.startsWith('/')) return '${pageContext.request.contextPath}' + url;
    return '${pageContext.request.contextPath}/' + url;
}

// Open edit modal
function openEditModal(productId) {
    fetch('${pageContext.request.contextPath}/admin/products?action=get-detail&id=' + productId)
        .then(response => {
            if (!response.ok) throw new Error('Network error');
            return response.json();
        })
        .then(data => {
            document.getElementById('editId').value = data.id;
            document.getElementById('editProductCode').value = data.productCode;
            document.getElementById('editName').value = data.name;
            document.getElementById('editCategoryId').value = data.categoryId;
            document.getElementById('editOriginalPrice').value = data.originalPrice;
            document.getElementById('editDiscountPrice').value = data.discountPrice || '';
            document.getElementById('editStockQuantity').value = data.stockQuantity;
            document.getElementById('editStatus').value = data.status;
            document.getElementById('editFeatured').checked = data.featured;
            document.getElementById('editDescription').value = data.description || '';
            document.getElementById('editIngredients').value = data.ingredients || '';

            let imagesHtml = '';
            if (data.image) {
                imagesHtml += `<div class="text-center"><img src="${resolveImageUrl(data.image)}" height="80" class="border rounded mb-1"><br><small class="text-primary">Ảnh chính</small></div>`;
            }
            if (data.listImages && data.listImages.length > 0) {
                data.listImages.forEach(img => {
                    if (!img.primary) {
                        imagesHtml += `<div class="text-center"><img src="${resolveImageUrl(img.imageUrl)}" height="80" class="border rounded mb-1"><br><small>Ảnh phụ</small></div>`;
                    }
                });
            }
            if (!imagesHtml) imagesHtml = '<span class="text-muted">Chưa có ảnh</span>';
            document.getElementById('currentImagesContainer').innerHTML = imagesHtml;

            new bootstrap.Modal(document.getElementById('editProductModal')).show();
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire('Lỗi!', 'Không thể tải thông tin sản phẩm', 'error');
        });
}

// Confirm delete with SweetAlert2
function confirmDelete(productId, productName) {
    Swal.fire({
        title: 'Xác nhận xóa?',
        html: `Bạn có chắc chắn muốn xóa sản phẩm <strong>${productName}</strong>?<br><span class="text-warning">Sản phẩm sẽ bị ẩn khỏi hệ thống (xóa mềm)</span>`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Vâng, xóa!',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/admin/products?action=delete&id=' + productId;
        }
    });
}

// Auto show add modal if error occurred
<c:if test="${not empty error and param.showAdd == 'true'}">
    var addModal = new bootstrap.Modal(document.getElementById('addProductModal'));
    addModal.show();
</c:if>

// Validate discount price <= original price
document.getElementById('addProductForm')?.addEventListener('submit', function(e) {
    const original = parseFloat(document.getElementById('addOriginalPrice').value);
    const discount = parseFloat(document.getElementById('addDiscountPrice').value);
    if (discount && discount > original) {
        e.preventDefault();
        Swal.fire('Lỗi!', 'Giá khuyến mãi không được lớn hơn giá gốc', 'error');
    }
});

document.getElementById('editProductForm')?.addEventListener('submit', function(e) {
    const original = parseFloat(document.getElementById('editOriginalPrice').value);
    const discount = parseFloat(document.getElementById('editDiscountPrice').value);
    if (discount && discount > original) {
        e.preventDefault();
        Swal.fire('Lỗi!', 'Giá khuyến mãi không được lớn hơn giá gốc', 'error');
    }
});
