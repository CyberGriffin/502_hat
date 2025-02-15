json.extract! user_inventory, :id, :owner_email, :user_email, :inventory_id, :created_at, :updated_at
json.url user_inventory_url(user_inventory, format: :json)
