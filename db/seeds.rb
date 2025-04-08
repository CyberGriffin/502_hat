# Clear existing data and reset sequences
Inventory.delete_all
Item.delete_all
User.delete_all
Department.delete_all
Category.delete_all
Whitelist.delete_all

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
     { dept_id: "PETE", name: "Petroleum Engineering" }
])

# Create Categories
Category.create!([
     { cat_id: "TOOL", name: "Tool" },
     { cat_id: "EQUIP", name: "Equipment" },
     { cat_id: "MAT", name: "Material" }
])

# Create Users
User.create!([
     { email: "alice@example.com", name: "Alice Johnson",  dept_id: "CHEN" },
     { email: "bob@example.com", name: "Bob Williams", dept_id: "MEEN" },
     { email: "charlie@example.com", name: "Charlie Lee", dept_id: "ECEN" }
])

# Create Items
Item.create!([
     { item_id: "IT001", name: "Hammer", description: "16 oz claw hammer", category_id: "TOOL", sku: "HAMMER-16" },
     { item_id: "IT002", name: "Excavator", description: "Medium-sized hydraulic excavator", category_id: "EQUIP", sku: "EXCAV-123" },
     { item_id: "IT003", name: "Cement", description: "50 kg bag of cement", category_id: "MAT", sku: "CEMENT-50" },
     { item_id: "IT004", name: "Wrench", description: "Adjustable wrench", category_id: "TOOL", sku: "WRENCH-ADJ" },
     { item_id: "IT005", name: "Drill", description: "Cordless drill", category_id: "TOOL", sku: "DRILL-123" },
     { item_id: "IT006", name: "Laptop", description: "15-inch laptop with 16GB RAM", category_id: "EQUIP", sku: "LAPTOP-15" },
     { item_id: "IT007", name: "Steel Beam", description: "20 ft steel beam", category_id: "MAT", sku: "BEAM-20" },
     { item_id: "IT008", name: "Safety Goggles", description: "UV protection safety goggles", category_id: "TOOL", sku: "GOGGLES-UV" },
     { item_id: "IT009", name: "Concrete Mixer", description: "Portable concrete mixer", category_id: "EQUIP", sku: "MIXER-PORT" },
     { item_id: "IT010", name: "PVC Pipe", description: "10 ft PVC pipe", category_id: "MAT", sku: "PIPE-10" },
     { item_id: "IT011", name: "Screwdriver Set", description: "Set of 5 screwdrivers", category_id: "TOOL", sku: "SCREW-SET" },
     { item_id: "IT012", name: "Generator", description: "Portable generator", category_id: "EQUIP", sku: "GENERATOR-PORT" },
     { item_id: "IT013", name: "Sand", description: "50 kg bag of sand", category_id: "MAT", sku: "SAND-50" },
     { item_id: "IT014", name: "Pliers", description: "Set of pliers", category_id: "TOOL", sku: "PLIERS-SET" },
     { item_id: "IT015", name: "Forklift", description: "Electric forklift", category_id: "EQUIP", sku: "FORKLIFT-123" },
])

# Create Inventories
Inventory.create!([
     { item_id: "IT001", year_of_purchase: Date.new(2023, 5, 10), location: "Tool Shed", condition_of_item: "New", owner_email: "alice@example.com", dept_id: "CHEN" },
     { item_id: "IT002", year_of_purchase: Date.new(2023, 6, 15), location: "Equipment Yard", condition_of_item: "Used", owner_email: "bob@example.com", dept_id: "MEEN" },
     { item_id: "IT003", year_of_purchase: Date.new(2022, 11, 1), location: "Warehouse A", condition_of_item: "New", owner_email: "alice@example.com", user_email: "charlie@example.com", dept_id: "ECEN" },
     { item_id: "IT004", year_of_purchase: Date.new(2021, 3, 20), location: "Storage Room", condition_of_item: "Good", owner_email: "bob@example.com", dept_id: "MEEN" },
     { item_id: "IT005", year_of_purchase: Date.new(2020, 8, 5), location: "Lab 101", condition_of_item: "Fair", owner_email: "charlie@example.com", dept_id: "ECEN" },
     { item_id: "IT006", year_of_purchase: Date.new(2023, 1, 12), location: "Workshop", condition_of_item: "New", owner_email: "alice@example.com", dept_id: "CHEN" },
     { item_id: "IT007", year_of_purchase: Date.new(2022, 7, 18), location: "Warehouse B", condition_of_item: "Used", owner_email: "bob@example.com", dept_id: "MEEN" },
     { item_id: "IT008", year_of_purchase: Date.new(2021, 11, 25), location: "Tool Shed", condition_of_item: "Good", owner_email: "charlie@example.com", dept_id: "ECEN" },
     { item_id: "IT009", year_of_purchase: Date.new(2020, 4, 30), location: "Equipment Yard", condition_of_item: "Fair", owner_email: "alice@example.com", dept_id: "CHEN" },
     { item_id: "IT010", year_of_purchase: Date.new(2023, 2, 14), location: "Lab 202", condition_of_item: "New", owner_email: "bob@example.com", dept_id: "MEEN" },
     { item_id: "IT011", year_of_purchase: Date.new(2022, 9, 10), location: "Storage Room", condition_of_item: "Good", owner_email: "charlie@example.com", dept_id: "ECEN" },
     { item_id: "IT012", year_of_purchase: Date.new(2021, 6, 22), location: "Workshop", condition_of_item: "Used", owner_email: "alice@example.com", dept_id: "CHEN" },
     { item_id: "IT013", year_of_purchase: Date.new(2020, 12, 5), location: "Warehouse A", condition_of_item: "Fair", owner_email: "bob@example.com", dept_id: "MEEN" },
     { item_id: "IT014", year_of_purchase: Date.new(2023, 3, 8), location: "Tool Shed", condition_of_item: "New", owner_email: "charlie@example.com", dept_id: "ECEN" },
     { item_id: "IT015", year_of_purchase: Date.new(2022, 10, 19), location: "Lab 303", condition_of_item: "Good", owner_email: "alice@example.com", dept_id: "CHEN" }
])