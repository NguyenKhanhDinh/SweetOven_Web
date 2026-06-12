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

    const editForm = document.querySelector('#editUserModal form');
    if (editForm) {
        editForm.addEventListener('submit', function (e) {
            const pwd     = document.getElementById('editNewPassword').value;
            const confirm = document.getElementById('editConfirmPassword').value;
            if (pwd && pwd !== confirm) {
                e.preventDefault();
                showToast('error', 'Mật khẩu xác nhận không khớp!');
            }
        });
    }
});

function submitFilter() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const blocked = document.getElementById('filterBlocked')?.value ?? '-1';
    const role   = document.getElementById('filterRole')?.value ?? '-1';
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', keyword);
    url.searchParams.set('blocked', blocked);
    url.searchParams.set('role',    role);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function resetFilter() {
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', '');
    url.searchParams.set('blocked', '-1');
    url.searchParams.set('role',    '-1');
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
            const blockedMap = { 1: '<span class="badge-status badge-blocked">Đã khoá</span>' };
            const roleMap    = { 1: '<span class="badge-status badge-admin">Admin</span>', 2: '<span class="badge-status badge-user">Khách hàng</span>' };

            const avatarHtml = data.avatar
                ? `<img src="${data.avatar}" class="user-detail-avatar" alt="avatar">`
                : `<div class="user-detail-avatar-placeholder">${(data.fullName || '?').charAt(0).toUpperCase()}</div>`;

            document.getElementById('viewAvatarWrap').innerHTML  = avatarHtml;
            document.getElementById('viewFullName').textContent   = data.fullName    || '—';
            document.getElementById('viewUsername').textContent   = data.username    || '—';
            document.getElementById('viewEmail').textContent      = data.email       || '—';
            document.getElementById('viewPhone').textContent      = data.phoneNumber || '—';
            document.getElementById('viewGender').textContent     = genderMap[data.gender]  || '—';
            document.getElementById('viewStatus').innerHTML       = statusMap[data.status]   || '—';
            document.getElementById('viewBlocked').innerHTML      = data.blocked ? blockedMap[1] : '(Không)';
            document.getElementById('viewRole').innerHTML         = roleMap[data.roleId]     || '—';
            document.getElementById('viewCreatedAt').textContent  = data.createdAt ? formatDateTime(data.createdAt) : '—';
            document.getElementById('viewOrderCount').textContent = data.orderCount ?? '—';

            new bootstrap.Modal(document.getElementById('viewUserModal')).show();
        })
        .catch(() => showToast('error', 'Không thể tải thông tin người dùng!'));
}

function openEditModal(userId) {
    fetch(`${CONTEXT_PATH}/admin/users?action=api&id=${userId}`)
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast('error', data.error); return; }
            document.getElementById('editId').value               = data.id;
            document.getElementById('editFullName').value         = data.fullName    || '';
            document.getElementById('editEmail').value            = data.email       || '';
            document.getElementById('editPhone').value            = data.phoneNumber || '';
            document.getElementById('editGender').value           = data.gender ?? 0;
            document.getElementById('editNewPassword').value      = '';
            document.getElementById('editConfirmPassword').value  = '';
            document.getElementById('pwdMatchMsg').innerHTML      = '';
            new bootstrap.Modal(document.getElementById('editUserModal')).show();
        })
        .catch(() => showToast('error', 'Không thể tải thông tin người dùng!'));
}

function togglePwd(inputId, btn) {
    const input = document.getElementById(inputId);
    const icon  = btn.querySelector('i');
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

function checkPwdMatch() {
    const pwd     = document.getElementById('editNewPassword').value;
    const confirm = document.getElementById('editConfirmPassword').value;
    const msg     = document.getElementById('pwdMatchMsg');
    if (!confirm) { msg.innerHTML = ''; return; }
    if (pwd === confirm) {
        msg.innerHTML = '<span style="color:#28a745"><i class="fas fa-check-circle me-1"></i>Mật khẩu khớp</span>';
    } else {
        msg.innerHTML = '<span style="color:#dc3545"><i class="fas fa-times-circle me-1"></i>Mật khẩu không khớp</span>';
    }
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
        customClass: { popup: 'swal-custom' }
    }).then(result => {
        if (result.isConfirmed)
            window.location.href = `${CONTEXT_PATH}/admin/users?action=block&id=${userId}${getFilterQS()}`;
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
        if (result.isConfirmed)
            window.location.href = `${CONTEXT_PATH}/admin/users?action=unblock&id=${userId}${getFilterQS()}`;
    });
}

function confirmActivate(userId, userName) {
    Swal.fire({
        title: 'Kích hoạt tài khoản?',
        html: `Bạn có chắc muốn kích hoạt tài khoản <strong>${userName}</strong>?<br><small style="color:#888">Tài khoản sẽ được xác thực và có thể đăng nhập ngay.</small>`,
        icon: 'info',
        showCancelButton: true,
        confirmButtonColor: '#0d6efd',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-user-check me-1"></i> Kích hoạt',
        cancelButtonText: 'Huỷ',
    }).then(result => {
        if (result.isConfirmed)
            window.location.href = `${CONTEXT_PATH}/admin/users?action=activate&id=${userId}${getFilterQS()}`;
    });
}

function getFilterQS() {
    const url = new URL(window.location.href);
    let qs = '';
    ['keyword', 'blocked', 'role', 'page'].forEach(k => {
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