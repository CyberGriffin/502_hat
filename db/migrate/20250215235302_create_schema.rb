class CreateSchema < ActiveRecord::Migration[7.0]
     def change
          # Categories Table
          create_table :categories, id: false do |t|
               t.string :cat_id, primary_key: true
               t.string :icon
               t.string :color_code

               t.timestamps
          end

          # Departments Table
          create_table :departments, id: false do |t|
               t.string :dept_id, primary_key: true
               t.string :name

               t.timestamps
          end

          # Items Table
          create_table :items, id: false do |t|
               t.string :item_id, primary_key: true
               t.string :name
               t.string :description
               t.string :category_id, null: false # Foreign Key

               t.timestamps
          end

          # Users Table
          create_table :users, id: false do |t|
               t.string :email, primary_key: true
               t.string :name
               t.string :role
               t.string :dept_id, null: false # Foreign Key
               t.boolean :is_white_listed, default: false
               t.date :white_list_end_date

               t.timestamps
          end

          # Inventories Table (Fixed primary key issue)
          create_table :inventories, id: false do |t|
               t.bigint :inv_id, primary_key: true # Correctly set inv_id as PK
               t.string :item_id, null: false # Foreign Key
               t.date :year_of_purchase
               t.string :location
               t.string :condition_of_item
               t.string :owner_email, null: false # Foreign Key (Original Owner)
               t.string :user_email, null: false # Foreign Key (Current User)
               t.string :sku

               t.timestamps
          end

          # Add Foreign Key Constraints
          add_foreign_key :items, :categories, column: :category_id, primary_key: :cat_id
          add_foreign_key :users, :departments, column: :dept_id, primary_key: :dept_id
          add_foreign_key :inventories, :items, column: :item_id, primary_key: :item_id
          add_foreign_key :inventories, :users, column: :owner_email, primary_key: :email
          add_foreign_key :inventories, :users, column: :user_email, primary_key: :email
     end
end
