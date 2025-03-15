require 'rails_helper'

RSpec.describe Whitelist, type: :model do
     describe 'validations' do
          context 'sunny cases (valid scenarios)' do
               it 'is valid with a valid email and no expires_at' do
                    whitelist = Whitelist.new(email: 'user@example.com')
                    expect(whitelist).to be_valid
               end

               it 'is valid with a valid email and future expires_at' do
                    whitelist = Whitelist.new(email: 'user@example.com', expires_at: Date.today + 7.days)
                    expect(whitelist).to be_valid
               end
          end

          context 'rainy cases (invalid scenarios)' do
               it 'is invalid without an email' do
                    whitelist = Whitelist.new
                    expect(whitelist).not_to be_valid
                    expect(whitelist.errors[:email]).to include("can't be blank")
               end

               it 'is invalid with an improperly formatted email' do
                    whitelist = Whitelist.new(email: 'invalid-email')
                    expect(whitelist).not_to be_valid
                    expect(whitelist.errors[:email]).to include('is invalid')
               end

               it 'is invalid if the email is not unique' do
                    Whitelist.create!(email: 'user@example.com')
                    duplicate_whitelist = Whitelist.new(email: 'user@example.com')

                    expect(duplicate_whitelist).not_to be_valid
                    expect(duplicate_whitelist.errors[:email]).to include('has already been taken')
               end
          end
     end

     describe '#expired?' do
          context 'when expires_at is in the past' do
               it 'returns true' do
                    whitelist = Whitelist.new(email: 'user@example.com', expires_at: Date.yesterday)
                    expect(whitelist.expired?).to be true
               end
          end

          context 'when expires_at is today or in the future' do
               it 'returns false when expires_at is today' do
                    whitelist = Whitelist.new(email: 'user@example.com', expires_at: Date.today)
                    expect(whitelist.expired?).to be false
               end

               it 'returns false when expires_at is in the future' do
                    whitelist = Whitelist.new(email: 'user@example.com', expires_at: Date.today + 5.days)
                    expect(whitelist.expired?).to be false
               end
          end

          context 'when expires_at is nil' do
               it 'returns false' do
                    whitelist = Whitelist.new(email: 'user@example.com', expires_at: nil)
                    expect(whitelist.expired?).to be false
               end
          end
     end
end
