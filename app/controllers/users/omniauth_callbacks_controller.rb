module Users
     class OmniauthCallbacksController < Devise::OmniauthCallbacksController
          def google_oauth2
               user = User.from_google(**from_google_params)

               if user&.persisted?
                    whitelist_entry = Whitelist.find_by(email: user.email)

                    if whitelist_entry.nil?
                         flash[:alert] = "#{user.email} is not authorized. You are not whitelisted."
                         redirect_to new_user_session_path
                    else
                         sign_out_all_scopes
                         sign_in_and_redirect user, event: :authentication
                    end
               else
                    flash[:alert] = if auth.info.email !~ /@tamu\.edu\z/
                                         "#{auth.info.email} is not authorized. Please use your TAMU issued email."
                                    else
                                         "#{auth.info.email} is not authorized. You are not whitelisted."
                                    end
                    redirect_to new_user_session_path
               end
          end

          protected

          def after_omniauth_failure_path_for(_scope)
               new_user_session_path
          end

          def after_sign_in_path_for(resource)
               user = resource
               department = Department.find_by(dept_id: user.dept_id)

               Rails.logger.debug "After sign-in - User: #{user.email}, Dept ID: #{user.dept_id}, Department Name: #{department&.name}"

               if department&.dept_id == "-"
                    Rails.logger.debug "After sign-in - Redirecting to department selection page"
                    edit_department_path
               else
                    Rails.logger.debug "After sign-in - Redirecting to inventory page"
                    stored_location_for(user) || root_path
               end
          end

          private

          def from_google_params
               @from_google_params ||= {
                    uid: auth.uid,
                    email: auth.info.email,
                    full_name: auth.info.name,
                    avatar_url: auth.info.image
               }
          end

          def auth
               @auth ||= request.env['omniauth.auth']
          end
     end
end
