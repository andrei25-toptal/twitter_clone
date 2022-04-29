module Mutations
  class DestroyTweet < GraphQL::Schema::Mutation
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :tweet, Types::TweetType, null: true

    argument :id, ID, required: true

    def resolve(**args)
      tweet = Tweet.find(args[:id])
      success = tweet.destroy

      {
        success: success,
        errors: tweet.errors.full_messages,
        tweet: success ? nil : tweet
      }
    end
  end
end