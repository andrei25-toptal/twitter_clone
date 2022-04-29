module Mutations
  class UpdateTweet < GraphQL::Schema::Mutation
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :tweet, Types::TweetType, null: true

    argument :id, ID, required: true
    argument :tweet_input, Inputs::TweetInput, required: true

    def resolve(**args)
      tweet = Tweet.find(args[:id])
      success = tweet.update(args[:tweet_input].to_h)

      {
        success: success,
        errors: tweet.errors.full_messages,
        tweet: success ? tweet : nil
      }
    end
  end
end