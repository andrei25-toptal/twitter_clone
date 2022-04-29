module Mutations
  class MutationType < GraphQL::Schema::Object
    field :create_tweet, mutation: Mutations::CreateTweet
    field :destroy_tweet, mutation: Mutations::DestroyTweet
    field :update_tweet, mutation: Mutations::UpdateTweet
  end
end