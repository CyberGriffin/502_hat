class AddNameToCategories < ActiveRecord::Migration[7.0]
     def change
          add_column :categories, :name, :string, default: "Unnamed Category", null: false
     end
end
