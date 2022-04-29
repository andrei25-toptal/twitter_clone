json.extract! user, :id, :name, :username, :bio, :email, :created_at, :updated_at
json.url user_url(user, format: :json)
