class AddRolesToWhitelists < ActiveRecord::Migration[7.0]
  def change
    add_column :whitelists, :roles, :string
  end
end
