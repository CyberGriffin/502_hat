class CreateTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_histories do |t|
      t.bigint :inv_id, null: false
      t.string :action, null: false
      t.string :user_email, null: false
      t.datetime :transaction_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end


    add_foreign_key :transaction_histories, :inventories, column: :inv_id, primary_key: :inv_id, on_delete: :nullify
    add_foreign_key :transaction_histories, :users, column: :user_email, primary_key: :email, on_delete: :nullify
  end
end
