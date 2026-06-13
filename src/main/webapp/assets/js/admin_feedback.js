var contextPath = '';
var pendingReplyId = null;
var confirmReplyModal = null;

document.addEventListener('DOMContentLoaded', function() {
    const alertEl = document.getElementById('alertFloating');
    if (alertEl) {
        setTimeout(() => {
            alertEl.style.opacity = '0';
            alertEl.style.transition = 'opacity 0.5s';
            setTimeout(() => alertEl.remove(), 500);
        }, 4000);
    }

    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                submitFilter();
            }
        });
    }

    // Initialize confirm reply modal
    confirmReplyModal = new bootstrap.Modal(document.getElementById('confirmReplyDialog'));

    // Handle confirm send button
    document.getElementById('confirmSendBtn').addEventListener('click', function() {
        confirmSendEmail();
    });
});

function submitFilter() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const dateFrom = document.getElementById('filterDateFrom')?.value || '';
    const dateTo = document.getElementById('filterDateTo')?.value || '';

    const url = new URL(window.location.href);
    url.searchParams.set('keyword', keyword);
    url.searchParams.set('dateFrom', dateFrom);
    url.searchParams.set('dateTo', dateTo);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function resetFilter() {
    const url = new URL(window.location.href);
    url.searchParams.set('keyword', '');
    url.searchParams.set('dateFrom', '');
    url.searchParams.set('dateTo', '');
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function openViewModal(feedbackId) {
    fetch(`${CONTEXT_PATH}/admin/feedback?action=get-detail&id=${feedbackId}`)
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(data => {
            if (data.error) {
                showToast('error', data.error);
                return;
            }

            const formattedDate = data.createdAt ? formatDateTime(data.createdAt) : '—';
            const repliedAt = data.repliedAt ? formatDateTime(data.repliedAt) : null;

            let statusHtml = '';
            if (data.externalReplyStatus === 'replied' || data.status === 'replied') {
                statusHtml = '<span class="badge-status badge-replied"><i class="fas fa-check-circle"></i> Đã phản hồi</span>';
                if (repliedAt) {
                    statusHtml += `<small class="text-muted d-block mt-1">Ngày: ${repliedAt}</small>`;
                }
                if (data.repliedBy) {
                    statusHtml += `<small class="text-muted d-block">Bởi: ${escapeHtml(data.repliedBy)}</small>`;
                }
            } else if (data.externalReplyStatus === 'opened') {
                statusHtml = '<span class="badge-status badge-opened"><i class="fas fa-envelope-open"></i> Đã mở email</span>';
            } else {
                statusHtml = '<span class="badge-status badge-pending"><i class="fas fa-clock"></i> Chưa phản hồi</span>';
            }

            document.getElementById('modalFullName').textContent = data.fullName || '—';
            document.getElementById('modalEmail').textContent = data.email || '—';
            document.getElementById('modalPhone').textContent = data.phoneNumber || '—';
            document.getElementById('modalTime').textContent = formattedDate;
            document.getElementById('modalStatus').innerHTML = statusHtml;
            document.getElementById('modalContent').textContent = data.content || '—';

            // Show reply section if has reply
            const replySection = document.getElementById('replySection');
            const modalReply = document.getElementById('modalReply');
            if (data.reply) {
                replySection.style.display = 'block';
                modalReply.textContent = data.reply || '—';
            } else {
                replySection.style.display = 'none';
            }

            const modal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('error', 'Không thể tải thông tin phản hồi!');
        });
}

// Hàm mở Gmail và xử lý phản hồi
function openGmailAndReply(feedbackId, email, fullName) {
    // Gọi API để đánh dấu opened và chuyển hướng đến Gmail
    window.location.href = `${CONTEXT_PATH}/admin/feedback?action=mark-opened&id=${feedbackId}`;

    // Lưu ID để sử dụng sau khi quay lại trang
    pendingReplyId = feedbackId;

    // Lưu vào sessionStorage để khi quay lại trang vẫn nhớ
    sessionStorage.setItem('pendingReplyId', feedbackId);
    sessionStorage.setItem('pendingReplyEmail', email);
    sessionStorage.setItem('pendingReplyName', fullName);
}

// Hàm kiểm tra và hiển thị dialog xác nhận khi quay lại trang
function checkAndShowConfirmDialog() {
    const pendingId = sessionStorage.getItem('pendingReplyId');
    if (pendingId) {
        pendingReplyId = pendingId;
        // Hiển thị dialog hỏi đã gửi email chưa
        setTimeout(() => {
            if (confirmReplyModal) {
                confirmReplyModal.show();
            }
        }, 500);
    }
}

// Xác nhận đã gửi email
function confirmSendEmail() {
    if (!pendingReplyId) return;

    const replyContent = document.getElementById('replyContent').value;

    fetch(`${CONTEXT_PATH}/admin/feedback?action=confirm-replied`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `id=${pendingReplyId}&replyContent=${encodeURIComponent(replyContent)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('success', data.message);
            // Xóa session storage
            sessionStorage.removeItem('pendingReplyId');
            sessionStorage.removeItem('pendingReplyEmail');
            sessionStorage.removeItem('pendingReplyName');
            pendingReplyId = null;
            // Đóng dialog
            confirmReplyModal.hide();
            document.getElementById('replyContent').value = '';
            // Reload lại trang để cập nhật trạng thái
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        } else {
            showToast('error', data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('error', 'Có lỗi xảy ra!');
    });
}

// Kiểm tra khi trang load xong
document.addEventListener('DOMContentLoaded', function() {
    // ... existing code ...
    checkAndShowConfirmDialog();
});

function confirmDelete(feedbackId, senderName) {
    Swal.fire({
        title: 'Xóa phản hồi?',
        html: `Bạn có chắc muốn xóa phản hồi từ <strong>${escapeHtml(senderName)}</strong>?<br>Hành động này không thể hoàn tác.`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '<i class="fas fa-trash me-1"></i> Xóa',
        cancelButtonText: 'Hủy',
        customClass: {
            popup: 'swal-custom'
        }
    }).then(result => {
        if (result.isConfirmed) {
            window.location.href = `${CONTEXT_PATH}/admin/feedback?action=delete&id=${feedbackId}${getFilterQS()}`;
        }
    });
}

function getFilterQS() {
    const url = new URL(window.location.href);
    let qs = '';
    ['keyword', 'dateFrom', 'dateTo', 'page'].forEach(key => {
        const value = url.searchParams.get(key);
        if (value) {
            qs += `&${key}=${encodeURIComponent(value)}`;
        }
    });
    return qs;
}

function formatDateTime(dateStr) {
    if (!dateStr) return '—';
    try {
        let date = new Date(dateStr);
        if (isNaN(date.getTime())) {
            if (typeof dateStr === 'string') {
                return dateStr.replace('T', ' ').substring(0, 16);
            }
            return '—';
        }
        return date.toLocaleString('vi-VN');
    } catch(e) {
        return dateStr;
    }
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
        customClass: {
            popup: 'swal-custom-toast'
        }
    });
}

function escapeHtml(str) {
    if (!str) return '';
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function exportToExcel() {
    const keyword = document.getElementById('searchInput')?.value || '';
    const dateFrom = document.getElementById('filterDateFrom')?.value || '';
    const dateTo = document.getElementById('filterDateTo')?.value || '';
    window.location.href = `${CONTEXT_PATH}/admin/feedback?action=export&keyword=${encodeURIComponent(keyword)}&dateFrom=${dateFrom}&dateTo=${dateTo}`;
}

function printPage() {
    window.print();
}