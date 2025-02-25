class InventoriesController < ApplicationController
    before_action :set_inventory, only: [:show, :edit, :update, :destroy]
    def index
        @item = Item.new
        @inventory = Inventory.new
        @inventories = Inventory.includes(:item)
    end

    def new
        @inventory = Inventory.new
    end

    def create
        @inventory = Inventory.new(inventory_params)
        @inventory.user_email = nil if @inventory.user_email.blank?
    
        if @inventory.save
          respond_to do |format|
            format.html { redirect_to inventories_path, notice: 'Item successfully added to inventory.' }
            format.js
          end
        else
          respond_to do |format|
            format.html { redirect_to inventories_path, alert: 'Error adding item to inventory.' }
            format.js
          end
        end
      end

    def edit
        @inventory = Inventory.find(params[:id])
        render json: @inventory.as_json(methods: :item_name)
    end
      

    def update
        @inventory = Inventory.find(params[:id])
        if @inventory.update(inventory_params)
          respond_to do |format|
            format.html { redirect_to inventories_path, notice: 'Inventory item was successfully updated.' }
            format.json { render json: { status: 'success' } }
            format.js
          end
        else
          respond_to do |format|
            format.html { redirect_to inventories_path, alert: 'Error updating inventory item.' }
            format.json { render json: { status: 'error', errors: @inventory.errors.full_messages } }
            format.js
          end
        end
      end
      

    def destroy
        @inventory.destroy
        redirect_to inventories_path, notice: 'Inventory item was deleted.'
    end

    private

    def set_inventory
        @inventory = Inventory.find(params[:id])
    end

    def inventory_params
        params.require(:inventory).permit(:item_id, :year_of_purchase, :location, :condition_of_item, :owner_email, :user_email)
    end
end
