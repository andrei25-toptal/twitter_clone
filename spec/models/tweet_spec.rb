RSpec.describe Tweet do
  describe 'associations' do
    specify { is_expected.to belong_to(:user) }
    specify { is_expected.to have_many(:likes) }
    specify { is_expected.to have_many(:users_likes) }
  end

  describe 'scopes' do
    context '.tweets_of_user' do
      let(:user1) { User.create(username: "alex", bio: "test user", password: "1234") }
      let!(:tweet11) { Tweet.create(user_id: user1.id, content: "the content of a tweet 11") }
      let!(:tweet12) { Tweet.create(user_id: user1.id, content: "the content of a tweet 12") }
      let(:user2) { User.create(username: "alex", bio: "test user", password: "1234") }
      let!(:tweet2) { Tweet.create(user_id: user2.id, content: "the content of a tweet 2") }

      subject { Tweet.tweets_of_user(user1.id) }

      specify { is_expected.to contain_exactly(tweet11, tweet12)}
    end
  end
end