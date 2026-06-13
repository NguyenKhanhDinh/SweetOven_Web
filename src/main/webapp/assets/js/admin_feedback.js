var contextPath = '';
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

            document.getElementById('modalFullName').textContent = data.fullName || '—';
            document.getElementById('modalEmail').textContent = data.email || '—';
            document.getElementById('modalPhone').textContent = data.phoneNumber || '—';
            document.getElementById('modalTime').textContent = formattedDate;
            document.getElementById('modalContent').textContent = data.content || '—';

            const replyBtn = document.getElementById('btnReplyEmail');
            if (replyBtn && data.email) {
                replyBtn.href = `mailto:${data.email}?subject=Phản hồi từ Sweet Oven&body=Chào ${data.fullName || ''},%0D%0A%0D%0ACảm ơn bạn đã gửi phản hồi đến Sweet Oven.%0D%0A%0D%0A`;
            }

            const modal = new bootstrap.Modal(document.getElementById('viewFeedbackModal'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('error', 'Không thể tải thông tin phản hồi!');
        });
}


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


function formatDateTime(dateArr) {
    if (Array.isArray(dateArr) && dateArr.length >= 3) {
        const [y, mo, d, h = 0, min = 0] = dateArr;
        return `${String(d).padStart(2, '0')}/${String(mo).padStart(2, '0')}/${y} ${String(h).padStart(2, '0')}:${String(min).padStart(2, '0')}`;
    }
    if (typeof dateArr === 'string') {
        return dateArr.replace('T', ' ').substring(0, 16);
    }
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