require 'rails_helper'

RSpec.describe User, type: :model do
  
  subject { described_class.new(email: "test@example.com", name: "Test User", role: "Admin", department_id: "IT") }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a role" do
      subject.role = nil
      expect(subject).to_not be_valid
    end

    it "ensures email is unique" do
      duplicate_user = User.new(email: "test@example.com", name: "Another User", role: "User", department_id: "HR")
      subject.save
      expect(duplicate_user).to_not be_valid
    end
  end

  describe "Associations" do
    it { should have_many(:user_inventories).with_foreign_key(:user_email) }
    it { should have_many(:owned_inventories).with_foreign_key(:owner_email) }

  end
end
