class User < ApplicationRecord
    self.primary_key = "email"
    belongs_to :department, foreign_key: "dept_id", optional: true
    has_many :current_inventories, class_name: "Inventory", foreign_key: "user_email"
    has_many :registered_inventories, class_name: "Inventory", foreign_key: "owner_email"
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :role, presence: true
    validates :dept_id, presence: true
    validates :is_white_listed, inclusion: { in: [true, false] }
    validates :white_list_end_date, presence: true, if: :is_white_listed
    

end
