class InventoriesController < ApplicationController
     before_action :set_inventory, only: [:show, :edit, :update, :destroy, :checkout, :return]
     def index
          @item = Item.new
          @inventory = Inventory.new
          @inventories = Inventory.includes(:item)
     end

     def show
          render :show
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
                    format.json { render json: { status: 'success' } }
                    format.js
               end
          else
               respond_to do |format|
                    format.html { redirect_to inventories_path, alert: 'Error adding item to inventory.' }
                    format.json { render json: { status: 'error', errors: @inventory.errors.full_messages } }
                    format.js { render json: { status: 'error', errors: @inventory.errors.full_messages }, status: :unprocessable_entity }
               end
          end
     end

     def edit
          @inventory = Inventory.find(params[:id])

          respond_to do |format|
               format.html
               format.js
               format.json { render json: @inventory.as_json(methods: :item_name) }
          end
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
                    format.js { render json: { status: 'error', errors: @inventory.errors.full_messages }, status: :unprocessable_entity }
               end
          end
     end

     def destroy
          @inventory.destroy
          redirect_to inventories_path
     end

     def multi_delete
          inventory_ids = params[:inventory_ids]

          if inventory_ids.present?
               Inventory.where(inv_id: inventory_ids).destroy_all
               render json: { status: 'success' }
          else
               render json: { status: 'error', errors: ['No items selected'] }, status: :unprocessable_entity
          end
     end

     def bulk_update
          updates = params[:updates]

          if updates.blank?
               render json: { status: 'error', message: 'No updates provided' }, status: :unprocessable_entity
               return
          end

          # Preload departments by name
          departments = Department.all.index_by(&:name)

          updates.each do |update|
               inventory = Inventory.find_by(inv_id: update[:inv_id])
               next unless inventory

               dept = departments[update[:dept_name]]
               dept_id = dept&.dept_id

               inventory.update(
                    location: update[:location],
                    condition_of_item: update[:condition_of_item],
                    owner_email: update[:owner_email],
                    dept_id:
               )
          end

          render json: { status: 'success' }
     end

     def checkout
          @inventory = Inventory.find(params[:id])
          if @inventory.user_email.nil?
               @inventory.update(user_email: current_user.email)

               TransactionHistory.create!(
                    inv_id: @inventory.inv_id,
                    action: 'checkout',
                    user_email: current_user.email,
                    transaction_date: Time.current
               )

               flash[:success] = "You have successfully checked out this item."
          else
               flash[:alert] = "This item is already checked out."
          end

          redirect_to inventories_path
     end

     def bulk_checkout
          inventory_ids = params[:inventory_ids]
          inventories = Inventory.where(inv_id: inventory_ids)

          num_updated = 0
          inventories.each do |inventory|
               next unless inventory.current_user.nil?

               inventory.update(current_user:)

               TransactionHistory.create!(
                    inv_id: inventory.inv_id,
                    action: 'checkout',
                    user_email: current_user.email,
                    transaction_date: Time.current
               )

               num_updated += 1
          end
          render json: { status: 'success', num_updated: }
     end

     def return
          @inventory = Inventory.find(params[:id])
          if @inventory.user_email == current_user.email
               @inventory.update(user_email: nil)

               TransactionHistory.create!(
                    inv_id: @inventory.inv_id,
                    action: 'return',
                    user_email: current_user.email,
                    transaction_date: Time.current
               )

               flash[:success] = "Item returned successfully."
          else
               flash[:alert] = "You cannot return an item you didn't check out."
          end
          redirect_to inventories_path
     end

     def bulk_return
          inventory_ids = params[:inventory_ids]
          inventories = Inventory.where(inv_id: inventory_ids)

          num_updated = 0
          inventories.each do |inventory|
               next unless inventory.current_user == current_user

               inventory.update(current_user: nil)

               TransactionHistory.create!(
                    inv_id: inventory.inv_id,
                    action: 'return',
                    user_email: current_user.email,
                    transaction_date: Time.current
               )

               num_updated += 1
          end
          render json: { status: 'success', num_updated: }
     end

     private

     def set_inventory
          @inventory = Inventory.find(params[:id])
     end

     def inventory_params
          params.require(:inventory).permit(:item_id, :year_of_purchase, :location, :condition_of_item, :owner_email, :user_email, :dept_id)
     end
end
