(function () {
    const STORAGE_KEY = 'sweetoven_sidebar_collapsed';
    const sidebar = document.getElementById('sidebar');
    const btn     = document.getElementById('sidebarToggle');

    if (!sidebar || !btn) return;

    if (localStorage.getItem(STORAGE_KEY) === '1') {
        sidebar.classList.add('collapsed');
    }

    btn.addEventListener('click', function () {
        const collapsed = sidebar.classList.toggle('collapsed');
        localStorage.setItem(STORAGE_KEY, collapsed ? '1' : '0');
    });
})();