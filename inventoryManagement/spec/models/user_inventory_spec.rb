require 'rails_helper'

RSpec.describe UserInventory, type: :model do
  let(:user) { User.create(email: "test@example.com", name: "Test User", role: "Admin", department_id: "IT") }
  subject { described_class.new(owner_email: user.email, user_email: user.email, inventory_id: 1) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an owner_email" do
      subject.owner_email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a user_email" do
      subject.user_email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an inventory_id" do
      subject.inventory_id = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:user).with_foreign_key(:user_email) }
    it { should belong_to(:owner).with_foreign_key(:owner_email) }

  end
end
