require 'rails_helper'

RSpec.describe TransactionHistory, type: :model do
  describe "validations" do
    it "should be valid with correct attributes" do
      category = Category.create!(
        cat_id: "sample_category",
        name: "Sample Category")

      user = User.create!(
        email: "alice@example.com", 
        name: "Alice Johnson",  
        dept_id: "CHEN" 
      )
    
      item = Item.create!(
        name: "Sample Item",
        description: "Sample Item Description",
        category_id: category.cat_id,
        sku: "SKU123"
      )

      inventory = Inventory.create!(
        item_id: item.item_id,
        location: "Warehouse",
        condition_of_item: "New",
        year_of_purchase: Date.today,
        owner_email: user.email,
        user_email: nil,
        dept_id: "CSCE"
      )

      transaction = TransactionHistory.create!(
        inv_id: inventory.inv_id,
        action: "checkout",
        user_email: "alice@example.com",
        transaction_date: Time.current
      )

      expect(transaction).to be_valid
    end
  end
end
