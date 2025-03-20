class AddSkuToItems < ActiveRecord::Migration[7.0]
     def change
          add_column :items, :sku, :string
     end
end
