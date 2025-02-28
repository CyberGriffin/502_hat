class RemoveSkuFromInventories < ActiveRecord::Migration[7.0]
     def change
          remove_column :inventories, :sku, :string
     end
end
