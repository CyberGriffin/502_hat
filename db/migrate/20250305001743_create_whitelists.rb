class CreateWhitelists < ActiveRecord::Migration[7.0]
     def change
          create_table :whitelists do |t|
               t.string :email
               t.date :expires_at

               t.timestamps
          end
          add_index :whitelists, :email
     end
end
