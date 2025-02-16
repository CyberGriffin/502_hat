class InventoriesController < ApplicationController
    before_action :set_inventory, only: [:show, :edit, :update, :destroy]
  
    def index
      if params[:search].present?
        @inventories = Inventory.search(params[:search])
      else
        @inventories = Inventory.all
      end
    end
  
    def show
    end
  
    def new
      @inventory = Inventory.new
    end
  
    def create
      @inventory = Inventory.new(inventory_params)
      if @inventory.save
        redirect_to @inventory, notice: "Inventory item created successfully."
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @inventory.update(inventory_params)
        redirect_to @inventory, notice: "Inventory item updated successfully."
      else
        render :edit
      end
    end
  
    def delete
        @inventories = Inventory.find(params[:id])
    end

    def destroy
      @inventories=Inventory.find(params[:id])
      @inventories.destroy
      flash[:notice]="Entry '#{@inventories.item.name}' deleted successfully."
      redirect_to(inventories_path)
    end
  
    private
  
    # Callback to set the inventory for actions that need it.
    def set_inventory
      @inventory = Inventory.find(params[:id])
    end
  
    # Strong parameters to allow only permitted attributes.
    def inventory_params
      params.require(:inventory).permit(
        :item_id,
        :year_of_purchase,
        :location,
        :condition_of_item,
        :owner_email,
        :user_email,
        :sku
      )
    end
  end
  