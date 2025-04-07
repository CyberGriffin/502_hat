// // ==== CONSTANTS ====
// const CONDITION_OPTIONS = ["New", "Good", "Fair", "Poor", "Broken", "Unknown"];
// const SEARCH_DEBOUNCE_TIME = 250;
// const ANIMATION_DURATION = 600;

// // ==== GLOBAL VARIABLES ====
// let departments = null;
// let departmentsLoadingPromise = null;
// let selectedInventoryId = null;
// let isEditing = false;
// let editToggle;
// let saveChangesContainer;
// let saveChangesBtn;
// let cancelChangesBtn;
// let transferOwnershipModal;
// let newOwnerSearch;
// let currentOwnerDisplay;
// let confirmTransferBtn;
// let searchResultsTable;


// // ==== DOCUMENT READY ====
// document.addEventListener('DOMContentLoaded', () => {
//   // ---- MOVE ALL THESE INSIDE ----
//   editToggle = document.getElementById('toggle-edit-mode');
//   saveChangesContainer = document.getElementById('save-changes-container');
//   saveChangesBtn = document.getElementById('save-changes-btn');
//   cancelChangesBtn = document.getElementById('cancel-changes-btn');
//   transferOwnershipModal = document.getElementById('transferOwnershipModal');
//   newOwnerSearch = document.getElementById('new-owner-search');
//   currentOwnerDisplay = document.getElementById('current-owner-display');
//   confirmTransferBtn = document.getElementById('confirm-transfer-btn');
//   searchResultsTable = document.getElementById('search-results-table');

//   // ==== SETUP EVENT LISTENERS ====
//   editToggle.addEventListener('change', () => toggleEditMode(editToggle.checked));
//   saveChangesBtn.addEventListener('click', handleSaveChanges);
//   cancelChangesBtn.addEventListener('click', handleCancelChanges);
//   confirmTransferBtn.addEventListener('click', handleOwnershipTransfer);

//   // ==== Start loading departments early ====
//   departmentsLoadingPromise = fetch('/departments.json')
//     .then(response => response.json())
//     .then(data => {
//       departments = data.map(dept => dept.name);
//     })
//     .catch(error => {
//       console.error('Failed to fetch departments:', error);
//       alert('Failed to load departments. Please try again later.');
//     });
// });

// // ==== HELPER FUNCTIONS ====
// /**
//  * Retrieves departments, either from cache or via promise.
//  * @returns {Promise<string[]>} - Array of department names.
//  */
// function getDepartments() {
//   return departments ? Promise.resolve(departments) : departmentsLoadingPromise;
// }

// /**
//  * Updates status badges based on edit mode or availability.
//  * @param {boolean} editMode - Whether edit mode is active.
//  */
// function updateStatusBadges(editMode) {
//   document.querySelectorAll('.inventory-row').forEach((row, index) => {
//     const statusCell = row.querySelector('.status-cell');
//     if (editMode) {
//       statusCell.innerHTML = `<span class="badge bg-primary">${index}</span>`;
//     } else {
//       const userCell = row.querySelector('td.current-user-cell');
//       const isAvailable = !userCell || userCell.dataset.short.trim() === '';
//       statusCell.innerHTML = isAvailable
//         ? `<span class="badge bg-success">Available</span>`
//         : `<span class="badge bg-danger">Checked Out</span>`;
//     }
//   });
// }

// /**
//  * Toggles editable cells between view and edit modes.
//  * @param {boolean} editMode - Whether to enable edit mode.
//  */
// function toggleEditableCells(editMode) {
//   document.querySelectorAll('.editable-cell').forEach(cell => {
//     const field = cell.getAttribute('data-field');
//     if (editMode) {
//       if (field === 'dept_name') {
//         renderDepartmentLoading(cell);
//         getDepartments().then(depts => renderDepartmentSelect(cell, depts));
//       } else if (field === 'condition_of_item') {
//         renderConditionSelect(cell);
//       } else {
//         renderInputField(cell);
//       }
//     } else {
//       const valueElement = cell.querySelector('input') || cell.querySelector('select');
//       const newValue = valueElement ? valueElement.value : cell.innerText.trim();
//       cell.innerHTML = `<span>${newValue}</span>`;
//       cell.setAttribute('data-value', newValue);
//     }
//   });
// }

