module Types
  class TweetType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :content, String, null: false
    field :likes_count, Int, null: true
    field :user, Types::UserType, null: false

    field :users_likes, [Types::UserType], null: false
  end
end