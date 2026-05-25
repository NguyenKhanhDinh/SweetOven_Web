const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
    const monthlyData = [
        <c:forEach items="${dashboard.monthlyRevenue}" var="m" varStatus="loop">
            ${m.revenue}${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    new Chart(monthlyCtx, {
        type: 'bar',
        data: {
            labels: ['Thg 1', 'Thg 2', 'Thg 3', 'Thg 4', 'Thg 5', 'Thg 6', 'Thg 7', 'Thg 8', 'Thg 9', 'Thg 10', 'Thg 11', 'Thg 12'],
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: monthlyData,
                backgroundColor: 'rgba(212, 167, 106, 0.7)',
                borderColor: '#D4A76A',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: { ticks: { callback: function(value) { return value.toLocaleString('vi-VN') + '₫'; } } }
            }
        }
    });