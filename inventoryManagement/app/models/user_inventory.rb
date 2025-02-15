class UserInventory < ApplicationRecord
    belongs_to :user, foreign_key: "user_email"
    belongs_to :owner, class_name: "User", foreign_key: "owner_email", primary_key: "email"  # 👈 Add this
    belongs_to :inventory, foreign_key: "inventory_id", optional: true
    validates :owner_email, presence: true
    validates :user_email, presence: true
    validates :inventory_id, presence: true
end