// /**
//  * Renders a loading spinner for department fields.
//  * @param {HTMLElement} cell - The cell to update.
//  */
// function renderDepartmentLoading(cell) {
//   cell.innerHTML = `
//     <div class="d-flex align-items-center gap-2">
//       <div class="spinner-border spinner-border-sm text-light" role="status">
//         <span class="visually-hidden">Loading...</span>
//       </div>
//       <span>Loading...</span>
//     </div>
//   `;
// }

// /**
//  * Renders a department select dropdown.
//  * @param {HTMLElement} cell - The cell to update.
//  * @param {string[]} departments - List of department names.
//  */
// function renderDepartmentSelect(cell, departments) {
//   const currentValue = cell.getAttribute('data-value') || '';
//   let selectHTML = `<select class="form-select form-select-sm">`;
//   selectHTML += `<option value="">Select Department</option>`;
//   departments.forEach(dept => {
//     selectHTML += `<option value="${dept}" ${dept === currentValue ? 'selected' : ''}>${dept}</option>`;
//   });
//   selectHTML += `</select>`;
//   cell.innerHTML = selectHTML;
//   attachEditListeners(cell);
// }

// /**
//  * Renders a condition select dropdown.
//  * @param {HTMLElement} cell - The cell to update.
//  */
// function renderConditionSelect(cell) {
//   const currentValue = cell.getAttribute('data-value') || '';
//   let selectHTML = `<select class="form-select form-select-sm">`;
//   CONDITION_OPTIONS.forEach(option => {
//     selectHTML += `<option value="${option}" ${option === currentValue ? 'selected' : ''}>${option}</option>`;
//   });
//   selectHTML += `</select>`;
//   cell.innerHTML = selectHTML;
//   attachEditListeners(cell);
// }

// /**
//  * Renders a text input field.
//  * @param {HTMLElement} cell - The cell to update.
//  */
// function renderInputField(cell) {
//   const currentValue = cell.getAttribute('data-value') || cell.innerText.trim();
//   cell.innerHTML = `<input type="text" class="form-control form-control-sm" value="${currentValue}">`;
//   attachEditListeners(cell);
// }

// /**
//  * Toggles owner cells between view and edit modes.
//  * @param {boolean} editMode - Whether to enable edit mode.
//  */
// function toggleOwnerCells(editMode) {
//   document.querySelectorAll('.editable-owner-cell').forEach(cell => {
//     if (editMode) {
//       const ownerSpan = cell.querySelector('.owner-name');
//       if (ownerSpan) {
//         ownerSpan.outerHTML = `<span class="owner-transfer-link" title="Click to transfer ownership">${ownerSpan.innerText}</span>`;
//       }
//     } else {
//       const transferLink = cell.querySelector('.owner-transfer-link');
//       if (transferLink) {
//         transferLink.outerHTML = `<span class="owner-name">${transferLink.innerText}</span>`;
//       }
//     }
//   });
// }

// /**
//  * Attaches input listeners to mark cells as edited.
//  * @param {HTMLElement} cell - The cell containing the input/select.
//  */
// function attachEditListeners(cell) {
//   const input = cell.querySelector('input') || cell.querySelector('select');
//   if (input) {
//     input.addEventListener('input', () => markCellEdited(cell));
//   }
// }

// /**
//  * Marks a cell and its row as edited.
//  * @param {HTMLElement} cell - The cell to mark.
//  */
// function markCellEdited(cell) {
//   cell.classList.add('edited-cell');
//   cell.closest('tr').classList.add('edited-row');
// }

// /**
//  * Attaches click listeners for ownership transfer.
//  */
// function attachOwnerTransferListeners() {
//   document.querySelectorAll('.owner-transfer-link').forEach(link => {
//     link.addEventListener('click', event => {
//       event.stopPropagation();
//       const td = link.closest('td');
//       selectedInventoryId = td.getAttribute('data-inventory-id');
//       const ownerName = td.getAttribute('data-owner-name');
//       const ownerEmail = td.getAttribute('data-owner-email');

//       currentOwnerDisplay.textContent = `${ownerName} (${ownerEmail})`;
//       newOwnerSearch.value = '';
//       newOwnerSearch.dataset.selectedUserEmail = '';
//       confirmTransferBtn.disabled = true;

//       const modal = new bootstrap.Modal(transferOwnershipModal);
//       modal.show();
//       attachUserSearchListeners(newOwnerSearch);
//     });
//   });
// }

