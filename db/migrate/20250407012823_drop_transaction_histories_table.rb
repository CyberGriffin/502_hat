class DropTransactionHistoriesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :transaction_histories
  end
end
