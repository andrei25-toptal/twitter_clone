RSpec.describe 'Api Likes', type: :request do

  let(:user1) { User.create(username: "alex1", bio: "test user1", password: "1234") }
  let(:tweet) { Tweet.create(user_id: user1.id, content: "the content of a tweet") }
  let(:token) { JsonWebToken.encode(user_id: user1.id )}


  describe 'index' do
    
    subject do
      get "/api/tweets/#{tweet.id}/likes", headers: { "Authorization" => "#{token}" }
      JSON.parse(response.body)
    end

    context 'when tweets exist' do
      let(:user2) { User.create(username: "alex2", bio: "test user2", password: "1234") }
      let!(:like) { Like.create(user_id: user2.id, tweet_id: tweet.id) }

      specify { expect(subject).to match([hash_including({"id" => like.id, "username" => user2.username})]) }
    end

    context 'when no tweets exist' do
      specify { is_expected.to eq([])}
    end
  end


  describe 'show' do
    
    context 'when like exists' do
      let(:user2) { User.create(username: "alex2", bio: "test user2", password: "1234") }
      let!(:like) { Like.create(user_id: user2.id, tweet_id: tweet.id) }

      subject do
        get "/api/tweets/#{tweet.id}/likes/#{user2.username}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to match(hash_including({"id" => like.id, "username" => user2.username})) }
    end

    context 'when like does not exists' do
      subject do
        get "/api/tweets/#{tweet.id}/likes/#{user1.username}", headers: { "Authorization" => "#{token}" }
      end
      
      specify { expect(subject).to eq( 200 ) }
    end

    context 'when user is not found' do
      subject do
        get "/api/tweets/#{tweet.id}/likes/aaaaa", headers: { "Authorization" => "#{token}" }
      end
      
      specify { expect(subject).to eq( 200 ) }
    end
  end

  describe 'create' do

    context 'when like exists' do
      let(:user2) { User.create(username: "alex2", bio: "test user2", password: "1234") }

      subject do
        post "/api/tweets/#{tweet.id}/likes/", params: {like: {user_id: user2.id} }, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end
      
      specify { expect { subject }.to change(Like, :count).by(1) }
    end

    context 'when like is not created successfully' do
      subject do
        post "/api/tweets/#{tweet.id}/likes/", params: {like: {user_id: nil} }, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end
      
      specify { is_expected.to have_key("error")}
    end
  end


  describe 'destroy' do

    context 'when like is destroyed successfully' do
      let(:user2) { User.create(username: "alex2", bio: "test user2", password: "1234") }
      let!(:like) { Like.create(user_id: user2.id, tweet_id: tweet.id) }

      subject do
        delete "/api/tweets/#{tweet.id}/likes/#{like.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect{subject}.to change(Like, :count).by(-1) }
    end

    context 'when like is destroyed because user is destroyed' do
      let(:user2) { User.create(username: "alex2", bio: "test user2", password: "1234") }
      let!(:like) { Like.create(user_id: user2.id, tweet_id: tweet.id) }

      subject do
        delete "/api/users/#{user2.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect{subject}.to change(Like, :count).by(-1) }
    end

    context 'when like is destroyed because tweet is destroyed' do
      let(:user2) { User.create(username: "alex2", bio: "test user2", password: "1234") }
      let!(:like) { Like.create(user_id: user2.id, tweet_id: tweet.id) }

      subject do
        delete "/api/tweets/#{tweet.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect{subject}.to change(Like, :count).by(-1) }
    end

    context 'when like is not found' do
      subject do
        delete "/api/tweets/#{tweet.id}/likes/aaaa", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"like not found") }
    end
  end

end