// /**
//  * Attaches search functionality to an input element for user lookup.
//  * @param {HTMLElement} inputElement - The input element to attach listeners to.
//  */
// function attachUserSearchListeners(inputElement) {
//   const tbody = searchResultsTable.querySelector('tbody');
//   let timeout = null;

//   inputElement.addEventListener('input', () => {
//     clearTimeout(timeout);
//     timeout = setTimeout(() => {
//       const query = inputElement.value.trim();
//       if (!query) {
//         searchResultsTable.style.display = 'none';
//         tbody.innerHTML = '';
//         return;
//       }

//       fetch(`/users/search?q=${encodeURIComponent(query)}`)
//         .then(response => response.json())
//         .then(users => renderUserSearchResults(users, tbody, inputElement))
//         .catch(error => {
//           console.error('Failed to search users:', error);
//           searchResultsTable.style.display = 'none';
//         });
//     }, SEARCH_DEBOUNCE_TIME);
//   });
// }

// /**
//  * Renders user search results in the table.
//  * @param {Object[]} users - Array of user objects with name and email.
//  * @param {HTMLElement} tbody - Table body to populate.
//  * @param {HTMLElement} inputElement - Input element to update on selection.
//  */
// function renderUserSearchResults(users, tbody, inputElement) {
//   tbody.innerHTML = '';
//   if (!users.length) {
//     searchResultsTable.style.display = 'none';
//     return;
//   }

//   users.forEach(user => {
//     const tr = document.createElement('tr');
//     tr.innerHTML = `<td>${user.name}</td><td>${user.email}</td>`;
//     tr.style.cursor = 'pointer';
//     tr.addEventListener('click', () => {
//       tbody.querySelectorAll('tr').forEach(row => row.classList.remove('search-selected'));
//       tr.classList.add('search-selected');
//       inputElement.value = user.name;
//       inputElement.dataset.selectedUserEmail = user.email;
//       confirmTransferBtn.disabled = false;
//     });
//     tbody.appendChild(tr);
//   });
//   searchResultsTable.style.display = 'table';
// }

// /**
//  * Animates rows after saving changes.
//  */
// function animateSavedRows() {
//   const editedRows = document.querySelectorAll('.edited-row');
//   editedRows.forEach(row => {
//     row.querySelectorAll('td').forEach(td => {
//       td.style.transition = 'background-color 0.4s ease';
//       td.style.backgroundColor = '#a5d6a7';
//     });
//   });

//   setTimeout(() => {
//     editedRows.forEach(row => {
//       row.querySelectorAll('td').forEach(td => {
//         td.style.transition = 'background-color 0.6s ease';
//         td.style.backgroundColor = '';
//       });
//       row.classList.remove('edited-row');
//     });
//     document.querySelectorAll('.edited-cell').forEach(cell => cell.classList.remove('edited-cell'));
//     saveChangesBtn.disabled = true;
//   }, ANIMATION_DURATION);
// }

// // ==== CORE FUNCTIONS ====
// /**
//  * Toggles between view and edit modes for the inventory table.
//  * @param {boolean} editMode - Whether to enable edit mode.
//  */
// function toggleEditMode(editMode) {
//     if (!editMode) {
//         if (document.querySelector('.edited-cell')) {
//             if (!confirm('You have unsaved changes. Are you sure you want to cancel?')) {
//                 editToggle.checked = true;
//                 return;
//             }
//             location.reload();
//         }
//         resetEditedStyles();
//         editToggle.checked = false;
//     }

//   isEditing = editMode;
//   updateStatusBadges(editMode);
//   toggleEditableCells(editMode);
//   toggleOwnerCells(editMode);

//   // Toggle action buttons visibility
//   document.querySelectorAll('.action-cell').forEach(cell => {
//     const buttons = cell.querySelector('.action-buttons');
//     const placeholder = cell.querySelector('.action-placeholder');
//     if (editMode) {
//       if (buttons) buttons.style.display = 'none';
//       if (placeholder) placeholder.style.display = 'block';
//     } else {
//       if (buttons) buttons.style.display = '';
//       if (placeholder) placeholder.style.display = 'none';
//     }
//   });

//   saveChangesContainer.style.display = editMode ? 'block' : 'none';
//   saveChangesBtn.disabled = !editMode;

//   if (editMode) {
//     attachOwnerTransferListeners();
//     requestAnimationFrame(() => refreshSortIndicator(true));
//   } else {
//     requestAnimationFrame(() => refreshSortIndicator(true));
//   }
// }

