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
      user = find_by(email: auth[:email])
    
      unless user
        department = Department.find_by(name: "-") || Department.first 
        user = create!(
          email: auth[:email],
          name: auth[:full_name],
          role: "user",
          dept_id: department&.id,
          is_white_listed: false,
          white_list_end_date: nil
        )
      end
    
      user
    end
end
  