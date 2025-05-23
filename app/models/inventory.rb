class Inventory < ApplicationRecord
    self.primary_key = "inv_id"
    belongs_to :item, foreign_key: "item_id"
    belongs_to :original_owner, class_name: "User", foreign_key: "owner_email"
    belongs_to :current_user, class_name: "User", foreign_key: "user_email", optional: true
    belongs_to :department, foreign_key: "dept_id"

    has_many :transaction_histories, foreign_key: 'inv_id', primary_key: 'inv_id'

    validates :item_id, :year_of_purchase, :location, :condition_of_item, :owner_email, :dept_id, presence: true
    validates :user_email, presence: false

    def available?
        user_email.nil?
    end

    def self.search(search)
        if search
            joins(:item).where(
                 "LOWER(items.name) LIKE :search OR " \
                 "LOWER(inventories.location) LIKE :search OR " \
                 "LOWER(inventories.condition_of_item) LIKE :search OR " +
                 # "LOWER(inventories.sku) LIKE :search OR " +
                 "LOWER(inventories.owner_email) LIKE :search OR " \
                 "LOWER(inventories.user_email) LIKE :search",
                 "LOWER(inventories.dept_id) LIKE :search",
                 search: "%#{search.downcase}%"
            )
        else
            all
        end
    end

    def self.sort_by_column(sort_column, sort_direction)
        if sort_column == 'name'
            order(Arel.sql("items.name #{sort_direction}"))
        else
            order(Arel.sql("inventories.#{sort_column} #{sort_direction}"))
        end
    end

    def item_name
        item.name
    end
end