// /**
//  * Handles the save changes button click, showing a confirmation modal.
//  */
// function handleSaveChanges() {
//     actuallySaveChanges();
// }

// /**
//  * Handles the cancel changes button click, resetting edited styles and toggling edit mode off.
//  */
// function handleCancelChanges() {
//     toggleEditMode(false);
// }

// /**
//  * Resets edited styles after canceling changes.
//  */
// function resetEditedStyles() {
//   document.querySelectorAll('.edited-row').forEach(row => row.classList.remove('edited-row'));
//   document.querySelectorAll('.edited-cell').forEach(cell => cell.classList.remove('edited-cell'));
// }

// /**
//  * Handles ownership transfer confirmation.
//  */
// function handleOwnershipTransfer() {
//   const newOwnerName = newOwnerSearch.value.trim();
//   const selectedRow = searchResultsTable.querySelector('.search-selected');
//   if (!selectedRow) return;

//   const newOwnerEmail = newOwnerSearch.dataset.selectedUserEmail;
//   const ownerCell = document.querySelector(`.editable-owner-cell[data-inventory-id="${selectedInventoryId}"]`);
//   if (!ownerCell) return;

//   const ownerTextElement = ownerCell.querySelector('.owner-name') || ownerCell.querySelector('.owner-transfer-link');
//   if (ownerTextElement) ownerTextElement.innerText = newOwnerName;

//   ownerCell.setAttribute('data-value', ownerCell.getAttribute('data-owner-name') || '');
//   ownerCell.setAttribute('data-owner-name', newOwnerName);
//   ownerCell.setAttribute('data-owner-email', newOwnerEmail);

//   markCellEdited(ownerCell);
//   bootstrap.Modal.getInstance(transferOwnershipModal).hide();

//   newOwnerSearch.value = '';
//   newOwnerSearch.dataset.selectedUserEmail = '';
//   searchResultsTable.style.display = 'none';
//   searchResultsTable.querySelector('tbody').innerHTML = '';
//   saveChangesBtn.disabled = false;
// }

// /**
//  * Performs the actual save operation.
//  */
// function actuallySaveChanges() {
//     const editedRows = document.querySelectorAll('.edited-row');
//     const updates = [];
  
//     editedRows.forEach(row => {
//       const invId = row.getAttribute('data-inventory-id');
//       const location = row.querySelector('[data-field="location"]')?.querySelector('input')?.value || '';
//       const conditionOfItem = row.querySelector('[data-field="condition_of_item"]')?.querySelector('select')?.value || '';
//       const ownerEmail = row.querySelector('.editable-owner-cell')?.getAttribute('data-owner-email') || '';
//       const deptName = row.querySelector('[data-field="dept_name"]')?.querySelector('select')?.value || '';
  
//       updates.push({
//         inv_id: invId,
//         location: location,
//         condition_of_item: conditionOfItem,
//         owner_email: ownerEmail,
//         dept_name: deptName,
//       });
//     });
  
//     if (updates.length === 0) {
//       alert("No changes to save.");
//       return;
//     }
  
//     fetch('/inventories/bulk_update', {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json',
//         'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
//       },
//       body: JSON.stringify({ updates: updates })
//     })
//     .then(response => {
//       if (!response.ok) throw new Error('Save failed');
//       return response.json();
//     })
//     .then(data => {
//       if (data.status === 'success') {
//         animateSavedRows();
//         resetEditedStyles();
//         toggleEditMode(false);
//       } else {
//         alert('Failed to save changes!');
//       }
//     })
//     .catch(error => {
//       console.error(error);
//       alert('Failed to save changes!');
//     });
//   }
  



  
  
  
  
  
  
  
  




// document.addEventListener('DOMContentLoaded', function() {
// var searchInput = document.getElementById('search-input');

// if (!searchInput) {
//     return;
// }

// searchInput.addEventListener('input', function(event) {
//     var query = searchInput.value.toLowerCase();
//     var rows = document.querySelectorAll('#inventory-list tbody tr:not(.no-search)');

//     rows.forEach(function(row) {
//     if (row.classList.contains('admin-add-row')) {
//         return;
//     }

//     var cells = row.querySelectorAll('td');
//     var match = false;

//     cells.forEach(function(cell) {
//         if (cell.textContent.toLowerCase().includes(query)) {
//         match = true;
//         }
//     });

