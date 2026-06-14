document.addEventListener('DOMContentLoaded', function () {
    const alertEl = document.getElementById('alertFloating');
    if (alertEl) {
        setTimeout(() => {
            alertEl.style.opacity = '0';
            alertEl.style.transition = 'opacity 0.5s';
            setTimeout(() => alertEl.remove(), 500);
        }, 4000);
    }

    const openModal = document.getElementById('autoOpenModal');
    if (openModal) {
        const modalId = openModal.value;
        if (modalId) {
            const modalEl = document.getElementById(modalId);
            if (modalEl) new bootstrap.Modal(modalEl).show();
        }
    }

    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') submitFilter();
        });
    }

    const addForm = document.querySelector('#addBannerForm');
    if (addForm) {
        addForm.addEventListener('submit', function (e) {
            const imageFile = document.getElementById('addImageFile');
            if (imageFile && imageFile.files.length === 0) {
                e.preventDefault();
                showToast('error', 'Vui lòng chọn hình ảnh cho banner!');
            }
        });
    }
});

function previewImage(inputElement, imgId, boxId) {
    const file = inputElement.files[0];
    const img = document.getElementById(imgId);
    const box = document.getElementById(boxId);

    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            img.src = e.target.result;
            if (box) {
                box.style.display = 'block';
            }
            img.style.display = 'block';
        };
        reader.readAsDataURL(file);
    } else {
        if (box) box.style.display = 'none';
        if (img) img.src = '';
    }
}

function submitFilter() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const status = document.getElementById('filterStatus')?.value ?? '-1';
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', keyword);
    url.searchParams.set('status', status);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function resetFilter() {
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', '');
    url.searchParams.set('status', '-1');
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function openViewModal(bannerId) {
    fetch(`${CONTEXT_PATH}/admin/banners?action=api&id=${bannerId}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) {
                showToast('error', data.error);
                return;
            }

            const statusHtml = data.isActive
                ? '<span class="status-badge status-active"><i class="fas fa-check-circle"></i> Đang hoạt động</span>'
                : '<span class="status-badge status-inactive"><i class="fas fa-pause-circle"></i> Ngừng hoạt động</span>';

            const imageHtml = data.bannerImageUrl
                ? `<img src="${data.bannerImageUrl}" class="banner-detail-image" alt="banner">`
                : '<div class="banner-thumb-placeholder" style="width:100%;height:150px;margin-bottom:12px"><i class="fas fa-image fa-3x"></i></div>';

            document.getElementById('viewImageWrap').innerHTML = imageHtml;
            document.getElementById('viewTitle').textContent = data.title || '—';
            document.getElementById('viewDescription').textContent = data.description || '—';
            document.getElementById('viewStatus').innerHTML = statusHtml;
            document.getElementById('viewCreatedAt').textContent = data.createdAt ? formatDateTime(data.createdAt) : '—';
            document.getElementById('viewUpdatedAt').textContent = data.updatedAt ? formatDateTime(data.updatedAt) : '—';

            new bootstrap.Modal(document.getElementById('viewBannerModal')).show();
        })
        .catch(() => showToast('error', 'Không thể tải thông tin banner!'));
}

function openEditModal(bannerId) {
    fetch(`${CONTEXT_PATH}/admin/banners?action=api&id=${bannerId}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) {
                showToast('error', data.error);
                return;
            }

            document.getElementById('editId').value = data.id;
            document.getElementById('editTitle').value = data.title || '';
            document.getElementById('editDescription').value = data.description || '';
            document.getElementById('editIsActive').checked = data.isActive;
            document.getElementById('editExistingImageUrl').value = data.bannerImageUrl || '';

            // Clear file input and preview
            document.getElementById('editImageFile').value = '';
            const previewBox = document.getElementById('editPreviewBox');
            const previewImg = document.getElementById('editPreview');
            if (previewBox) previewBox.style.display = 'none';
            if (previewImg) previewImg.src = '';

            new bootstrap.Modal(document.getElementById('editBannerModal')).show();
        })
        .catch(() => showToast('error', 'Không thể tải thông tin banner!'));
}

function confirmActivate(bannerId, bannerTitle) {
    Swal.fire({
        title: 'Kích hoạt banner?',
        html: `Bạn có chắc muốn kích hoạt banner <strong>${bannerTitle}</strong>?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-play me-1"></i> Kích hoạt',
        cancelButtonText: 'Huỷ'
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/banners?action=activate&id=${bannerId}${getFilterQS()}`;
        }
    });
}

function confirmDeactivate(bannerId, bannerTitle) {
    Swal.fire({
        title: 'Ngừng hoạt động banner?',
        html: `Bạn có chắc muốn ngừng hoạt động banner <strong>${bannerTitle}</strong>?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-pause me-1"></i> Ngừng',
        cancelButtonText: 'Huỷ'
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/banners?action=deactivate&id=${bannerId}${getFilterQS()}`;
        }
    });
}

function confirmDelete(bannerId, bannerTitle) {
    Swal.fire({
        title: 'Xóa banner?',
        html: `Bạn có chắc muốn xóa banner <strong>${bannerTitle}</strong>?<br><small style="color:#888">Hành động này không thể hoàn tác.</small>`,
        icon: 'error',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-trash me-1"></i> Xóa',
        cancelButtonText: 'Huỷ'
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/banners?action=delete&id=${bannerId}${getFilterQS()}`;
        }
    });
}

function getFilterQS() {
    const url = new URL(window.location.href);
    let qs = '';
    ['keyword', 'status', 'page'].forEach(k => {
        const v = url.searchParams.get(k);
        if (v && v !== '-1') qs += `&${k}=${encodeURIComponent(v)}`;
    });
    return qs;
}

function formatDateTime(dateArr) {
    if (Array.isArray(dateArr) && dateArr.length >= 3) {
        const [y, mo, d, h = 0, min = 0] = dateArr;
        return `${String(d).padStart(2, '0')}/${String(mo).padStart(2, '0')}/${y} ${String(h).padStart(2, '0')}:${String(min).padStart(2, '0')}`;
    }
    if (typeof dateArr === 'string') return dateArr.replace('T', ' ').substring(0, 16);
    return '—';
}

function showToast(type, msg) {
    Swal.fire({
        toast: true,
        position: 'top-end',
        icon: type,
        title: msg,
        showConfirmButton: false,
        timer: 3500,
        timerProgressBar: true
    });
}