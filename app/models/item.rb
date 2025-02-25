class Item < ApplicationRecord
    self.primary_key = "item_id"
    belongs_to :category, foreign_key: "category_id"
    has_many :inventories, foreign_key: "item_id", dependent: :destroy

    before_validation :generate_item_id, on: :create

    # validate :original_owner_email_exists

    private

    def generate_item_id
        self.item_id = SecureRandom.uuid
    end
end
