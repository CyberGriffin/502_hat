# frozen_string_literal: true

class CategoriesController < ApplicationController
     before_action :authenticate_admin!
     def index
          @categories = Category.order(:cat_id)
     end

     def show
          @category = Category.find(params[:cat_id])
     end

     def new
          @category = Category.new
     end

     def create
          @category = Category.new(category_params)
          if @category.save
               redirect_to(categories_path, notice: 'Category was successfully created.')
          else
               flash[:alert] = 'There was an error creating the category.'
               render('new')
          end
     end

     def edit
          @category = Category.find(params[:cat_id])
     end

     def update
          @category = Category.find(params[:cat_id])
          if @category.update(category_params)
               redirect_to(categories_path, notice: 'Category was successfully updated.')
          else
               flash[:alert] = 'There was an error updating the category.'
               render('edit')
          end
     end

     def delete
          @category = Category.find(params[:cat_id])
     end

     def destroy
          @category = Category.find(params[:cat_id])
          @category.destroy
          redirect_to(categories_path, notice: 'Category was successfully deleted.')
     end

     private

     def category_params
          params.require(:category).permit(:name, :icon, :color_code)
     end

     def authenticate_admin!
          whitelist_entry = Whitelist.find_by(email: current_user&.email)
  
          redirect_to root_path, alert: "Not authorized" unless whitelist_entry&.roles == 'admin'
     end
end
