class UsersController < ApplicationController
     before_action :set_user, only: %i[show edit update destroy]

     def toggle_role
          if current_user.admin?
               current_user.update(role: 'user')
          else
               current_user.update(role: 'admin')
          end
          redirect_back(fallback_location: root_path)
     end
     

     def edit_department
          @departments = Department.where.not(dept_id: "-").order(:name)
     end

     def update_department
          if current_user.update(user_params)
               flash[:success] = "Department was successfully updated."
               redirect_to root_path
          else
               flash[:alert] = "There was an error updating the department."
               render :edit_department
          end
     end

     def index
          @users = User.all
          render :index
     end

     def show
          render :show
     end

     def new
          @user = User.new
          render :new
     end

     def edit
          render :edit
     end

     def create
          @user = User.new(user_params)
          if @user.save
               redirect_to user_path(@user.email), notice: "User was successfully created."
          else
               render :new, status: :unprocessable_entity
          end
     end

     def update
          if @user.update(user_params)
               redirect_to user_path(@user.email), notice: "User was successfully updated."
          else
               render :edit, status: :unprocessable_entity
          end
     end

     def destroy
          @user.destroy
          redirect_to app_users_path, notice: "User was successfully destroyed."
     end

     def search
          if params[:q].present?
            users = User.where("name LIKE ? OR email LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
                        .limit(10)
                        .select(:id, :name, :email)
            render json: users
          else
            render json: []
          end
        end
        
   

     private

     # NOTE: Use params[:email] because of the route configuration.
     def set_user
          if params[:email].present?
               @user = User.find_by!(email: params[:email])
          end
     end


     def user_params
          # Permit these fields for both create and update.
          permitted = [:name, :role, :dept_id, :is_white_listed, :white_list_end_date]
          # Only allow email on creation, not on update.
          permitted << :email if action_name == "create"
          params.require(:user).permit(permitted)
     end
end
