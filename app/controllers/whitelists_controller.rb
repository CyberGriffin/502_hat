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

     def delete
          @whitelist = Whitelist.find(params[:id])
     end

     def destroy
          email_to_remove = @whitelist.email
          @whitelist.destroy
        
          # Log out the user if they are the one being removed
          if current_user&.email == email_to_remove
            sign_out current_user
            redirect_to new_user_session_path, alert: "You have been removed from the whitelist and logged out."
          else
            respond_to do |format|
              format.html { redirect_to whitelists_path, notice: "Email removed from whitelist." }
              format.json { head :no_content }
            end
          end
        end
        
        def update
          previous_email = @whitelist.email
          respond_to do |format|
            if @whitelist.update(whitelist_params)
              # Log out the user if their email was changed and they are no longer whitelisted
              if current_user&.email == previous_email && Whitelist.find_by(email: current_user.email).nil?
                sign_out current_user
                redirect_to new_user_session_path, alert: "You have been removed from the whitelist and logged out."
                return
              end
        
              format.html { redirect_to whitelists_path, notice: "Whitelist entry updated." }
              format.json { render :show, status: :ok, location: @whitelist }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @whitelist.errors, status: :unprocessable_entity }
            end
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
          whitelist_entry = Whitelist.find_by(email: current_user&.email)
          puts "Current user email: #{current_user&.email}"
          puts "Whitelist entry found: #{whitelist_entry.inspect}"
          
          redirect_to root_path, alert: "Not authorized" unless whitelist_entry&.roles == 'admin'
     end
end
