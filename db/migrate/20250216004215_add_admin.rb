class AddAdmin < ActiveRecord::Migration[7.0]
     def change
          create_table :admins do |t|
               t.string :email, null: false
               t.string :full_name
               t.string :uid
               t.string :avatar_url
               t.timestamps null: false
          end
          add_index :admins, :email, unique: true
     end
end
