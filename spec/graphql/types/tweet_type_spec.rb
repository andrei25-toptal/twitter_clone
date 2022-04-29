RSpec.describe Types::TweetType do
  subject { TweetsSchema.execute(query, variables: variables) }

  # logger = Logger.new(STDOUT)
  # logger.debug("logger message")

  # debugger
  let(:query) { <<~GRAPHQL }
  query($id: ID!) {
    findTweet(id: $id) {
      id
      content
      user {
        username
      }
    }
  }
  GRAPHQL

  let(:variables) { {id: tweet.id} }

  let(:tweet) { Tweet.create(content: "abcdef", user_id: user.id) }
  let(:user) { User.create(username: "test_user", bio: "the bio of the user")}

specify do
  expect(subject).to eq(
    {
      "data" => {
        "findTweet" => {
          "id" => tweet.id.to_s,
          "content" => tweet.content,
          "user" => {
            "username" => user.username
          }
        }
      }
    }
  )
end

end