//     if (match) {
//         row.style.display = '';
//     } else {
//         row.style.display = 'none';
//     }

//     // If none, display default row
//     var visibleRows = Array.from(rows).filter(row => row.style.display !== 'none');
//     var noSearchRow = document.querySelector('.no-search');
//     if (visibleRows.length === 0) {
//         noSearchRow.style.display = '';
//     } else {
//         noSearchRow.style.display = 'none';
//     }
//     });
// });

// var headers = document.querySelectorAll('th.sortable');
// var indicator = document.createElement('div');
// indicator.style.position = 'absolute';
// indicator.style.height = '5px';
// indicator.style.backgroundColor = '#732F2f';
// indicator.style.transition = 'all 0.3s ease';
// document.body.appendChild(indicator);

// function positionIndicator(header) {
//     var rect = header.getBoundingClientRect();
//     indicator.style.width = rect.width + 'px';
//     indicator.style.top = (rect.top - 5) + 'px';
//     indicator.style.left = rect.left + 'px';
//     indicator.style.border = 'none';
// }

// function sortTableByHeader(header) {
//     var table = header.closest('table');
//     var tbody = table.querySelector('tbody');
//     var rows = Array.from(tbody.querySelectorAll('tr:not(.no-sort)'));
//     var index = Array.from(header.parentNode.children).indexOf(header);
//     var ascending = header.classList.contains('ascending');

//     rows.sort(function(rowA, rowB) {
//     var cellA = rowA.children[index].textContent.trim();
//     var cellB = rowB.children[index].textContent.trim();

//     if (!isNaN(cellA) && !isNaN(cellB)) {
//         cellA = parseFloat(cellA);
//         cellB = parseFloat(cellB);
//     }

//     if (cellA < cellB) {
//         return ascending ? 1 : -1;
//     }
//     if (cellA > cellB) {
//         return ascending ? -1 : 1;
//     }
//     return 0;
//     });
    
//     rows.forEach(function(row, rowIndex) {
//     tbody.appendChild(row);
//     });

//     headers.forEach(function(h) {
//     h.classList.remove('ascending', 'descending', 'sorted');
//     h.style.backgroundColor = '#732F2f';
//     h.style.color = 'white';
//     h.style.border = 'none';
//     h.querySelector('.sort-arrow').textContent = '';
//     });

//     header.classList.toggle('ascending', !ascending);
//     header.classList.toggle('descending', ascending);
//     header.classList.add('sorted');
//     header.style.backgroundColor = '#732F2f';
//     header.style.color = 'white';
//     header.style.border = 'none';

//     var arrow = header.querySelector('.sort-arrow');
//     arrow.textContent = ascending ? '▼' : '▲';
//     header.title = ascending ? 'Descending' : 'Ascending';
//     positionIndicator(header);
// }

// var defaultHeader = document.getElementById('sort-name');
// sortTableByHeader(defaultHeader);

// headers.forEach(function(header) {
//     header.addEventListener('click', function() {
//     sortTableByHeader(header);
//     });
// });
// });



///

  




