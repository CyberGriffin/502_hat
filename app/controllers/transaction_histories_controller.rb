class TransactionHistoriesController < ApplicationController
    before_action :authenticate_user!
  
    def index

      Rails.logger.debug "Inventory ID passed: #{params[:inventory_id]}"

      if params[:inventory_id]
        @inventory = Inventory.find_by(inv_id: params[:inventory_id])
        if @inventory
          @transaction_histories = @inventory.transaction_histories.order(created_at: :desc)
        else
          flash[:alert] = "Inventory item not found"
          redirect_to inventories_path
        end
      else
        flash[:alert] = "Invalid inventory ID"
        redirect_to inventories_path
      end
    end
  end
  