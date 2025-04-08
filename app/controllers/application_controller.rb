class ApplicationController < ActionController::Base
     before_action :authenticate_user!
     before_action :require_department_selection
     private
   
     def require_department_selection
          return unless user_signed_in?
          return if current_user.dept_id.present? && current_user.dept_id != '-'
     
          allowed_paths = [
               edit_department_path,
               update_department_path,
               destroy_user_session_path
          ]

          unless allowed_paths.include?(request.path)
               redirect_to edit_department_path
          end
     end
end
   