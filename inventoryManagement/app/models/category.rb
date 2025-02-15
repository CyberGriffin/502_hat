class Category < ApplicationRecord
    belongs_to :parent_category, foreign_key: "parent_category", class_name: "ParentCategory", optional: false
    has_many :items, foreign_key: "category_name", dependent: :destroy
    
    validates :name, presence: true
    validates :parent_category, presence: true
end
  