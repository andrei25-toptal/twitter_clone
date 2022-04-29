module Types
  class UserType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: false
    field :username, String, null: false
    field :bio, String, null: false
    field :email, String, null: false
  end
end