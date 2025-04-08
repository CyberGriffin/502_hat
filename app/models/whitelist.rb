class Whitelist < ApplicationRecord
     validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
   
     enum roles: { user: 'user', admin: 'admin' }
     
     def expired?
       expires_at.present? && expires_at < Date.today
     end
   
     private
   
     def set_default_role
       self.roles ||= 'user'
     end
   end
   