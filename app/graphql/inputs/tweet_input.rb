module Inputs
  class TweetInput < GraphQL::Schema::InputObject
    argument :content, String, required: true
    argument :user_id, ID, required: true
  end
end