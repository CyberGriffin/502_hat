class Whitelist < ApplicationRecord
     validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
   
     validates :roles, inclusion: { in: ['user', 'admin'], message: "%{value} is not a valid role" }
   
     after_initialize :set_default_role, if: :new_record?
   
     def expired?
       expires_at.present? && expires_at < Date.today
     end
   
     private
   
     def set_default_role
       self.roles ||= 'user'
     end
   end
   