class User < ApplicationRecord
    belongs_to :department, foreign_key: "department_id", optional: true
    has_many :user_inventories, foreign_key: "user_email"
    has_many :owned_inventories, class_name: "UserInventory", foreign_key: "owner_email"  # 👈 Add this
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :role, presence: true
end
