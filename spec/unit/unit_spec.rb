require 'rails_helper'

RSpec.describe Category, type: :model do
    describe 'validations' do
      it 'is valid with valid attributes' do
        category = Category.new(
          cat_id: 'fast_food',
          icon: '🍕',
          color_code: '#FFC300'
        )
        expect(category).to be_valid
      end
  
      it 'automatically generates a cat_id if not provided' do
        category = Category.new(name: "Fast Food", icon: '🍕', color_code: '#FFC300')
        category.valid?  # Triggers before_validation
        expect(category.cat_id).not_to be_nil
      end

  end
end
