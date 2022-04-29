module Types
  class QueryType < GraphQL::Schema::Object

    field :tweets, [Types::TweetType], null: false
    field :first_tweet, Types::TweetType, null: false
    field :users, [Types::UserType], null: false
    field :first_user, Types::UserType, null: false
    field :find_tweet, Types::TweetType, null: false do
      argument :id, ID, required: true
    end

    def tweets
      Tweet.all
    end

    def first_tweet
      Tweet.first
    end

    def find_tweet(**args)
      Tweet.find(args[:id])
    end

    def first_user
      User.first
    end

    def users
      User.all
    end
  end
end