class WhitelistsController < ApplicationController
     before_action :authenticate_admin!
     before_action :set_whitelist, only: [:show, :edit, :update, :destroy]

     def index
          @whitelists = Whitelist.all.order(:email)
     end

     def show; end

     def new
          @whitelist = Whitelist.new
     end

     def create
          @whitelist = Whitelist.new(whitelist_params)

          respond_to do |format|
               if @whitelist.save
                    format.html { redirect_to whitelists_path, notice: "Email added to whitelist." }
                    format.json { render :show, status: :created, location: @whitelist }
               else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @whitelist.errors, status: :unprocessable_entity }
               end
          end
     end

     def edit; end

     def update
          respond_to do |format|
               if @whitelist.update(whitelist_params)
                    format.html { redirect_to whitelists_path, notice: "Whitelist entry updated." }
                    format.json { render :show, status: :ok, location: @whitelist }
               else
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @whitelist.errors, status: :unprocessable_entity }
               end
          end
     end

     def delete
          @whitelist = Whitelist.find(params[:id])
     end

     def destroy
          @whitelist.destroy
          respond_to do |format|
               format.html { redirect_to whitelists_path, notice: "Email removed from whitelist." }
               format.json { head :no_content }
          end
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
