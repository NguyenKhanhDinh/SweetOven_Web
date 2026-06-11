var contextPath = '';

document.addEventListener('DOMContentLoaded', function() {
    if (typeof CONTEXT_PATH !== 'undefined' && CONTEXT_PATH !== null) {
        contextPath = CONTEXT_PATH;
    } else {
        var path = window.location.pathname;
        var adminIndex = path.indexOf('/admin');
        if (adminIndex > 0) {
            contextPath = path.substring(0, adminIndex);
        } else {
            contextPath = '';
        }
    }

    console.log('Context Path:', contextPath);

    window.applyFilters = applyFilters;
    window.resetFilters = resetFilters;
    window.goToPage = goToPage;
    window.openEditModal = openEditModal;
    window.confirmDelete = confirmDelete;
});

function applyFilters() {
    var searchKeyword = document.getElementById('searchKeyword')?.value || '';
    var filterCategory = document.getElementById('filterCategory')?.value || '';
    var filterStatus = document.getElementById('filterStatus')?.value || '';
    var filterFeatured = document.getElementById('filterFeatured')?.value || '';
    var sortOrder = document.getElementById('sortOrder')?.value || '';

    var url = contextPath + '/admin/products?';
    var params = [];

    if (searchKeyword) params.push('searchKeyword=' + encodeURIComponent(searchKeyword));
    if (filterCategory) params.push('categoryId=' + encodeURIComponent(filterCategory));
    if (filterStatus) params.push('status=' + encodeURIComponent(filterStatus));
    if (filterFeatured) params.push('featured=' + encodeURIComponent(filterFeatured));
    if (sortOrder) params.push('sort=' + encodeURIComponent(sortOrder));

    params.push('page=1');

    window.location.href = url + params.join('&');
}

function resetFilters() {
    window.location.href = contextPath + '/admin/products';
}

function goToPage(page) {
    var urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    window.location.href = contextPath + '/admin/products?' + urlParams.toString();
}

function openEditModal(productId) {
    var url = contextPath + '/admin/products?action=api&id=' + productId;

    console.log('Fetching:', url);

    fetch(url)
        .then(function(response) {
            if (!response.ok) {
                throw new Error('HTTP error ' + response.status);
            }
            return response.json();
        })
        .then(function(product) {
            if (product.error) {
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: product.error
                });
                return;
            }

            document.getElementById('editId').value = product.id;
            document.getElementById('editProductCode').value = product.productCode || '';
            document.getElementById('editName').value = product.name || '';
            document.getElementById('editOriginalPrice').value = product.originalPrice || 0;
            document.getElementById('editDiscountPrice').value = product.discountPrice || '';
            document.getElementById('editStockQuantity').value = product.stockQuantity || 0;
            document.getElementById('editDescription').value = product.description || '';
            document.getElementById('editIngredients').value = product.ingredients || '';

            var categorySelect = document.getElementById('editCategoryId');

            if (categorySelect) {
                for (var i = 0; i < categorySelect.options.length; i++) {
                    if (categorySelect.options[i].value == product.categoryId) {
                        categorySelect.selectedIndex = i;
                        break;
                    }
                }
            }

            var statusSelect = document.getElementById('editStatus');
            if (statusSelect) {
                statusSelect.value = product.status;
            }

            var featuredCheckbox = document.getElementById('editFeatured');
            if (featuredCheckbox) {
                featuredCheckbox.checked = product.featured === true;
            }

            var imagesContainer = document.getElementById('currentImagesContainer');

            if (imagesContainer) {
                imagesContainer.innerHTML = '';

                if (product.image && product.image !== 'null' && product.image !== '') {
                    var imgSrc = '';

                    if (product.image.startsWith('http://') || product.image.startsWith('https://')) {
                        imgSrc = product.image; // Giữ nguyên link đám mây
                    } else {
                        imgSrc = product.image.startsWith('/')
                            ? contextPath + product.image
                            : contextPath + '/' + product.image;
                    }

                    imagesContainer.innerHTML =
                        '<div class="text-center">' +
                        '<img src="' + imgSrc + '" style="width:100px;height:100px;object-fit:cover;border-radius:8px;border:1px solid #ddd;">' +
                        '<br><small class="text-muted">Ảnh hiện tại</small>' +
                        '</div>';
                } else {
                    imagesContainer.innerHTML =
                        '<div class="text-muted text-center">Chưa có ảnh</div>';
                }
            }

            var editModal = new bootstrap.Modal(
                document.getElementById('editProductModal')
            );

            editModal.show();
        })
        .catch(function(error) {
            console.error('Error:', error);

            Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: 'Không thể tải thông tin sản phẩm! Chi tiết: ' + error.message
            });
        });
}

