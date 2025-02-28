class MakeUserEmailOptional < ActiveRecord::Migration[7.0]
     def change
          change_column_null :inventories, :user_email, true
     end
end
