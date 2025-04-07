// ==== CONSTANTS ====
const CONDITION_OPTIONS = ["New", "Good", "Fair", "Poor", "Broken", "Unknown"];
const SEARCH_DEBOUNCE_TIME = 250;
const ANIMATION_DURATION = 600;

// ==== GLOBAL VARIABLES ====
let departments = null;
let departmentsLoadingPromise = null;
let selectedInventoryId = null;
let isEditing = false;
let editToggle;
let saveChangesBtn;
let cancelChangesBtn;
let transferOwnershipModal;
let newOwnerSearch;
let currentOwnerDisplay;
let confirmTransferBtn;
let searchResultsTable;
let toggleTableViewBtn;
let addRecordBtn;

// ==== DOCUMENT READY ====
document.addEventListener('DOMContentLoaded', () => {
  // ---- MOVE ALL THESE INSIDE ----
  editToggle = document.getElementById('toggle-edit-mode');
  saveChangesBtn = document.getElementById('save-changes-btn');
  cancelChangesBtn = document.getElementById('cancel-changes-btn');
  transferOwnershipModal = document.getElementById('transferOwnershipModal');
  newOwnerSearch = document.getElementById('new-owner-search');
  currentOwnerDisplay = document.getElementById('current-owner-display');
  confirmTransferBtn = document.getElementById('confirm-transfer-btn');
  searchResultsTable = document.getElementById('search-results-table');
  normalButtons = document.getElementById('normal-mode-buttons');
  editButtons = document.getElementById('edit-mode-buttons');
  toggleTableViewBtn = document.getElementById('toggle-table-view');
  addRecordBtn = document.getElementById('add-record-btn');


  // ==== SETUP EVENT LISTENERS ====
  editToggle.addEventListener('change', () => toggleEditMode(editToggle.checked));
  saveChangesBtn.addEventListener('click', handleSaveChanges);
  cancelChangesBtn.addEventListener('click', handleCancelChanges);
  confirmTransferBtn.addEventListener('click', handleOwnershipTransfer);

  // ==== Start loading departments early ====
  departmentsLoadingPromise = fetch('/departments.json')
    .then(response => response.json())
    .then(data => {
      departments = data.map(dept => dept.name);
    })
    .catch(error => {
      console.error('Failed to fetch departments:', error);
      alert('Failed to load departments. Please try again later.');
    });
});

// ==== HELPER FUNCTIONS ====
/**
 * Retrieves departments, either from cache or via promise.
 * @returns {Promise<string[]>} - Array of department names.
 */
function getDepartments() {
  return departments ? Promise.resolve(departments) : departmentsLoadingPromise;
}

/**
 * Updates status badges based on edit mode or availability.
 * @param {boolean} editMode - Whether edit mode is active.
 */
function updateStatusBadges(editMode) {
    document.querySelectorAll('.inventory-row').forEach((row, index) => {
      const statusCell = row.querySelector('.status-cell');
      const userCell = row.querySelector('td.current-user-cell');
      
      let isAvailable = false;
  
      if (editMode) {
        const input = userCell?.querySelector('input') || userCell?.querySelector('select');
        const value = input ? input.value.trim() : (userCell?.dataset.short || '').trim();
        isAvailable = value === '' || value === '—';
      } else {
        const value = (userCell?.dataset.short || '').trim();
        isAvailable = value === '' || value === '—';
      }
  
      if (editMode) {
        statusCell.innerHTML = `<span class="badge bg-primary">${index}</span>`;
      } else {
        statusCell.innerHTML = isAvailable
          ? `<span class="badge bg-success">Available</span>`
          : `<span class="badge bg-danger">Checked Out</span>`;
      }
    });
}
  
  

/**
 * Toggles editable cells between view and edit modes.
 * @param {boolean} editMode - Whether to enable edit mode.
 */
