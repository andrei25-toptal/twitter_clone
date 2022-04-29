module Mutations
  class CreateTweet < GraphQL::Schema::Mutation
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :tweet, Types::TweetType, null: true

    # argument :content, String, required: true
    # argument :user_id, ID, required: true
    argument :tweet_input, Inputs::TweetInput, required: true

    def resolve(**args)
      # tweet = Tweet.new(args)
      tweet = Tweet.new(args[:tweet_input].to_h)
      success = tweet.save

      {
        success: success,
        errors: tweet.errors.full_messages,
        tweet: success ? tweet : nil
      }
    end
  end
end