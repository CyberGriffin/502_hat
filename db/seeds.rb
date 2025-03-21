# Clear existing data and reset sequences
Inventory.delete_all
Item.delete_all
User.delete_all
Department.delete_all
Category.delete_all
Whitelist.delete_all
Admin.delete_all

# Reset primary key auto-increment values
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='inventories'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='items'")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='users'")

# Create Departments
Department.create!([
     { dept_id: "AERO", name: "Aerospace Engineering" },
     { dept_id: "CPSC", name: "Computer Science" },
     { dept_id: "BAEN", name: "Biological and Agricultural Engineering" },
     { dept_id: "BMEN", name: "Biomedical Engineering" },
     { dept_id: "CHEN", name: "Chemical Engineering" },
     { dept_id: "CVEN", name: "Civil and Environmental Engineering" },
     { dept_id: "CSCE", name: "Computer Science and Engineering" },
     { dept_id: "ECEN", name: "Electrical and Computer Engineering" },
     { dept_id: "ENTC", name: "Engineering Technology and Industrial Distribution" },
     { dept_id: "ISEN", name: "Industrial and Systems Engineering" },
     { dept_id: "MSEN", name: "Materials Science and Engineering" },
     { dept_id: "MEEN", name: "Mechanical Engineering" },
     { dept_id: "MXET", name: "Multidisciplinary Engineering" },
     { dept_id: "NUEN", name: "Nuclear Engineering" },
     { dept_id: "OCEN", name: "Ocean Engineering" },
     { dept_id: "PETE", name: "Petroleum Engineering" },
     { dept_id: "-", name: "Not Selected" }
])

# Create Categories
Category.create!([
     { cat_id: "TOOL", name: "Tool", icon: "🔧", color_code: "#DAF7A6" },
     { cat_id: "EQUIP", name: "Equipment", icon: "🚜", color_code: "#900C3F" },
     { cat_id: "MAT", name: "Material", icon: "🏠", color_code: "#C70039" }
])

# Create Whitelists
Whitelist.create!([
     { email: "kwohjinyuan@tamu.edu", expires_at: Date.today + 1.year },
     { email: "suresh06192004@tamu.edu", expires_at: Date.today + 1.year },
     { email: "admin1@example.com", expires_at: nil }
])

# Create Users
User.create!([
     { email: "alice@example.com", name: "Alice Johnson", role: "Admin", dept_id: "CHEN" },
     { email: "bob@example.com", name: "Bob Williams", role: "Staff", dept_id: "MEEN" },
     { email: "charlie@example.com", name: "Charlie Lee", role: "Technician", dept_id: "ECEN" }
])

# Create Items
Item.create!([
     { item_id: "IT001", name: "Hammer", description: "16 oz claw hammer", category_id: "TOOL", sku: "HAMMER-16" },
     { item_id: "IT002", name: "Excavator", description: "Medium-sized hydraulic excavator", category_id: "EQUIP", sku: "EXCAV-123" },
     { item_id: "IT003", name: "Cement", description: "50 kg bag of cement", category_id: "MAT", sku: "CEMENT-50" }
])

# Create Inventories
Inventory.create!([
     { item_id: "IT001", year_of_purchase: Date.new(2023, 5, 10), location: "Tool Shed", condition_of_item: "New", owner_email: "alice@example.com", dept_id: "CHEN" },
     { item_id: "IT002", year_of_purchase: Date.new(2023, 6, 15), location: "Equipment Yard", condition_of_item: "Used", owner_email: "bob@example.com", dept_id: "MEEN" },
     { item_id: "IT003", year_of_purchase: Date.new(2022, 11, 1), location: "Warehouse A", condition_of_item: "New", owner_email: "alice@example.com", user_email: "charlie@example.com",
       dept_id: "ECEN" }
])
