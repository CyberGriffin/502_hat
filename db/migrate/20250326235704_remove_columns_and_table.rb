class RemoveColumnsAndTable < ActiveRecord::Migration[7.0]
     def change
          remove_column :categories, :icon, :string
          remove_column :categories, :color_code, :string

          drop_table :admins

          remove_column :users, :role, :string
          remove_column :users, :is_white_listed, :boolean
          remove_column :users, :white_list_end_date, :date
     end
end
