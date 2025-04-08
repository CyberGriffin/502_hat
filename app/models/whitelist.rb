class Whitelist < ApplicationRecord
     validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
   
     validates :roles, inclusion: { in: ['user', 'admin'], message: "%{value} is not a valid role" }
   
     validate :validate_role
   
     def expired?
       expires_at.present? && expires_at < Date.today
     end
   
     private
   
     def set_default_role
       self.roles ||= 'user'
     end

     def validate_role
      valid_roles = ['user', 'admin']
      unless valid_roles.include?(roles)
        errors.add(:roles, "#{roles} is not a valid role")
      end
     end
   end
   