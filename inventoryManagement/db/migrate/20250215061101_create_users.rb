class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|  # Disables automatic 'id' column
      t.string :email, primary_key: true  # Sets email as primary key
      t.string :name
      t.string :role
      t.string :department_id
      t.timestamps
    end
  end
end
