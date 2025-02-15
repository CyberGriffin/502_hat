# frozen_string_literal: true

class CategoriesController < ApplicationController
    def index
      @categories = Category.order(:name)
    end
  
    def show
      @category = Category.find_by!(name: params[:name])
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
      @category = Category.find_by!(name: params[:name])
    end
  
    def update
      @category = Category.find_by!(name: params[:name])
      if @category.update(category_params)
        redirect_to(category_path(@category), notice: 'Category was successfully updated.')
      else
        flash[:alert] = 'There was an error updating the category.'
        render('edit')
      end
    end
  
    def delete
      @category = Category.find_by!(name: params[:name])
    end
  
    def destroy
      @category = Category.find_by!(name: params[:name])
      @category.destroy
      redirect_to(categories_path, notice: 'Category was successfully deleted.')
    end
  
    private
  
    def category_params
      params.require(:category).permit(:name, :parent_category_id, :icon, :color_code)
    end
  end
  