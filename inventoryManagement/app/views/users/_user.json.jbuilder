json.extract! user, :id, :email, :name, :role, :department_id, :created_at, :updated_at
json.url user_url(user, format: :json)