document.addEventListener('DOMContentLoaded', function() {
    var itemField = document.getElementById('item-field');
    var deptField = document.getElementById('dept-field');
    var tableContainer = document.getElementById('items-table-container');
    var addRecordButton = document.getElementById('add-record-button');
    var form = document.getElementById('inventory-form');
  
    itemField.addEventListener('focus', function() {
      fetch('/items.json?page=$(page)')
        .then(response => response.json())
        .then(items => {
          var tableHTML = '<table class="table table-striped">';
          tableHTML += '<thead><tr><th>SKU</th><th>Name</th><th>Category</th></tr></thead>';
          tableHTML += '<tbody>';
          items.forEach(function(item) {
            tableHTML += '<tr data-item-id="' + item.item_id + '" data-item-name="' + item.name + '">';
            tableHTML += '<td>' + item.sku + '</td>';
            tableHTML += '<td>' + item.name + '</td>';
            tableHTML += '<td>' + item.category.name + '</td>';
            tableHTML += '</tr>';
          });
          tableHTML += '</tbody></table>';
          
          tableContainer.innerHTML = tableHTML;
          tableContainer.style.display = 'block';
          var rows = tableContainer.querySelectorAll('tr[data-item-id]');
          rows.forEach(function(row) {
            row.addEventListener('click', function() {
              var itemId = row.getAttribute('data-item-id');
              var itemName = row.getAttribute('data-item-name');
              itemField.value = itemName;
              document.getElementById('item-id-field').value = itemId;
              tableContainer.style.display = 'none';
            });
          });
        })
        .catch(error => console.error('Error fetching items:', error));
    });
  
    deptField.addEventListener('focus', function() {
      fetch('/departments.json')
        .then(response => response.json())
        .then(departments => {
          var tableHTML = '<table class="table table-striped">';
          tableHTML += '<thead><tr><th>ID</th><th>Name</th></tr></thead>';
          tableHTML += '<tbody>';
          departments.forEach(function(department) {
            tableHTML += '<tr data-dept-id="' + department.id + '" data-dept-name="' + department.name + '">';
            tableHTML += '<td>' + department.id + '</td>';
            tableHTML += '<td>' + department.name + '</td>';
            tableHTML += '</tr>';
          });
          tableHTML += '</tbody></table>';
          
          tableContainer.innerHTML = tableHTML;
          tableContainer.style.display = 'block';
          var rows = tableContainer.querySelectorAll('tr[data-dept-id]');
          rows.forEach(function(row) {
            row.addEventListener('click', function() {
              var deptId = row.getAttribute('data-dept-id');
              var deptName = row.getAttribute('data-dept-name');
              deptField.value = deptName;
              document.getElementById('dept-id-field').value = deptId;
              tableContainer.style.display = 'none';
            });
          });
        })
        .catch(error => console.error('Error fetching departments:', error));
    });
  
    addRecordButton.addEventListener('click', function(event) {
      event.preventDefault();
      var formData = new FormData(form);
      fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          console.log('Record added successfully');
          location.reload();
  
        } else {
          alert('Failed to add record: ' + data.errors.join(', '));
        }
      })
      .catch(error => console.error('Error adding record:', error));
    });
  });






document.addEventListener('DOMContentLoaded', function() {
    var expanded = false;
    var toggleButton = document.getElementById('toggle-table-view');
    
    var cells = Array.from(document.querySelectorAll('td.truncate, th.truncate'));
  
    cells.forEach(function(cell) {
      if (!cell.dataset.short) {
        cell.dataset.short = cell.textContent.trim();
      }
      if (!cell.dataset.full) {
        cell.dataset.full = cell.textContent.trim();
      }
    });
  
    toggleButton.addEventListener('click', function() {
        expanded = !expanded;
      
        cells.forEach(function(cell) {
          if (expanded) {
            cell.classList.remove('truncate');
            cell.classList.add('wrap');
      
            const span = cell.querySelector('span');
            if (span) {
              span.textContent = cell.dataset.full;
            } else {
              cell.textContent = cell.dataset.full;
            }
          } else {
            cell.classList.remove('wrap');
            cell.classList.add('truncate');
      
            const span = cell.querySelector('span');
            if (span) {
              span.textContent = cell.dataset.short;
            } else {
              cell.textContent = cell.dataset.short;
            }
          }
        });
      
        toggleButton.textContent = expanded ? "Collapse Table" : "Expand Table";
        refreshSortIndicator(true);
      });
      
  });






document.addEventListener('DOMContentLoaded', function () {
    var returnBtn = document.getElementById('footer-return-btn');
    var confirmationReturnModal = new bootstrap.Modal(document.getElementById('returnConfirmationModal'));
  
    returnBtn.addEventListener('click', function () {
      var selectedIds = [];
  
      document.querySelectorAll('.inventory-row.isselected').forEach(function (row) {
        selectedIds.push(row.getAttribute('data-inventory-id'));
      });
  
      if (selectedIds.length === 0) {
        return;
      }
  
      confirmationReturnModal.show();
  
      
      document.getElementById('confirm-return-btn').addEventListener('click', function () {
        fetch('/inventories/bulk_return', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ inventory_ids: selectedIds })
        })
        .then(response => response.json())
        .then(data => {
          if (data.status === 'success') {
            location.reload();
          } else {
            alert('Failed to return items: ' + data.errors.join(', '));
          }
        })
        .catch(error => console.error('Error:', error));
      });
    });
  });




