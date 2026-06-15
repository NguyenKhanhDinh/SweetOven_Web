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
    window.removeFilter = removeFilter;

    buildActiveFilters();
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

function removeFilter(key) {
    var urlParams = new URLSearchParams(window.location.search);
    urlParams.delete(key);
    urlParams.set('page', '1');

    var query = urlParams.toString();
    window.location.href = contextPath + '/admin/products' + (query ? '?' + query : '');
}

function buildActiveFilters() {
    var bar = document.getElementById('activeFiltersBar');
    var list = document.getElementById('activeFiltersList');

    if (!bar || !list) return;

    var urlParams = new URLSearchParams(window.location.search);
    var filters = [];

    var labelOf = function(selectId) {
        var select = document.getElementById(selectId);
        if (!select || select.selectedIndex < 0) return '';
        return select.options[select.selectedIndex].text;
    };

    var searchValue = (urlParams.get('searchKeyword') || '').trim();
    if (searchValue) {
        filters.push({ key: 'searchKeyword', label: 'Từ khoá: "' + searchValue + '"' });
    }

    if (urlParams.get('categoryId')) {
        filters.push({ key: 'categoryId', label: 'Danh mục: ' + labelOf('filterCategory') });
    }

    if (urlParams.get('status') !== null && urlParams.get('status') !== '') {
        filters.push({ key: 'status', label: 'Trạng thái: ' + labelOf('filterStatus') });
    }

    if (urlParams.get('featured') !== null && urlParams.get('featured') !== '') {
        filters.push({ key: 'featured', label: labelOf('filterFeatured') });
    }

    if (urlParams.get('sort')) {
        filters.push({ key: 'sort', label: 'Sắp xếp: ' + labelOf('sortOrder') });
    }

    list.innerHTML = '';

    filters.forEach(function(filter) {
        var chip = document.createElement('span');
        chip.className = 'filter-chip';

        var label = document.createElement('span');
        label.textContent = filter.label;

        var removeIcon = document.createElement('i');
        removeIcon.className = 'fas fa-xmark';
        removeIcon.title = 'Bỏ bộ lọc này';
        removeIcon.addEventListener('click', function() {
            removeFilter(filter.key);
        });

        chip.appendChild(label);
        chip.appendChild(removeIcon);
        list.appendChild(chip);
    });

    bar.classList.toggle('show', filters.length > 0);
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
                showToast('error', product.error);
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
                featuredCheckbox.checked = product.featured === true || product.featured === 'true';
            }

            var imagesContainer = document.getElementById('currentImagesContainer');

            if (imagesContainer) {
                imagesContainer.innerHTML = '';

                if (product.image && product.image !== 'null' && product.image !== '') {
                    var imgSrc = '';

                    if (product.image.startsWith('http://') || product.image.startsWith('https://')) {
                        imgSrc = product.image;
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

            showToast('error', 'Không thể tải thông tin sản phẩm! Chi tiết: ' + error.message);
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
            e.preventDefault();

            var name = document.getElementById('addProductName')?.value.trim();
            var categoryId = document.getElementById('addCategoryId')?.value;
            var originalPrice = document.getElementById('addOriginalPrice')?.value;
            var imageFile = document.querySelector(
                '#addProductModal input[name="imageFile"]'
            )?.files[0];

            if (!name) {
                showToast('error', 'Vui lòng nhập tên sản phẩm!');
                return;
            } else if (!categoryId) {
                showToast('error', 'Vui lòng chọn danh mục!');
                return;
            } else if (!originalPrice || parseFloat(originalPrice) <= 0) {
                showToast('error', 'Vui lòng nhập giá gốc hợp lệ!');
                return;
            } else if (!imageFile) {
                showToast('error', 'Vui lòng chọn ảnh đại diện!');
                return;
            }

            submitProductForm(addForm, 'addProductModal');
        });
    }

    var editForm = document.getElementById('editProductForm');

    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            e.preventDefault();

            var name = document.getElementById('editName')?.value.trim();
            var categoryId = document.getElementById('editCategoryId')?.value;
            var originalPrice = document.getElementById('editOriginalPrice')?.value;

            if (!name) {
                showToast('error', 'Vui lòng nhập tên sản phẩm!');
                return;
            } else if (!categoryId) {
                showToast('error', 'Vui lòng chọn danh mục!');
                return;
            } else if (!originalPrice || parseFloat(originalPrice) <= 0) {
                showToast('error', 'Vui lòng nhập giá gốc hợp lệ!');
                return;
            }

            submitProductForm(editForm, 'editProductModal');
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

function submitProductForm(form, modalId) {
    var submitBtn = form.querySelector('button[type="submit"]');
    var originalBtnHtml = submitBtn ? submitBtn.innerHTML : '';

    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang lưu...';
    }

    var formData = new FormData(form);
    var actionUrl = form.getAttribute('action');

    fetch(actionUrl, {
        method: 'POST',
        body: formData,
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
        .then(function(response) {
            return response.text().then(function(text) {
                try {
                    return JSON.parse(text);
                } catch (e) {
                    throw new Error('not_json');
                }
            });
        })
        .then(function(data) {
            if (data.success) {
                var modalEl = document.getElementById(modalId);
                var modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();

                if (form.id === 'addProductForm') {
                    form.reset();
                }

                showToast('success', data.message || 'Thao tác thành công!');
                refreshProductList();
            } else {
                showToast('error', data.message || 'Có lỗi xảy ra, vui lòng thử lại!');
            }
        })
        .catch(function() {
            showToast('error', 'Có lỗi xảy ra, vui lòng thử lại!');
        })
        .finally(function() {
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnHtml;
            }
        });
}

function refreshProductList() {
    fetch(window.location.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
        .then(function(response) { return response.text(); })
        .then(function(html) {
            var parser = new DOMParser();
            var doc = parser.parseFromString(html, 'text/html');

            var newStats = doc.querySelector('.stats-row');
            var oldStats = document.querySelector('.stats-row');
            if (newStats && oldStats) {
                oldStats.innerHTML = newStats.innerHTML;
            }

            var newTableCard = doc.querySelector('.table-card');
            var oldTableCard = document.querySelector('.table-card');
            if (newTableCard && oldTableCard) {
                oldTableCard.innerHTML = newTableCard.innerHTML;
            }

            buildActiveFilters();
        })
        .catch(function() {
            window.location.reload();
        });
}

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

        showToast('success', msg);
    }

    if (error) {
        var errMsg = 'Có lỗi xảy ra!';

        if (error === 'invalid_id') errMsg = 'ID sản phẩm không hợp lệ!';
        if (error === 'not_found') errMsg = 'Không tìm thấy sản phẩm!';
        if (error === 'delete_failed') errMsg = 'Xóa sản phẩm thất bại!';
        if (error === 'add_failed') errMsg = 'Thêm sản phẩm thất bại!';

        showToast('error', errMsg);
    }
});

function showToast(type, msg) {
    var existing = document.getElementById('alertFloating');
    if (existing) existing.remove();

    var icon = (type === 'success') ? 'fa-check-circle' : 'fa-exclamation-circle';
    var cls = (type === 'success') ? 'alert-success' : 'alert-danger';

    var el = document.createElement('div');
    el.id = 'alertFloating';
    el.className = 'alert-floating ' + cls;
    el.innerHTML = '<i class="fas ' + icon + '"></i> ' + msg;

    document.body.appendChild(el);

    setTimeout(function() {
        el.style.opacity = '0';
        el.style.transition = 'opacity 0.5s';
        setTimeout(function() { el.remove(); }, 500);
    }, 4000);
}