function toggleEditableCells(editMode) {
  document.querySelectorAll('.editable-cell').forEach(cell => {
    const field = cell.getAttribute('data-field');
    if (editMode) {
      if (field === 'dept_name') {
        renderDepartmentLoading(cell);
        getDepartments().then(depts => renderDepartmentSelect(cell, depts));
      } else if (field === 'condition_of_item') {
        renderConditionSelect(cell);
      } else {
        renderInputField(cell);
      }
    } else {
      const valueElement = cell.querySelector('input') || cell.querySelector('select');
      const newValue = valueElement ? valueElement.value : cell.innerText.trim();
      cell.innerHTML = `<span>${newValue}</span>`;
      cell.setAttribute('data-value', newValue);
    }
  });
}

/**
 * Renders a loading spinner for department fields.
 * @param {HTMLElement} cell - The cell to update.
 */
function renderDepartmentLoading(cell) {
  cell.innerHTML = `
    <div class="d-flex align-items-center gap-2">
      <div class="spinner-border spinner-border-sm text-light" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <span>Loading...</span>
    </div>
  `;
}

/**
 * Renders a department select dropdown.
 * @param {HTMLElement} cell - The cell to update.
 * @param {string[]} departments - List of department names.
 */
function renderDepartmentSelect(cell, departments) {
  const currentValue = cell.getAttribute('data-value') || '';
  let selectHTML = `<select class="form-select form-select-sm">`;
  selectHTML += `<option value="">Select Department</option>`;
  departments.forEach(dept => {
    selectHTML += `<option value="${dept}" ${dept === currentValue ? 'selected' : ''}>${dept}</option>`;
  });
  selectHTML += `</select>`;
  cell.innerHTML = selectHTML;
  attachEditListeners(cell);
}

/**
 * Renders a condition select dropdown.
 * @param {HTMLElement} cell - The cell to update.
 */
function renderConditionSelect(cell) {
  const currentValue = cell.getAttribute('data-value') || '';
  let selectHTML = `<select class="form-select form-select-sm">`;
  CONDITION_OPTIONS.forEach(option => {
    selectHTML += `<option value="${option}" ${option === currentValue ? 'selected' : ''}>${option}</option>`;
  });
  selectHTML += `</select>`;
  cell.innerHTML = selectHTML;
  attachEditListeners(cell);
}

/**
 * Renders a text input field.
 * @param {HTMLElement} cell - The cell to update.
 */
function renderInputField(cell) {
  const currentValue = cell.getAttribute('data-value') || cell.innerText.trim();
  cell.innerHTML = `<input type="text" class="form-control form-control-sm" value="${currentValue}">`;
  attachEditListeners(cell);
}

/**
 * Toggles owner cells between view and edit modes.
 * @param {boolean} editMode - Whether to enable edit mode.
 */
function toggleOwnerCells(editMode) {
  document.querySelectorAll('.editable-owner-cell').forEach(cell => {
    if (editMode) {
      const ownerSpan = cell.querySelector('.owner-name');
      if (ownerSpan) {
        ownerSpan.outerHTML = `<span class="owner-transfer-link" title="Click to transfer ownership">${ownerSpan.innerText}</span>`;
      }
    } else {
      const transferLink = cell.querySelector('.owner-transfer-link');
      if (transferLink) {
        transferLink.outerHTML = `<span class="owner-name">${transferLink.innerText}</span>`;
      }
    }
  });
}

/**
 * Attaches input listeners to mark cells as edited.
 * @param {HTMLElement} cell - The cell containing the input/select.
 */
function attachEditListeners(cell) {
  const input = cell.querySelector('input') || cell.querySelector('select');
  if (input) {
    input.addEventListener('input', () => markCellEdited(cell));
  }
}

/**
 * Marks a cell and its row as edited.
 * @param {HTMLElement} cell - The cell to mark.
 */
function markCellEdited(cell) {
  cell.classList.add('edited-cell');
  cell.closest('tr').classList.add('edited-row');
}

/**
 * Attaches click listeners for ownership transfer.
 */
