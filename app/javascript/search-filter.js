document.addEventListener('DOMContentLoaded', function () {
  function updateTableVisibility() {
    const query = (document.getElementById('search-input')?.value || '').toLowerCase();
    const activeAvailability = Array.from(document.querySelectorAll('.filter-bubble[data-filter-group="availability"].active')).map(btn => btn.dataset.value);
    const activeDepartments = Array.from(document.querySelectorAll('.filter-bubble[data-filter-group="department"].active')).map(btn => btn.dataset.value.toLowerCase());
    const activeConditions = Array.from(document.querySelectorAll('.filter-bubble[data-filter-group="condition"].active')).map(btn => btn.dataset.value.toLowerCase());

    document.querySelectorAll('.inventory-row').forEach(row => {
      if (row.classList.contains('no-filter')) {
        row.style.display = '';
        return;
      }

      let matches = true;

      // Search text match
      if (query) {
        let rowText = '';
        row.querySelectorAll('td').forEach(cell => {
          if (!cell.classList.contains('no-search')) {
            const input = cell.querySelector('input') || cell.querySelector('select');
            const cellText = input ? input.value : cell.textContent;
            rowText += ' ' + (cellText || '');
          }
        });
        if (!rowText.toLowerCase().includes(query)) {
          matches = false;
        }
      }

      // Availability match
      const badge = row.querySelector('.status-cell .badge');
      const isAvailable = badge?.classList.contains('bg-success');
      const isCheckedOut = badge?.classList.contains('bg-danger');
      if (matches && activeAvailability.length > 0) {
        if (!((isAvailable && activeAvailability.includes('available')) || (isCheckedOut && activeAvailability.includes('checked_out')))) {
          matches = false;
        }
      }

      // Department match
      const dept = row.querySelector('[data-field="dept_name"]')?.dataset.value?.toLowerCase() || '';
      if (matches && activeDepartments.length > 0 && !activeDepartments.some(d => dept.includes(d))) {
        matches = false;
      }

      // Condition match
      const cond = row.querySelector('[data-field="condition_of_item"]')?.dataset.value?.toLowerCase() || '';
      if (matches && activeConditions.length > 0 && !activeConditions.some(c => cond.includes(c))) {
        matches = false;
      }

      row.style.display = matches ? '' : 'none';
    });

    const rows = document.querySelectorAll('.inventory-row:not([style*="display: none"])');
    const noSearchRow = document.querySelector('.no-search');
    if (noSearchRow) noSearchRow.style.display = rows.length === 0 ? '' : 'none';

    refreshSortIndicator(true);
  }

  // Search input
  const searchInput = document.getElementById('search-input');
  if (searchInput) {
    searchInput.addEventListener('input', updateTableVisibility);
  }

  // Filter bubbles
  document.querySelectorAll('.filter-bubble').forEach(bubble => {
    bubble.addEventListener('click', function () {
      bubble.classList.toggle('active');
      updateTableVisibility();
    });
  });

  // Clear filters
  document.getElementById('clear-filters-btn').addEventListener('click', function () {
    document.querySelectorAll('.filter-bubble').forEach(bubble => bubble.classList.remove('active'));
    if (searchInput) searchInput.value = '';
    updateTableVisibility();
  });
});
