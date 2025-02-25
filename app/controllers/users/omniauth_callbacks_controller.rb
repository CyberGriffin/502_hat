class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_google(**from_google_params)

    if user&.persisted?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google',
                        reason: "#{auth.info.email} is not authorized. Please use your TAMU issued email."
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
      return edit_department_path
    else
      Rails.logger.debug "After sign-in - Redirecting to inventory page"
      return stored_location_for(user) || root_path
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
