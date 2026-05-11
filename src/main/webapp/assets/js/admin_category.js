    function previewImage(input, previewId) {
        const preview = document.getElementById(previewId);
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = '<img src="' + e.target.result + '" class="image-preview" alt="Preview">';
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.innerHTML = '';
        }
    }

    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const name = this.getAttribute('data-name');
            const description = this.getAttribute('data-description');
            let thumbnail = this.getAttribute('data-thumbnail');
            const status = this.getAttribute('data-status');

            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-description').value = description || '';
            document.getElementById('edit-status').value = status;

            const imgPreview = document.getElementById('current-thumbnail-preview');
            if (thumbnail && thumbnail !== 'null' && thumbnail.trim() !== '') {
                if (!thumbnail.startsWith('http') && !thumbnail.startsWith('/')) {
                    thumbnail = '${pageContext.request.contextPath}/' + thumbnail;
                }
                imgPreview.src = thumbnail;
                imgPreview.style.display = 'block';
                document.getElementById('current-image-container').style.display = 'block';
            } else {
                imgPreview.style.display = 'none';
                document.getElementById('current-image-container').style.display = 'none';
            }

            document.getElementById('edit-image-preview').innerHTML = '';
            document.getElementById('edit-thumbnail').value = '';
        });
    });

    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            const name = this.getAttribute('data-name');
            const hasProducts = this.getAttribute('data-has-products') === 'true';
            const productCount = this.getAttribute('data-product-count');

            const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            const messageEl = document.getElementById('delete-message');
            const warningEl = document.getElementById('delete-warning');
            const confirmBtn = document.getElementById('confirm-delete-btn');

            if (hasProducts) {
                messageEl.innerHTML = `Bạn có chắc chắn muốn xóa danh mục "<strong>${name}</strong>"?`;
                warningEl.style.display = 'block';
                warningEl.innerHTML = `<i class="fas fa-info-circle me-2"></i>Danh mục này đang có <strong>${productCount}</strong> sản phẩm. Xóa danh mục sẽ xóa toàn bộ sản phẩm thuộc danh mục này!`;
                confirmBtn.href = `${pageContext.request.contextPath}/admin/categories?action=delete&id=${id}&force=true`;
            } else {
                messageEl.innerHTML = `Bạn có chắc chắn muốn xóa danh mục "<strong>${name}</strong>"?`;
                warningEl.style.display = 'none';
                confirmBtn.href = `${pageContext.request.contextPath}/admin/categories?action=delete&id=${id}`;
            }

            deleteModal.show();
        });
    });

    function filterAll() {
        const rows = document.querySelectorAll('#categoryTable tbody tr');
        rows.forEach(row => row.style.display = '');
    }

    function filterActive() {
        const rows = document.querySelectorAll('#categoryTable tbody tr');
        rows.forEach(row => {
            const status = row.getAttribute('data-status');
            row.style.display = status === 'active' ? '' : 'none';
        });
    }

    function filterInactive() {
        const rows = document.querySelectorAll('#categoryTable tbody tr');
        rows.forEach(row => {
            const status = row.getAttribute('data-status');
            row.style.display = status === 'inactive' ? '' : 'none';
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');
        const error = urlParams.get('error');

        if (success) {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: success === 'added' ? 'Thêm danh mục thành công!' :
                      success === 'updated' ? 'Cập nhật danh mục thành công!' :
                      success === 'deleted' ? 'Xóa danh mục thành công!' : 'Thao tác thành công!',
                confirmButtonColor: '#8B4513'
            });
        } else if (error) {
            Swal.fire({
                icon: 'error',
                title: 'Lỗi!',
                text: error === 'has_products' ? 'Không thể xóa danh mục đang có sản phẩm!' :
                      error === 'not_found' ? 'Không tìm thấy danh mục!' : 'Có lỗi xảy ra!',
                confirmButtonColor: '#dc3545'
            });
        }
    });

    document.getElementById('addCategoryForm')?.addEventListener('submit', function(e) {
        const name = document.getElementById('add-name').value.trim();
        if (!name) {
            e.preventDefault();
            Swal.fire('Lỗi', 'Vui lòng nhập tên danh mục!', 'error');
        }
    });

    document.getElementById('editCategoryForm')?.addEventListener('submit', function(e) {
        const name = document.getElementById('edit-name').value.trim();
        if (!name) {
            e.preventDefault();
            Swal.fire('Lỗi', 'Vui lòng nhập tên danh mục!', 'error');
        }
    });
