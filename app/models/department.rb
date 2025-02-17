class Department < ApplicationRecord
    self.primary_key = "dept_id"
    has_many :users, foreign_key: "dept_id", dependent: :nullify
end
