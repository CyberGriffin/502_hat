class AddDeptIdToInventories < ActiveRecord::Migration[7.0]
  def change
    add_column :inventories, :dept_id, :string
  end
end