document.addEventListener('DOMContentLoaded', function () {
    var footerCheckoutBtn = document.getElementById('footer-checkout-btn');
  
    footerCheckoutBtn.addEventListener('click', function() {
      var selectedIds = Array.from(document.querySelectorAll('.inventory-row.isselected')).map(function(row) {
        return row.getAttribute('data-inventory-id');
      });
      fetch('/inventories/bulk_checkout', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ inventory_ids: selectedIds })
      })
      .then(response => response.json())
      .then(data => {
        if (data.status === 'success') {
          location.reload();
          console.log("Number of items checked out: " + data.num_updated);
        }
      })
      .catch(error => console.error('Error:', error));
    });
  });









document.addEventListener('DOMContentLoaded', function () {
    var multiDeleteBtn = document.getElementById('footer-delete-btn');
    var multiDeleteModal = new bootstrap.Modal(document.getElementById('multiDeleteConfirmationModal'));
    var confirmMultiDeleteBtn = document.getElementById('confirm-multi-delete-btn');
    var selectedItemsList = document.getElementById('selected-items-list');
  
    multiDeleteBtn.addEventListener('click', function () {
      var selectedIds = [];
  
      document.querySelectorAll('.inventory-row.isselected').forEach(function (row) {
        selectedIds.push(row.getAttribute('data-inventory-id'));
      });
  
      if (selectedIds.length === 0) {
        return;
      }
  
      selectedItemsList.innerHTML = "";
      selectedIds.forEach(id => {
        let li = document.createElement('li');
        li.textContent = `ID: ${id}`;
        selectedItemsList.appendChild(li);
      });
  
      multiDeleteModal.show();
  
      confirmMultiDeleteBtn.onclick = function () {
        fetch('/inventories/multi_delete', {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ inventory_ids: selectedIds })
        })
        .then(response => response.json())
        .then(data => {
          if (data.status === 'success') {
            location.reload();
          }
        })
        .catch(error => console.error('Error:', error));
      };
    });
  });








// document.addEventListener('DOMContentLoaded', function() {
//     var editModal = document.getElementById('editInventoryModal');
//     var editForm = document.getElementById('edit-inventory-form');
  
//     if (!editModal || !editForm) {
//       return;
//     }
  
//     editModal.addEventListener('show.bs.modal', function(event) {
//       var button = event.relatedTarget;
//       var inventoryId = button.getAttribute('data-inventory-id');
//       var editUrl = '/inventories/' + inventoryId;
//       console.log("editUrl: " + editUrl);
  
//       fetch(editUrl + '/edit')
//         .then(response => response.json())
//         .then(data => {
//           editForm.action = editUrl;
          
//           document.getElementById('edit-item-name').textContent = data.item_name;
  
//           if(editForm.querySelector('[name="inventory[item_id]"]')) {
//             editForm.querySelector('[name="inventory[item_id]"]').value = data.item_id;
//           }
//           if(editForm.querySelector('[name="inventory[year_of_purchase]"]')) {
//             editForm.querySelector('[name="inventory[year_of_purchase]"]').value = data.year_of_purchase;
//           }
//           if(editForm.querySelector('[name="inventory[location]"]')) {
//             editForm.querySelector('[name="inventory[location]"]').value = data.location;
//           }
//           if(editForm.querySelector('[name="inventory[condition_of_item]"]')) {
//             editForm.querySelector('[name="inventory[condition_of_item]"]').value = data.condition_of_item;
//           }
//           if(editForm.querySelector('[name="inventory[owner_email]"]')) {
//             editForm.querySelector('[name="inventory[owner_email]"]').value = data.owner_email;
//           }
//           if(editForm.querySelector('[name="inventory[user_email]"]')) {
//             editForm.querySelector('[name="inventory[user_email]"]').value = data.user_email;
//           }
//           if(editForm.querySelector('[name="inventory[sku]"]')) {
//             editForm.querySelector('[name="inventory[sku]"]').value = data.sku;
//           }
//         });
//     });
  
//     editForm.addEventListener('submit', function(event) {
//       event.preventDefault();
//       var formData = new FormData(editForm);
//       var editUrl = editForm.action;
  
//       fetch(editUrl, {
//         method: 'PATCH',
//         body: formData,
//         headers: {
//           'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
//         }
//       })
//       .then(response => response.json())
//       .then(data => {
//         if (data.status === 'success') {
//           $('#editInventoryModal').modal('hide');
//           $.ajax({
//             url: "/inventories",
//             type: "GET",
//             dataType: "script"
//           });
//         } else {
//           alert('Failed to update inventory item: ' + data.errors.join(', '));
//         }
//       });
//     });
//   });