function confirmDelete(productId, productName) {
    Swal.fire({
        title: 'Xác nhận xóa',
        text: 'Bạn có chắc chắn muốn xóa sản phẩm "' + productName + '"?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy'
    }).then(function(result) {
        if (result.isConfirmed) {
            window.location.href =
                contextPath + '/admin/products?action=delete&id=' + productId;
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    var addForm = document.getElementById('addProductForm');

    if (addForm) {
        addForm.addEventListener('submit', function(e) {
            var name = document.getElementById('addProductName')?.value.trim();
            var categoryId = document.getElementById('addCategoryId')?.value;
            var originalPrice = document.getElementById('addOriginalPrice')?.value;
            var imageFile = document.querySelector(
                '#addProductModal input[name="imageFile"]'
            )?.files[0];

            if (!name) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng nhập tên sản phẩm!'
                });
            } else if (!categoryId) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng chọn danh mục!'
                });
            } else if (!originalPrice || parseFloat(originalPrice) <= 0) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng nhập giá gốc hợp lệ!'
                });
            } else if (!imageFile) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng chọn ảnh đại diện!'
                });
            }
        });
    }

    var editForm = document.getElementById('editProductForm');

    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            var name = document.getElementById('editName')?.value.trim();
            var categoryId = document.getElementById('editCategoryId')?.value;
            var originalPrice = document.getElementById('editOriginalPrice')?.value;

            if (!name) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng nhập tên sản phẩm!'
                });
            } else if (!categoryId) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng chọn danh mục!'
                });
            } else if (!originalPrice || parseFloat(originalPrice) <= 0) {
                e.preventDefault();

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Vui lòng nhập giá gốc hợp lệ!'
                });
            }
        });
    }

    var searchInput = document.getElementById('searchKeyword');

    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                applyFilters();
            }
        });
    }
});

document.addEventListener('DOMContentLoaded', function() {
    var urlParams = new URLSearchParams(window.location.search);
    var success = urlParams.get('success');
    var error = urlParams.get('error');

    if (success) {
        var msg = '';

        if (success === 'added') {
            msg = 'Thêm sản phẩm thành công! 🎉';
        } else if (success === 'updated') {
            msg = 'Cập nhật sản phẩm thành công! ✨';
        } else if (success === 'deleted') {
            msg = 'Xóa sản phẩm thành công! 🗑️';
        } else {
            msg = 'Thao tác thành công!';
        }

        Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000
        }).fire({
            icon: 'success',
            title: msg
        });
    }

    if (error) {
        var errMsg = 'Có lỗi xảy ra!';

        if (error === 'invalid_id') errMsg = 'ID sản phẩm không hợp lệ!';
        if (error === 'not_found') errMsg = 'Không tìm thấy sản phẩm!';
        if (error === 'delete_failed') errMsg = 'Xóa sản phẩm thất bại!';
        if (error === 'add_failed') errMsg = 'Thêm sản phẩm thất bại!';

        Swal.fire({
            icon: 'error',
            title: 'Thất bại',
            text: errMsg
        });
    }
});