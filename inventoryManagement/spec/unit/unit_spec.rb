require 'rails_helper'

RSpec.describe ParentCategory, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      parent_category = ParentCategory.new(
        parent_category: 'food',
        icon: '🍔',
        color_code: '#FF5733'
      )
      expect(parent_category).to be_valid
    end

    it 'is not valid without a parent_category' do
      parent_category = ParentCategory.new(icon: '🍔', color_code: '#FF5733')
      expect(parent_category).not_to be_valid
    end
  end
end

RSpec.describe Category, type: :model do
    let(:parent_category) { ParentCategory.create(parent_category: 'food', icon: '🍔', color_code: '#FF5733') }
  
    describe 'validations' do
      it 'is valid with valid attributes' do
        category = Category.new(
          name: 'fast_food',
          parent_category: parent_category,  # Use the object instead of the string
          icon: '🍕',
          color_code: '#FFC300'
        )
        expect(category).to be_valid
      end
  
      it 'is not valid without a name' do
        category = Category.new(parent_category: parent_category, icon: '🍕', color_code: '#FFC300')
        expect(category).not_to be_valid
      end

      it 'is not valid without a parent_category' do
        category = Category.new(name: 'fast_food', icon: '🍕', color_code: '#FFC300')
        expect(category).not_to be_valid
      end
  end
end
