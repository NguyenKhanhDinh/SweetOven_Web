document.getElementById('searchInput')?.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') submitFilter();
});

function submitFilter() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const status  = document.getElementById('filterStatus')?.value ?? '-1';
    const url = new URL(window.location.href);
    url.searchParams.set('search', keyword);
    url.searchParams.set('status', status);
    window.location.href = url.toString();
}

function resetFilter() {
    const url = new URL(window.location.href);
    url.searchParams.set('search', '');
    url.searchParams.set('status', '-1');
    window.location.href = url.toString();
}

function previewImage(input, previewId) {
    const preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.innerHTML = `<img src="${e.target.result}" class="image-preview mt-2" style="max-height: 120px; border-radius: 8px;" alt="Preview">`;
        };
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.innerHTML = '';
    }
}

document.querySelectorAll('.btn-edit').forEach(btn => {
    btn.addEventListener('click', function () {
        const id = this.getAttribute('data-id');
        const name = this.getAttribute('data-name');
        const description = this.getAttribute('data-description');
        const status = this.getAttribute('data-status');
        let thumbnail = this.getAttribute('data-thumbnail');

        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-description').value = description || '';
        document.getElementById('edit-status').value = status;

        const imageContainer = document.getElementById('current-image-container');
        const imagePreview = document.getElementById('current-thumbnail-preview');

        if (thumbnail && thumbnail !== 'null' && thumbnail.trim() !== '') {
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/admin'));
            imagePreview.src = (thumbnail.startsWith('http') || thumbnail.startsWith('/')) ? thumbnail : `${contextPath}/${thumbnail}`;
            imageContainer.style.display = 'block';
        } else {
            imageContainer.style.display = 'none';
        }
        document.getElementById('edit-thumbnail').value = '';
        document.getElementById('edit-image-preview').innerHTML = '';
    });
});

document.querySelectorAll('.btn-delete').forEach(btn => {
    btn.addEventListener('click', function () {
        const id = this.getAttribute('data-id');
        const name = this.getAttribute('data-name');
        const productCount = parseInt(this.getAttribute('data-product-count')) || 0;

        let warningText = `Bạn có chắc chắn muốn xóa danh mục "${name}" không?`;
        let iconType = 'question';

        if (productCount > 0) {
            warningText = `Danh mục "${name}" đang có chứa ${productCount} sản phẩm! Hệ thống sẽ thực hiện xóa danh mục này.`;
            iconType = 'warning';
        }

        Swal.fire({
            title: 'Xác nhận xóa danh mục?',
            text: warningText,
            icon: iconType,
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: '<i class="fas fa-trash-alt me-1"></i> Đồng ý xóa',
            cancelButtonText: 'Hủy bỏ',
            background: '#ffffff'
        }).then((result) => {
            if (result.isConfirmed) {
                const currentPath = window.location.pathname;
                if (productCount > 0) {
                    window.location.href = `${currentPath}?action=delete&id=${id}&force=true`;
                } else {
                    window.location.href = `${currentPath}?action=delete&id=${id}`;
                }
            }
        });
    });
});

function filterAll() {
    document.querySelectorAll('#categoryTable tbody tr').forEach(row => row.style.display = '');
}

function filterActive() {
    document.querySelectorAll('#categoryTable tbody tr').forEach(row => {
        row.style.display = row.dataset.status === 'active' ? '' : 'none';
    });
}

function filterInactive() {
    document.querySelectorAll('#categoryTable tbody tr').forEach(row => {
        row.style.display = row.dataset.status === 'inactive' ? '' : 'none';
    });
}

document.addEventListener('DOMContentLoaded', function () {
    const urlParams = new URLSearchParams(window.location.search);
    const success = urlParams.get('success');
    const error = urlParams.get('error');

    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });

    if (success) {
        let msg = 'Thao tác thực hiện thành công!';
        if (success === 'added') msg = 'Thêm danh mục mới thành công! 🎉';
        if (success === 'updated') msg = 'Cập nhật danh mục thành công! ✨';
        if (success === 'deleted') msg = 'Xóa dữ liệu danh mục thành công! 🗑️';

        Toast.fire({ icon: 'success', title: msg });
    }

    if (error) {
        let errMsg = 'Đã có lỗi xảy ra trong quá trình xử lý';
        if (error === 'has_products') errMsg = 'Danh mục đang có chứa sản phẩm, không thể xóa!';
        if (error === 'not_found') errMsg = 'Không tồn tại hoặc không tìm thấy danh mục yêu cầu!';

        Swal.fire({
            icon: 'error',
            title: 'Thao tác thất bại',
            text: errMsg,
            confirmButtonColor: '#8B4513'
        });
    }
});

document.getElementById('addCategoryForm')?.addEventListener('submit', function (e) {
    if (!document.getElementById('add-name').value.trim()) {
        e.preventDefault();
        Swal.fire({ icon: 'error', title: 'Thiếu dữ liệu', text: 'Tên danh mục bắt buộc không được bỏ trống!' });
    }
});

document.getElementById('editCategoryForm')?.addEventListener('submit', function (e) {
    if (!document.getElementById('edit-name').value.trim()) {
        e.preventDefault();
        Swal.fire({ icon: 'error', title: 'Thiếu dữ liệu', text: 'Tên danh mục bắt buộc không được bỏ trống!' });
    }
});