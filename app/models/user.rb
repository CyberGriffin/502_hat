class User < ApplicationRecord
    self.primary_key = "email"
  
    devise :omniauthable, omniauth_providers: [:google_oauth2]
  
    belongs_to :department, foreign_key: "dept_id", optional: true
    has_many :current_inventories, class_name: "Inventory", foreign_key: "user_email"
    has_many :registered_inventories, class_name: "Inventory", foreign_key: "owner_email"
  
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :role, presence: true
    validates :dept_id, presence: true
    validates :is_white_listed, inclusion: { in: [true, false] }
    validates :white_list_end_date, presence: true, if: :is_white_listed
  
    def self.from_google(auth)
      return nil unless auth[:email].ends_with?("@tamu.edu")
      user = find_by(email: auth[:email])
    
      unless user
        department = Department.find_or_create_by!(dept_id: "-", name: "Not Selected") 
        user = create!(
          email: auth[:email],
          name: auth[:full_name],
          role: "user",
          dept_id: department.dept_id,
          is_white_listed: false,
          white_list_end_date: nil
        )
      end
    
      user
    end
end
  