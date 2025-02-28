require 'rails_helper'

RSpec.describe "Users", type: :request do
     # Include Devise's integration helpers
     include Devise::Test::IntegrationHelpers

     # Create a department so that foreign key constraints pass.
     let!(:department) { Department.create!(dept_id: 'dept1', name: 'Department 1') }

     # Create an admin (or other user) so that authentication passes.
     let!(:admin) do
          Admin.create!(
               email: "admin@example.com",
               full_name: "Admin User",
               uid: "admin123",
               avatar_url: "http://example.com/avatar.png"
          )
     end

     # Sign in before each test.
     before do
          sign_in admin
     end

     let(:valid_attributes) do
          {
               email: "test@example.com",
               name: "Test User",
               role: "user",
               dept_id: department.dept_id,
               is_white_listed: false,
               white_list_end_date: Date.today + 30
          }
     end

     let(:invalid_attributes) do
          {
               email: nil, # email is required
               name: "",
               role: "",
               dept_id: nil,       # dept_id is required
               is_white_listed: false,
               white_list_end_date: nil
          }
     end

     describe "GET /users" do
          it "returns a success response" do
               User.create!(valid_attributes)
               get app_users_path
               expect(response).to be_successful
          end
     end

     describe "GET /users/:email" do
          it "returns a success response" do
               user = User.create!(valid_attributes)
               get app_users_path(user.email)
               expect(response).to be_successful
          end
     end

     describe "GET /users/new" do
          it "returns a success response" do
               get new_user_path
               expect(response).to be_successful
          end
     end

     describe "GET /users/:email/edit" do
          it "returns a success response" do
               user = User.create!(valid_attributes)
               get edit_user_path(user.email)
               expect(response).to be_successful
          end
     end

     describe "POST /users" do
          context "with valid parameters" do
               it "creates a new User" do
                    expect do
                         post app_users_path, params: { user: valid_attributes }
                    end.to change(User, :count).by(1)
               end

               it "redirects to the created user" do
                    post app_users_path, params: { user: valid_attributes }
                    expect(response).to redirect_to(user_path(valid_attributes[:email]))
               end
          end

          context "with invalid parameters" do
               it "does not create a new User" do
                    expect do
                         post app_users_path, params: { user: invalid_attributes }
                    end.not_to change(User, :count)
               end

               it "renders the new template with unprocessable_entity status" do
                    post app_users_path, params: { user: invalid_attributes }
                    expect(response).to have_http_status(:unprocessable_entity)
               end
          end
     end

     describe "PUT /users/:email" do
          context "with valid parameters" do
               let(:new_attributes) do
                    { name: "Updated Name" }
               end

               it "updates the requested user" do
                    user = User.create!(valid_attributes)
                    put user_path(user.email), params: { user: new_attributes }
                    user.reload
                    expect(user.name).to eq("Updated Name")
               end

               it "redirects to the user" do
                    user = User.create!(valid_attributes)
                    put user_path(user.email), params: { user: new_attributes }
                    expect(response).to redirect_to(user_path(user.email))
               end
          end

          context "with invalid parameters" do
               it "renders the edit template with unprocessable_entity status" do
                    user = User.create!(valid_attributes)
                    put user_path(user.email), params: { user: invalid_attributes }
                    expect(response).to have_http_status(:unprocessable_entity)
               end
          end
     end

     describe "DELETE /users/:email" do
          it "destroys the requested user" do
               user = User.create!(valid_attributes)
               expect do
                    delete user_path(user.email)
               end.to change(User, :count).by(-1)
          end

          it "redirects to the users list" do
               user = User.create!(valid_attributes)
               delete user_path(user.email)
               expect(response).to redirect_to(app_users_path)
          end
     end
end
