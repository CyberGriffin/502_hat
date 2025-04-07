document.addEventListener('DOMContentLoaded', function () {
    var headers = document.querySelectorAll('th.sortable');
    var indicator = document.getElementById('sort-indicator');
    var currentSortedHeader = null;
  
    function moveSortIndicator(header, instant = false) {
      const rect = header.getBoundingClientRect();
      const theadRect = header.closest('thead').getBoundingClientRect();
      const left = rect.left - theadRect.left;
      const width = rect.width;
  
      if (instant) {
        indicator.style.transition = 'none';
      }
      else {
        indicator.style.transition = 'left 0.4s ease, width 0.4s ease';
      }
      indicator.style.left = left + 'px';
      indicator.style.width = width + 'px';

      if (instant) {
        // Force reflow to apply the transition
        void indicator.offsetWidth;
        indicator.style.transition = 'left 0.4s ease, width 0.4s ease';
      }
    }

    function refreshSortIndicator(instant = false) {
        if (currentSortedHeader) {
          moveSortIndicator(currentSortedHeader, instant);
        }
    }
    window.refreshSortIndicator = refreshSortIndicator;
  
    function sortTableByHeader(header) {
      var table = header.closest('table');
      var tbody = table.querySelector('tbody');
      var rows = Array.from(tbody.querySelectorAll('tr:not(.no-sort)'));
      var index = Array.from(header.parentNode.children).indexOf(header);
      var ascending = header.classList.contains('ascending');
  
      rows.sort(function (rowA, rowB) {
        var cellA = rowA.children[index].textContent.trim();
        var cellB = rowB.children[index].textContent.trim();
  
        if (!isNaN(cellA) && !isNaN(cellB)) {
          cellA = parseFloat(cellA);
          cellB = parseFloat(cellB);
        }
  
        if (cellA < cellB) return ascending ? 1 : -1;
        if (cellA > cellB) return ascending ? -1 : 1;
        return 0;
      });
  
      rows.forEach(row => tbody.appendChild(row));
  
      // Reset headers
      headers.forEach(h => {
        h.classList.remove('ascending', 'descending', 'sorted');
        h.querySelector('.sort-arrow').textContent = '';
      });
  
      header.classList.toggle('ascending', !ascending);
      header.classList.toggle('descending', ascending);
      header.classList.add('sorted');
  
      var arrow = header.querySelector('.sort-arrow');
      arrow.textContent = ascending ? '▼' : '▲';
  
      moveSortIndicator(header);
      currentSortedHeader = header;
    }
  
    headers.forEach(header => {
      header.addEventListener('click', function () {
        sortTableByHeader(header);
      });
    });
  
    // Default sort
    var defaultHeader = document.getElementById('sort-name');
    if (defaultHeader) {
      sortTableByHeader(defaultHeader);
    }
  
    // Watch for window resize to refresh the sort indicator
    window.addEventListener('resize', () => refreshSortIndicator(true));
  });
