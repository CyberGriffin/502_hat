class TransactionHistory < ApplicationRecord
    belongs_to :inventory, foreign_key: 'inv_id', primary_key: 'inv_id', optional: true
    belongs_to :user, foreign_key: 'user_email', primary_key: 'email', optional: true
end
  