function attachOwnerTransferListeners() {
  document.querySelectorAll('.owner-transfer-link').forEach(link => {
    link.addEventListener('click', event => {
      event.stopPropagation();
      const td = link.closest('td');
      selectedInventoryId = td.getAttribute('data-inventory-id');
      const ownerName = td.getAttribute('data-owner-name');
      const ownerEmail = td.getAttribute('data-owner-email');

      currentOwnerDisplay.textContent = `${ownerName} (${ownerEmail})`;
      newOwnerSearch.value = '';
      newOwnerSearch.dataset.selectedUserEmail = '';
      confirmTransferBtn.disabled = true;

      const modal = new bootstrap.Modal(transferOwnershipModal);
      modal.show();
      attachUserSearchListeners(newOwnerSearch);
    });
  });
}

/**
 * Attaches search functionality to an input element for user lookup.
 * @param {HTMLElement} inputElement - The input element to attach listeners to.
 */
function attachUserSearchListeners(inputElement) {
  const tbody = searchResultsTable.querySelector('tbody');
  let timeout = null;

  inputElement.addEventListener('input', () => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      const query = inputElement.value.trim();
      if (!query) {
        searchResultsTable.style.display = 'none';
        tbody.innerHTML = '';
        return;
      }

      fetch(`/users/search?q=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(users => renderUserSearchResults(users, tbody, inputElement))
        .catch(error => {
          console.error('Failed to search users:', error);
          searchResultsTable.style.display = 'none';
        });
    }, SEARCH_DEBOUNCE_TIME);
  });
}

/**
 * Renders user search results in the table.
 * @param {Object[]} users - Array of user objects with name and email.
 * @param {HTMLElement} tbody - Table body to populate.
 * @param {HTMLElement} inputElement - Input element to update on selection.
 */
function renderUserSearchResults(users, tbody, inputElement) {
  tbody.innerHTML = '';
  if (!users.length) {
    searchResultsTable.style.display = 'none';
    return;
  }

  users.forEach(user => {
    const tr = document.createElement('tr');
    tr.innerHTML = `<td>${user.name}</td><td>${user.email}</td>`;
    tr.style.cursor = 'pointer';
    tr.addEventListener('click', () => {
      tbody.querySelectorAll('tr').forEach(row => row.classList.remove('search-selected'));
      tr.classList.add('search-selected');
      inputElement.value = user.name;
      inputElement.dataset.selectedUserEmail = user.email;
      confirmTransferBtn.disabled = false;
    });
    tbody.appendChild(tr);
  });
  searchResultsTable.style.display = 'table';
}

/**
 * Animates rows after saving changes.
 */
function animateSavedRows() {
  const editedRows = document.querySelectorAll('.edited-row');
  editedRows.forEach(row => {
    row.querySelectorAll('td').forEach(td => {
      td.style.transition = 'background-color 0.4s ease';
      td.style.backgroundColor = '#a5d6a7';
    });
  });

  setTimeout(() => {
    editedRows.forEach(row => {
      row.querySelectorAll('td').forEach(td => {
        td.style.transition = 'background-color 0.6s ease';
        td.style.backgroundColor = '';
      });
      row.classList.remove('edited-row');
    });
    document.querySelectorAll('.edited-cell').forEach(cell => cell.classList.remove('edited-cell'));
    saveChangesBtn.disabled = true;
  }, ANIMATION_DURATION);
}

// ==== CORE FUNCTIONS ====
/**
 * Toggles between view and edit modes for the inventory table.
 * @param {boolean} editMode - Whether to enable edit mode.
 */
function toggleEditMode(editMode) {
    if (!editMode) {
        if (document.querySelector('.edited-cell')) {
            if (!confirm('You have unsaved changes. Are you sure you want to cancel?')) {
                editToggle.checked = true;
                return;
            }
            location.reload();
        }
        resetEditedStyles();
        editToggle.checked = false;
    }

    if (editMode) {
        toggleTableViewBtn.style.display = 'none';
        addRecordBtn.style.display = 'none';
        cancelChangesBtn.style.display = 'block';
        saveChangesBtn.style.display = 'block';
    } else {
        cancelChangesBtn.style.display = 'none';
        saveChangesBtn.style.display = 'none';
        toggleTableViewBtn.style.display = 'block';
        addRecordBtn.style.display = 'block';
    }

  isEditing = editMode;
  truncateTable();
  unselectAllRows();
  updateStatusBadges(editMode);
  toggleEditableCells(editMode);
  toggleOwnerCells(editMode);

  // Toggle action buttons visibility
  document.querySelectorAll('.action-cell').forEach(cell => {
    const buttons = cell.querySelector('.action-buttons');
    const placeholder = cell.querySelector('.action-placeholder');
    if (editMode) {
      if (buttons) buttons.style.display = 'none';
      if (placeholder) placeholder.style.display = 'block';
    } else {
      if (buttons) buttons.style.display = '';
      if (placeholder) placeholder.style.display = 'none';
    }
  });

  if (editMode) {
    attachOwnerTransferListeners();
    requestAnimationFrame(() => refreshSortIndicator(true));
  } else {
    requestAnimationFrame(() => refreshSortIndicator(true));
  }
}

/**
 * Handles the save changes button click, showing a confirmation modal.
 */
function handleSaveChanges() {
    actuallySaveChanges();
}

/**
 * Handles the cancel changes button click, resetting edited styles and toggling edit mode off.
 */
function handleCancelChanges() {
    toggleEditMode(false);
}

/**
 * Resets edited styles after canceling changes.
 */
function resetEditedStyles() {
  document.querySelectorAll('.edited-row').forEach(row => row.classList.remove('edited-row'));
  document.querySelectorAll('.edited-cell').forEach(cell => cell.classList.remove('edited-cell'));
}

/**
 * Handles ownership transfer confirmation.
 */
function handleOwnershipTransfer() {
  const newOwnerName = newOwnerSearch.value.trim();
  const selectedRow = searchResultsTable.querySelector('.search-selected');
  if (!selectedRow) return;

  const newOwnerEmail = newOwnerSearch.dataset.selectedUserEmail;
  const ownerCell = document.querySelector(`.editable-owner-cell[data-inventory-id="${selectedInventoryId}"]`);
  if (!ownerCell) return;

  const ownerTextElement = ownerCell.querySelector('.owner-name') || ownerCell.querySelector('.owner-transfer-link');
  if (ownerTextElement) ownerTextElement.innerText = newOwnerName;

  ownerCell.setAttribute('data-value', ownerCell.getAttribute('data-owner-name') || '');
  ownerCell.setAttribute('data-owner-name', newOwnerName);
  ownerCell.setAttribute('data-owner-email', newOwnerEmail);

  markCellEdited(ownerCell);
  bootstrap.Modal.getInstance(transferOwnershipModal).hide();

  newOwnerSearch.value = '';
  newOwnerSearch.dataset.selectedUserEmail = '';
  searchResultsTable.style.display = 'none';
  searchResultsTable.querySelector('tbody').innerHTML = '';
  saveChangesBtn.disabled = false;
}

/**
 * Performs the actual save operation.
 */
function actuallySaveChanges() {
    const editedRows = document.querySelectorAll('.edited-row');
    const updates = [];
  
    editedRows.forEach(row => {
      const invId = row.getAttribute('data-inventory-id');
      const location = row.querySelector('[data-field="location"]')?.querySelector('input')?.value || '';
      const conditionOfItem = row.querySelector('[data-field="condition_of_item"]')?.querySelector('select')?.value || '';
      const ownerEmail = row.querySelector('.editable-owner-cell')?.getAttribute('data-owner-email') || '';
      const deptName = row.querySelector('[data-field="dept_name"]')?.querySelector('select')?.value || '';
  
      updates.push({
        inv_id: invId,
        location: location,
        condition_of_item: conditionOfItem,
        owner_email: ownerEmail,
        dept_name: deptName,
      });
    });
  
    if (updates.length === 0) {
      alert("No changes to save.");
      return;
    }
  
    fetch('/inventories/bulk_update', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ updates: updates })
    })
    .then(response => {
      if (!response.ok) throw new Error('Save failed');
      return response.json();
    })
    .then(data => {
      if (data.status === 'success') {
        animateSavedRows();
        resetEditedStyles();
        toggleEditMode(false);
      } else {
        alert('Failed to save changes!');
      }
    })
    .catch(error => {
      console.error(error);
      alert('Failed to save changes!');
    });
  }
  