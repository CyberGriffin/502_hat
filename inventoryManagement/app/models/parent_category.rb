class ParentCategory < ApplicationRecord
    has_many :categories, foreign_key: "parent_category"

    validates :parent_category, presence: true, uniqueness: true
end
