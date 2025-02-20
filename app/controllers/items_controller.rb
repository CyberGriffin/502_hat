class ItemsController < ApplicationController
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
      respond_to do |format|
        format.html { redirect_to inventories_path, notice: 'Item successfully created.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'inventories/index', status: :unprocessable_entity }
        format.js
      end
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category_id)
  end
end

# class ItemsController < ApplicationController
#   before_action :set_item, only: [:show, :edit, :update, :destroy]

#   def index
#     @items = Item.all
#   end

#   def new
#     @item = Item.new
#   end

#   def create
#     @item = Item.new(item_params)
#     if @item.save
#       redirect_to @item, notice: 'Item was successfully created.'
#     else
#       render :new
#     end
#   end

#   def show
#   end

#   def edit
#   end

#   def update
#     if @item.update(item_params)
#       redirect_to @item, notice: 'Item was successfully updated.'
#     else
#       render :edit
#     end
#   end

#   def destroy
#     @item.destroy
#     redirect_to items_path, notice: 'Item was successfully deleted.'
#   end

#   private

#   def set_item
#     @item = Item.find(params[:id])
#   end

#   def item_params
#     params.require(:item).permit(:name, :description, :category_id)
#   end
# end
