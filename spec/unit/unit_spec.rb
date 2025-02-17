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
  
      it 'is not valid without a cat_id' do
        category = Category.new(icon: '🍕', color_code: '#FFC300')
        expect(category).not_to be_valid
      end

  end
end
