
    const CONTEXT_PATH = '${pageContext.request.contextPath}';

    function applyFilters() {
        const searchKeyword = document.getElementById('searchKeyword').value;
        const categoryId = document.getElementById('filterCategory').value;
        const status = document.getElementById('filterStatus').value;
        const featured = document.getElementById('filterFeatured').value;
        const sort = document.getElementById('sortOrder').value;

        let url = CONTEXT_PATH + '/admin/products?';
        if (searchKeyword) url += 'searchKeyword=' + encodeURIComponent(searchKeyword) + '&';
        if (categoryId) url += 'categoryId=' + categoryId + '&';
        if (status !== '') url += 'status=' + status + '&';
        if (featured) url += 'featured=' + featured + '&';
        if (sort) url += 'sort=' + sort + '&';

        window.location.href = url;
    }

    function resetFilters() {
        window.location.href = CONTEXT_PATH + '/admin/products';
    }

    function goToPage(page) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('page', page);
        window.location.href = CONTEXT_PATH + '/admin/products?' + urlParams.toString();
    }

    function resolveImageUrl(url) {
        if (!url) return '';
        if (url.startsWith('http')) return url;
        if (url.startsWith('/')) return CONTEXT_PATH + url;
        return CONTEXT_PATH + '/' + url;
    }

    function openEditModal(productId) {
        fetch(CONTEXT_PATH + '/admin/products?action=get-detail&id=' + productId)
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
                    imagesHtml = '<div class="text-center"><img src="' + resolveImageUrl(data.image) + '" height="80" class="border rounded mb-1"><br><small class="text-primary">Ảnh chính</small></div>';
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

    function confirmDelete(productId, productName) {
        Swal.fire({
            title: 'Xác nhận xóa?',
            html: 'Bạn có chắc chắn muốn xóa sản phẩm <strong>' + productName + '</strong>?<br><span class="text-danger">Hành động này sẽ xóa vĩnh viễn sản phẩm khỏi hệ thống!</span>',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Vâng, xóa!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = CONTEXT_PATH + '/admin/products?action=delete&id=' + productId;
            }
        });
    }

    document.getElementById('addProductModal')?.addEventListener('show.bs.modal', function() {
        document.getElementById('addProductForm').reset();
        document.getElementById('addProductCode').value = '(sẽ tự động sinh khi lưu)';
        document.getElementById('addProductCode').style.color = '#999';
    });

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
