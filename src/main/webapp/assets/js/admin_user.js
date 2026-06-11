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
            if (modalEl) {
                const modal = new bootstrap.Modal(modalEl);
                modal.show();
            }
        }
    }

    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        let timer;
        searchInput.addEventListener('input', function () {
            clearTimeout(timer);
            timer = setTimeout(() => submitFilter(), 500);
        });
    }

    ['filterStatus', 'filterBlocked'].forEach(id => {
        const el = document.getElementById(id);
        if (el) el.addEventListener('change', () => submitFilter());
    });
});

function submitFilter() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const status  = document.getElementById('filterStatus')?.value ?? '-1';
    const blocked = document.getElementById('filterBlocked')?.value ?? '-1';

    const url = new URL(window.location.href);
    url.searchParams.set('keyword', keyword);
    url.searchParams.set('status',  status);
    url.searchParams.set('blocked', blocked);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function openViewModal(userId) {
    fetch(`${CONTEXT_PATH}/admin/users?action=api&id=${userId}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast('error', data.error); return; }

            const genderMap  = { 0: 'Khác', 1: 'Nam', 2: 'Nữ' };
            const statusMap  = { 0: '<span class="badge-status badge-inactive">Chưa xác thực</span>', 1: '<span class="badge-status badge-active">Đã xác thực</span>' };
            const blockedMap = { 0: '', 1: '<span class="badge-status badge-blocked">Đã khoá</span>' };
            const roleMap    = { 1: '<span class="badge-status badge-admin">Admin</span>', 2: '<span class="badge-status badge-user">Khách hàng</span>' };

            const avatarHtml = data.avatar
                ? `<img src="${data.avatar}" class="user-detail-avatar" alt="avatar">`
                : `<div class="user-detail-avatar-placeholder">${(data.fullName || '?').charAt(0).toUpperCase()}</div>`;

            document.getElementById('viewAvatarWrap').innerHTML  = avatarHtml;
            document.getElementById('viewFullName').textContent   = data.fullName     || '—';
            document.getElementById('viewUsername').textContent   = data.username     || '—';
            document.getElementById('viewEmail').textContent      = data.email        || '—';
            document.getElementById('viewPhone').textContent      = data.phoneNumber  || '—';
            document.getElementById('viewGender').textContent     = genderMap[data.gender]  || '—';
            document.getElementById('viewStatus').innerHTML       = statusMap[data.status]   || '—';
            document.getElementById('viewBlocked').innerHTML      = data.blocked ? blockedMap[1] : '(Không)';
            document.getElementById('viewRole').innerHTML         = roleMap[data.roleId]     || '—';
            document.getElementById('viewCreatedAt').textContent  = data.createdAt ? formatDateTime(data.createdAt) : '—';
            document.getElementById('viewOrderCount').textContent = data.orderCount ?? '—';

            const modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
            modal.show();
        })
        .catch(() => showToast('error', 'Không thể tải thông tin người dùng!'));
}

function openEditModal(userId) {
    fetch(`${CONTEXT_PATH}/admin/users?action=api&id=${userId}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast('error', data.error); return; }

            document.getElementById('editId').value       = data.id;
            document.getElementById('editFullName').value = data.fullName     || '';
            document.getElementById('editEmail').value    = data.email        || '';
            document.getElementById('editPhone').value    = data.phoneNumber  || '';
            document.getElementById('editGender').value   = data.gender ?? 0;

            const modal = new bootstrap.Modal(document.getElementById('editUserModal'));
            modal.show();
        })
        .catch(() => showToast('error', 'Không thể tải thông tin người dùng!'));
}

function confirmBlock(userId, userName) {
    Swal.fire({
        title: 'Khoá tài khoản?',
        html: `Bạn có chắc muốn khoá tài khoản <strong>${userName}</strong>?<br>Người dùng sẽ không thể đăng nhập.`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-lock me-1"></i> Khoá',
        cancelButtonText: 'Huỷ',
        borderRadius: '16px',
        customClass: { popup: 'swal-custom' }
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/users?action=block&id=${userId}${getFilterQS()}`;
        }
    });
}

function confirmUnblock(userId, userName) {
    Swal.fire({
        title: 'Mở khoá tài khoản?',
        html: `Bạn có chắc muốn mở khoá tài khoản <strong>${userName}</strong>?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-lock-open me-1"></i> Mở khoá',
        cancelButtonText: 'Huỷ',
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/users?action=unblock&id=${userId}${getFilterQS()}`;
        }
    });
}

function confirmResetPassword(userId, userName) {
    Swal.fire({
        title: 'Đặt lại mật khẩu?',
        html: `Mật khẩu của <strong>${userName}</strong> sẽ được đặt lại thành:<br>
               <code style="background:#f8f9fa;padding:6px 12px;border-radius:8px;font-size:1rem;margin-top:8px;display:inline-block">SweetOven@2024</code>`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3C2F27',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-key me-1"></i> Đặt lại',
        cancelButtonText: 'Huỷ',
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/users?action=resetPwd&id=${userId}`;
        }
    });
}

function getFilterQS() {
    const url = new URL(window.location.href);
    let qs = '';
    ['keyword','status','blocked','page'].forEach(k => {
        const v = url.searchParams.get(k);
        if (v) qs += `&${k}=${encodeURIComponent(v)}`;
    });
    return qs;
}

function formatDateTime(dateArr) {
    if (Array.isArray(dateArr) && dateArr.length >= 3) {
        const [y, mo, d, h = 0, min = 0] = dateArr;
        return `${String(d).padStart(2,'0')}/${String(mo).padStart(2,'0')}/${y} ${String(h).padStart(2,'0')}:${String(min).padStart(2,'0')}`;
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
        timerProgressBar: true,
    });
}