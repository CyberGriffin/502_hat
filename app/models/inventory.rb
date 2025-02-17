class Inventory < ApplicationRecord
    self.primary_key = "inv_id"
    belongs_to :item, foreign_key: "item_id"
    belongs_to :original_owner, class_name: "User", foreign_key: "owner_email"
    belongs_to :current_user, class_name: "User", foreign_key: "user_email"

    def self.search(query)
        joins(:item).where("items.name LIKE ?", "%#{query}%")
    end
end
