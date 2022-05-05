RSpec.describe 'Api Tweets', type: :request do
  let(:user) { User.create(username: "alex", bio: "test user", password: "1234") }
  let(:token) { JsonWebToken.encode(user_id: user.id )}

  describe 'index' do
    subject do
      get '/api/tweets', headers: { "Authorization" => "#{token}" }

      JSON.parse(response.body)
    end

    context 'when tweets exist' do
      # let(:user) { User.create(username: "alex", bio: "test user", password: "1234") }
      let!(:tweet) { Tweet.create(user_id: user.id, content: "the content of a tweet") }

      
      specify { expect(subject).to match([hash_including({"id" => tweet.id, "content" => "the content of a tweet"})]) }
    end

    context 'when no tweets exist' do
      specify { is_expected.to eq([]) }
    end
  end

  describe 'show' do
    context 'when tweet exists' do
      # let(:user) { User.create(username: "alex", bio: "test user", password: "1234") }
      let!(:tweet) { Tweet.create(user_id: user.id, content: "the content of a tweet") }
      # let (:token) { JsonWebToken.encode(user_id: user.id )}

      subject do
        get "/api/tweets/#{tweet.id}", headers: { "Authorization" => "#{token}" }

        JSON.parse(response.body)
      end

      specify { expect(subject).to match(hash_including({"id" => tweet.id, "content" => "the content of a tweet"})) }
    end

    context 'when tweet does not exists' do
      before do
        get "/api/tweets/1000", headers: { "Authorization" => "#{token}" }
      end
      
      specify { expect(response).to have_http_status(404) }
      # specify { expect(subject).to match([{}]) }
    end
  end

  describe 'create' do
    # let(:user) { User.create(username: "alex", bio: "test user") }

    context 'when tweet is created successfully' do
      subject do
        post "/api/tweets", params: {tweet: {user_id: user.id, content: "the content of a tweet"} }, headers: { "Authorization" => "#{token}" }

        JSON.parse(response.body)
      end
      
      specify { expect { subject }.to change(Tweet, :count).by(1) }
    end


    context 'when tweet is not created successfully' do
      subject do
        post "/api/tweets", params: {tweet: {content: "failing tweet"} }, headers: { "Authorization" => "#{token}" }

        JSON.parse(response.body)
      end
      
      specify { is_expected.to have_key("error")}
    end
  end


  describe 'update' do
    # let(:user) { User.create(username: "alex", bio: "test user") }
    let!(:tweet) { Tweet.create(user_id: user.id, content: "the content of a tweet") }

    context 'when tweet is updated successfully' do
      before do
        patch "/api/tweets/#{tweet.id}", params: { tweet: { user_id: user.id, content: "the content of a tweet - edited"} }, headers: { "Authorization" => "#{token}" }
      end

      subject do
        JSON.parse(response.body)
      end

      specify { is_expected.to match(hash_including({"content" => "the content of a tweet - edited"})) }
    end

    context 'when tweet is not updated successfully because it has wrong fields' do
      subject do
        patch "/api/tweets/#{tweet.id}", params: {tweet: {user_id: user.id, content: nil}}, headers: { "Authorization" => "#{token}" }

        JSON.parse(response.body)
      end

      specify { is_expected.to have_key("error")}
    end

    context 'when tweet is not updated successfully because it is not found' do
      subject do
        patch "/api/tweets/1000", params: {tweet: {user_id: user.id, content: "the content is good but tweet_id is not"}}, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"tweet not found") }
    end
  end

  describe 'destroy' do
    # let(:user) { User.create(username: "alex", bio: "test user") }
    let!(:tweet) { Tweet.create(user_id: user.id, content: "the content of a tweet") }

    context 'when tweet is destroyed successfully' do
      subject do
        delete "/api/tweets/#{tweet.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect{subject}.to change(Tweet, :count).by(-1) }
    end

    context 'when tweet is destroyed because user is destroyed' do
      subject do
        delete "/api/users/#{user.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect{subject}.to change(Tweet, :count).by(-1) }
    end

    context 'when tweet is not found' do
      subject do
        delete "/api/tweets/1000", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"tweet not found") }
    end
  end
end