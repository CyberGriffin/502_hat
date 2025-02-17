class User < ApplicationRecord
    self.primary_key = "email"
    belongs_to :department, foreign_key: "dept_id", optional: true
    has_many :current_inventories, class_name: "Inventory", foreign_key: "user_email"
    has_many :registered_inventories, class_name: "Inventory", foreign_key: "owner_email"
end
