class AddProfilePictureToUsers < ActiveRecord::Migration[7.0]
     def change
          add_column :users, :profile_picture_url, :string
     end
end
