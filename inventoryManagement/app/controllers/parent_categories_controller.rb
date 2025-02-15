# frozen_string_literal: true

class ParentCategoriesController < ApplicationController
    def index
      @parent_categories = ParentCategory.order(:parent_category)
    end
  
    def show
      @parent_category = ParentCategory.find(params[:parent_category])
    end
  
    def new
      @parent_category = ParentCategory.new
    end
  
    def create
      @parent_category = ParentCategory.new(parent_category_params)
      if @parent_category.save
        redirect_to(parent_categories_path, notice: 'Parent category was successfully created.')
      else
        flash[:alert] = 'There was an error creating the parent category.'
        render('new')
      end
    end
  
    def edit
      @parent_category = ParentCategory.find(params[:parent_category])
    end
  
    def update
      @parent_category = ParentCategory.find(params[:parent_category])
      if @parent_category.update(parent_category_params)
        redirect_to(parent_category_path(@parent_category), notice: 'Parent category was successfully updated.')
      else
        flash[:alert] = 'There was an error updating the parent category.'
        render('edit')
      end
    end
  
    def delete
      @parent_category = ParentCategory.find(params[:parent_category])
    end
  
    def destroy
      @parent_category = ParentCategory.find(params[:parent_category])
      @parent_category.destroy
      redirect_to(parent_categories_path, notice: 'Parent category was successfully deleted.')
    end
  
    private
  
    def parent_category_params
      params.require(:parent_category).permit(:parent_category, :icon, :color_code)
    end
  end
  