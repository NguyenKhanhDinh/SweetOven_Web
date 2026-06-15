document.addEventListener('DOMContentLoaded', function () {


    function updateClock() {
        const el = document.getElementById('clockText');
        if (!el) return;
        el.textContent = new Date().toLocaleString('vi-VN', {
            weekday: 'short', day: '2-digit', month: '2-digit',
            year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit'
        });
    }
    updateClock();
    setInterval(updateClock, 1000);


    Chart.defaults.font.family = "Quicksand, sans-serif";
    Chart.defaults.color = "#7a6d62";

    const formatVND = (v) =>
        new Intl.NumberFormat('vi-VN').format(Math.round(v)) + ' VNĐ';

    const shortVND = (v) => {
        if (v >= 1_000_000_000) return (v / 1_000_000_000).toFixed(1).replace(/\.0$/, '') + ' tỷ';
        if (v >= 1_000_000)     return (v / 1_000_000).toFixed(1).replace(/\.0$/, '') + ' tr';
        if (v >= 1_000)         return (v / 1_000).toFixed(0) + ' k';
        return v;
    };

    const tooltip = {
        backgroundColor: '#3C2F27',
        titleColor: '#fff',
        bodyColor: '#ffedd5',
        padding: 12, cornerRadius: 10,
        displayColors: false,
        titleFont: { weight: 700, size: 12 },
        bodyFont: { weight: 600, size: 13 },
        callbacks: {
            title: (items) => items[0].label,
            label: (ctx)   => '  ' + formatVND(ctx.parsed.y)
        }
    };

    const scales = {
        y: {
            beginAtZero: true,
            grid: { color: '#f0ebe4', drawTicks: false },
            border: { display: false },
            ticks: { callback: shortVND, padding: 8 }
        },
        x: {
            grid: { display: false },
            border: { color: '#ede8e0' },
            ticks: { padding: 6 }
        }
    };

    // ── [SỬA] Config 3 chế độ chart gộp chung ───────────────
    const CONFIGS = {
        yearly: {
            type: 'line',
            labels: yearlyLabels,
            data:   yearlyValues,
            subtitle: 'Tổng quan theo từng năm',
            buildDataset(ctx2d) {
                const g = ctx2d.createLinearGradient(0, 0, 0, 300);
                g.addColorStop(0, 'rgba(60,47,39,0.18)');
                g.addColorStop(1, 'rgba(60,47,39,0.01)');
                return {
                    label: 'Doanh thu',
                    data: yearlyValues,
                    type: 'line',
                    backgroundColor: g,
                    borderColor: '#3C2F27', borderWidth: 3,
                    fill: true, tension: .38,
                    pointBackgroundColor: '#3C2F27',
                    pointBorderColor: '#D4A76A', pointBorderWidth: 2,
                    pointRadius: yearlyValues.length === 1 ? 8 : 5,
                    pointHoverRadius: 9, pointHitRadius: 14,
                };
            }
        },
        monthly: {
            type: 'bar',
            labels: ['Thg 1','Thg 2','Thg 3','Thg 4','Thg 5','Thg 6',
                'Thg 7','Thg 8','Thg 9','Thg 10','Thg 11','Thg 12'],
            data: monthlyData,
            subtitle: `Doanh thu từng tháng — Năm ${selectedYear}`,
            buildDataset(ctx2d) {
                const g = ctx2d.createLinearGradient(0, 0, 0, 300);
                g.addColorStop(0, 'rgba(212,167,106,0.92)');
                g.addColorStop(1, 'rgba(212,167,106,0.3)');
                return {
                    label: 'Doanh thu',
                    data: monthlyData,
                    backgroundColor: g,
                    hoverBackgroundColor: '#C49255',
                    borderRadius: { topLeft: 7, topRight: 7 },
                    borderSkipped: false, maxBarThickness: 36,
                };
            }
        },
        weekly: {
            type: 'bar',
            labels: ['Tuần 1\n(1–7)', 'Tuần 2\n(8–14)', 'Tuần 3\n(15–21)', 'Tuần 4\n(22–28)', 'Tuần 5\n(29+)'],
            data: weeklyData,
            subtitle: `Doanh thu từng tuần — Tháng ${selectedMonth}/${selectedYear}`,
            buildDataset(ctx2d) {
                const g = ctx2d.createLinearGradient(0, 0, 0, 300);
                g.addColorStop(0, 'rgba(30,138,68,0.82)');
                g.addColorStop(1, 'rgba(30,138,68,0.2)');
                return {
                    label: 'Doanh thu',
                    data: weeklyData,
                    backgroundColor: g,
                    hoverBackgroundColor: '#1a7a3c',
                    borderRadius: { topLeft: 7, topRight: 7 },
                    borderSkipped: false, maxBarThickness: 64,
                };
            }
        }
    };

    // ── Render chart summary (tổng / max) ───────────────────
    function renderSummary(tab) {
        const el = document.getElementById('chartSummary');
        if (!el) return;
        const data = CONFIGS[tab].data;
        const total = data.reduce((a, b) => a + Number(b), 0);
        const max   = Math.max(...data.map(Number));
        el.innerHTML = `
            <div class="chart-summary-item">
                <span class="chart-summary-label">Tổng cộng</span>
                <span class="chart-summary-val">${formatVND(total)}</span>
            </div>
            <div class="chart-summary-item">
                <span class="chart-summary-label">Cao nhất</span>
                <span class="chart-summary-val">${formatVND(max)}</span>
            </div>
        `;
    }

    // ── Khởi tạo + render chart ──────────────────────────────
    const canvasEl = document.getElementById('revenueChart');
    if (!canvasEl) return;

    let chart = null;
    let currentTab = 'yearly';

    function renderChart(tab) {
        const cfg = CONFIGS[tab];

        // update subtitle
        const sub = document.getElementById('chartSubtitle');
        if (sub) sub.textContent = cfg.subtitle;

        // update summary
        renderSummary(tab);

        if (chart) chart.destroy();

        const ctx2d = canvasEl.getContext('2d');
        chart = new Chart(canvasEl, {
            type: cfg.type,
            data: {
                labels: cfg.labels,
                datasets: [cfg.buildDataset(ctx2d)]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: { duration: 500, easing: 'easeInOutQuart' },
                plugins: { legend: { display: false }, tooltip },
                scales
            }
        });
    }

    renderChart(currentTab);

    // ── [THÊM MỚI] Tab switching ─────────────────────────────
    document.querySelectorAll('.chart-tab').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.chart-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            currentTab = this.dataset.tab;
            renderChart(currentTab);
        });
    });

});