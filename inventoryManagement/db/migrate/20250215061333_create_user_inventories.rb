class CreateUserInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :user_inventories do |t|
      t.string :owner_email
      t.string :user_email
      t.integer :inventory_id

      t.timestamps
    end
  end
end
