class Category < ApplicationRecord
    self.primary_key = "cat_id"
    has_many :items, foreign_key: "category_id", dependent: :destroy

    before_validation :generate_cat_id, on: :create
    validates :cat_id, presence: true, uniqueness: true
    validates :name, presence: true

    def generate_cat_id
        self.cat_id ||= SecureRandom.uuid
    end
end
