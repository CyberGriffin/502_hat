class ItemsController < ApplicationController
     before_action :set_item, only: [:show, :edit, :update, :destroy]

     def index
          @items = Item.includes(:category)
          @item = Item.new

          respond_to do |format|
               format.html
               format.json { render json: @items.as_json(include: { category: { only: :name } }) }
          end
     end

     def show
          respond_to do |format|
               format.html
               format.json { render json: @item }
          end
     end

     def new
          @item = Item.new
     end

     def create
          @item = Item.new(item_params)

          if @item.save
               respond_to do |format|
                    format.html { redirect_to items_path, notice: 'Item successfully created.' }
                    format.json { render json: { status: 'success', item: @item } }
                    format.js
               end
          else
               respond_to do |format|
                    format.html { redirect_to items_path, alert: 'Error creating item.' }
                    format.json { render json: { status: 'error', errors: @item.errors.full_messages }, status: :unprocessable_entity }
                    format.js { render json: { status: 'error', errors: @item.errors.full_messages }, status: :unprocessable_entity }
               end
          end
     end

     def edit
          respond_to do |format|
               format.html
               format.js
               format.json { render json: @item }
          end
     end

     def update
          if @item.update(item_params)
               respond_to do |format|
                    format.html { redirect_to items_path, notice: 'Item successfully updated.' }
                    format.json { render json: { status: 'success', item: @item } }
                    format.js
               end
          else
               respond_to do |format|
                    format.html { redirect_to items_path, alert: 'Error updating item.' }
                    format.json { render json: { status: 'error', errors: @item.errors.full_messages }, status: :unprocessable_entity }
                    format.js { render json: { status: 'error', errors: @item.errors.full_messages }, status: :unprocessable_entity }
               end
          end
     end

     def delete
          @item = Item.find(params[:id])
     end

     def destroy
          if @item.destroy
               respond_to do |format|
                    format.html { redirect_to items_path, notice: 'Item successfully deleted.' }
                    format.json { render json: { status: 'success' } }
                    format.js
               end
          else
               respond_to do |format|
                    format.html { redirect_to items_path, alert: 'Error deleting item.' }
                    format.json { render json: { status: 'error', errors: @item.errors.full_messages }, status: :unprocessable_entity }
                    format.js { render json: { status: 'error', errors: @item.errors.full_messages }, status: :unprocessable_entity }
               end
          end
     end

     private

     def set_item
          @item = Item.find(params[:id])
     end

     def item_params
          params.require(:item).permit(:name, :description, :category_id, :sku)
     end
end
