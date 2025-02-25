class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def edit_department
    @departments = Department.all.order(:name)
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
    render :index  # Ensure a view file exists (see Step 3)
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

  private

  # Note: Use params[:email] because of the route configuration.
  def set_user
    @user = User.find_by!(email: params[:email])
  end

  def user_params
    # Permit these fields for both create and update.
    permitted = [:name, :role, :dept_id, :is_white_listed, :white_list_end_date]
    # Only allow email on creation, not on update.
    permitted << :email if action_name == "create"
    params.require(:user).permit(permitted)
  end
end
