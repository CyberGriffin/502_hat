class Category < ApplicationRecord
    self.primary_key = "cat_id"
    has_many :items, foreign_key: "category_id", dependent: :destroy

    validates :cat_id, presence: true, uniqueness: true
    validates :name, presence: true

    before_validation :set_default_cat_id, on: :create

    private

    def set_default_cat_id
        self.cat_id ||= SecureRandom.uuid
    end
end
