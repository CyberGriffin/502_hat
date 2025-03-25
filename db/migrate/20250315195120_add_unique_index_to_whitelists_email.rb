class AddUniqueIndexToWhitelistsEmail < ActiveRecord::Migration[6.1]
     def change
          remove_index :whitelists, :email if index_exists?(:whitelists, :email)

          add_index :whitelists, :email, unique: true
     end
end
