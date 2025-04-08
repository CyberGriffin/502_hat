require 'rails_helper'

RSpec.describe Category, type: :model do
     describe 'validations' do
          context 'sunny cases (valid scenarios)' do
               it 'is valid with valid attributes' do
                    category = Category.new(
                         cat_id: 'fast_food',
                         name: 'Fast Food',
                    )
                    expect(category).to be_valid
               end

               it 'is valid without providing a name (uses default)' do
                    category = Category.new(
                         cat_id: 'default_name'
                    )
                    expect(category).to be_valid
                    expect(category.name).to eq('Unnamed Category')
               end
          end

          context 'rainy cases (invalid scenarios)' do
               it 'is invalid without a cat_id' do
                    category = Category.new(
                         name: 'Fast Food',
                    )
                    expect(category).not_to be_valid
                    expect(category.errors[:cat_id]).to include("can't be blank")
               end

               it 'is invalid if cat_id is not unique' do
                    Category.create!(cat_id: 'fast_food', name: 'Fast Food')

                    duplicate_category = Category.new(
                         cat_id: 'fast_food',
                         name: 'Burgers',
                    )

                    expect(duplicate_category).not_to be_valid
                    expect(duplicate_category.errors[:cat_id]).to include("has already been taken")
               end
          end
     end
end
