require 'rails_helper'

RSpec.describe "Items", type: :request do
     describe "POST /create" do
          it "creates an item successfully" do
               post items_path, params: { item: { name: "Test Item", description: "Test description", price: 10 } }
               expect(response).to have_http_status(302)
          end
     end
end
