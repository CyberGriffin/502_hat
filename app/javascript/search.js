// This script handles the search functionality for tables

document.addEventListener('DOMContentLoaded', function () {
    var searchInput = document.getElementById('search-input');
    if (!searchInput) return;
  
    searchInput.addEventListener('input', function () {
        var query = searchInput.value.toLowerCase();
        var rows = document.querySelectorAll('#inventory-list tbody tr:not(.no-search)');
    
        rows.forEach(function (row) {
            if (row.classList.contains('admin-add-row')) {
                return;
            }
    
            var cells = row.querySelectorAll('td');
            var match = false;
    
            cells.forEach(function (cell) {
                if (!cell.classList.contains('no-search')) {
                    if (cell.textContent.toLowerCase().includes(query)) {
                        match = true;
                    }
                }
            });
    
            row.style.display = match ? '' : 'none';
        });
    
        var visibleRows = Array.from(rows).filter(row => row.style.display !== 'none');
        var noSearchRow = document.querySelector('.no-search');
        noSearchRow.style.display = visibleRows.length === 0 ? '' : 'none';
        refreshSortIndicator(true);
    });
});