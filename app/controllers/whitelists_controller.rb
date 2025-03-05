class WhitelistsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_whitelist, only: [:show, :edit, :update, :destroy]
  
    def index
      @whitelists = Whitelist.all.order(:email)
    end
  
    def show
    end
  
    def new
      @whitelist = Whitelist.new
    end
  
    def create
      @whitelist = Whitelist.new(whitelist_params)
      if @whitelist.save
        redirect_to whitelists_path, notice: "Email added to whitelist."
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @whitelist.update(whitelist_params)
        redirect_to whitelists_path, notice: "Whitelist entry updated."
      else
        render :edit
      end
    end
  
    def destroy
      @whitelist.destroy
      redirect_to whitelists_path, notice: "Email removed from whitelist."
    end
  
    private
  
    def set_whitelist
      @whitelist = Whitelist.find(params[:id])
    end
  
    def whitelist_params
      params.require(:whitelist).permit(:email, :expires_at)
    end
  
    def authenticate_admin!
      redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
    end
  end
  