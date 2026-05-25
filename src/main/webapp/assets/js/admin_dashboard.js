document.addEventListener('DOMContentLoaded', function () {

    const monthlyCtx = document.getElementById('monthlyChart');

    if (monthlyCtx) {
        new Chart(monthlyCtx, {
            type: 'bar',
            data: {
                labels: [
                    'Thg 1', 'Thg 2', 'Thg 3', 'Thg 4','Thg 5', 'Thg 6', 'Thg 7', 'Thg 8','Thg 9', 'Thg 10', 'Thg 11', 'Thg 12'],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: monthlyData,
                    backgroundColor: 'rgba(212,167,106,0.7)',
                    borderColor: '#D4A76A',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true
            }
        });
    }

    const yearlyCtx = document.getElementById('yearlyRevenueChart');

    if (yearlyCtx) {
        new Chart(yearlyCtx, {
            type: 'line',
            data: {
                labels: yearlyLabels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: yearlyValues,
                    backgroundColor: 'rgba(212,167,106,0.2)',
                    borderColor: '#D4A76A',
                    borderWidth: 3,
                    fill: true,
                    pointBackgroundColor: '#3C2F27',
                    pointRadius: 5
                }]
            },
            options: {
                responsive: true
            }
        });
    }

});