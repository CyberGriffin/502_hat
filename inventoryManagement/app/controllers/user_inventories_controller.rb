class UserInventoriesController < ApplicationController
  before_action :set_user_inventory, only: %i[ show edit update destroy ]

  # GET /user_inventories or /user_inventories.json
  def index
    @user_inventories = UserInventory.all
  end

  # GET /user_inventories/1 or /user_inventories/1.json
  def show
  end

  # GET /user_inventories/new
  def new
    @user_inventory = UserInventory.new
  end

  # GET /user_inventories/1/edit
  def edit
  end

  # POST /user_inventories or /user_inventories.json
  def create
    @user_inventory = UserInventory.new(user_inventory_params)

    respond_to do |format|
      if @user_inventory.save
        format.html { redirect_to @user_inventory, notice: "User inventory was successfully created." }
        format.json { render :show, status: :created, location: @user_inventory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_inventories/1 or /user_inventories/1.json
  def update
    respond_to do |format|
      if @user_inventory.update(user_inventory_params)
        format.html { redirect_to @user_inventory, notice: "User inventory was successfully updated." }
        format.json { render :show, status: :ok, location: @user_inventory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_inventories/1 or /user_inventories/1.json
  def destroy
    @user_inventory.destroy

    respond_to do |format|
      format.html { redirect_to user_inventories_path, status: :see_other, notice: "User inventory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_inventory
      @user_inventory = UserInventory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_inventory_params
      params.require(:user_inventory).permit(:owner_email, :user_email, :inventory_id)
    end
end
