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
          cell.textContent = cell.dataset.full;
        } else {
          cell.classList.remove('wrap');
          cell.classList.add('truncate');
          cell.textContent = cell.dataset.short;
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