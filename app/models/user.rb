class User < ApplicationRecord
    self.primary_key = "email"

    devise :omniauthable, omniauth_providers: [:google_oauth2]

    belongs_to :department, foreign_key: "dept_id", optional: true
    has_many :current_inventories, class_name: "Inventory", foreign_key: "user_email"
    has_many :registered_inventories, class_name: "Inventory", foreign_key: "owner_email"

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :dept_id, presence: true

    def profile_picture_url
      self[:profile_picture_url] || "https://via.placeholder.com/40"
    end

    def full_name
      name
    end

    def self.from_google(auth)
      return nil unless auth[:email].ends_with?("@tamu.edu")

      whitelisted_user = Whitelist.find_by(email: auth[:email])
      return nil unless whitelisted_user && (whitelisted_user.expires_at.nil? || whitelisted_user.expires_at >= Date.today)

      user = find_by(email: auth[:email])

      if user
        user.update(profile_picture_url: auth[:avatar_url])
      else
        department = Department.find_or_create_by!(dept_id: "-", name: "Not Selected")
        user = create!(
             email: auth[:email],
             name: auth[:full_name],
             dept_id: department.dept_id,
             profile_picture_url: auth[:avatar_url]
        )
      end

      user
    end
end
