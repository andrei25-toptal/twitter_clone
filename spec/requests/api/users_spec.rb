RSpec.describe 'Api Users', type: :request do
  let(:user) { User.create(username: "abi1234", bio: "another user", password: "1234") }
  let(:token) { JsonWebToken.encode(user_id: user.id )}

  describe 'index' do
    subject do
      get '/api/users', headers: { "Authorization" => "#{token}" }
      JSON.parse(response.body)
    end

    context 'when has some users' do
      specify { expect(subject).to match([hash_including({"id" => user.id, "username" => "abi1234", "bio" => "another user"})]) }
    end

    context 'when no users exist' do
    #   specify { is_expected.to eq([])}
    end
  end

  describe 'show' do

    context 'when user exists' do
      subject do
        get "/api/users/#{user.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to match(hash_including({"id" => user.id, "username" => "abi1234", "bio" => "another user"})) }
    end

    context 'when user does not exists' do
      subject do
        get "/api/users/1000", headers: { "Authorization" => "#{token}" }
      end
      
      specify { expect(subject).to eq( 200 ) }
    end
  end

  describe 'create' do

    context 'when user is created successfully' do
      subject do
        post "/api/users", params: {user: {username: "abi12345", bio: "another user", password: "12345"} }, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end
      
      specify { expect { subject }.to change(User, :count).by(1) }
      # specify { expect(subject).to match(hash_including({"username" => "abi1234", "bio" => "another user"})) }
    end


    context 'when user is not created successfully' do
      subject do
        post "/api/users", params: {user: {username: "abi1234", bio: ""} }
        JSON.parse(response.body)
      end
      
      specify { is_expected.to have_key("error")}
    end
  end

  describe 'update' do

    context 'when user is updated successfully' do
      subject do
        patch "/api/users/#{user.id}", params: {user: {username: "abi123456789", bio: "another bio - edited", password: "1234qwerty"}}, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { is_expected.to match(hash_including({"username" => "abi123456789", "bio" => "another bio - edited"})) }
    end

    context 'when user is not updated successfully because it has wrong fields' do
      subject do
        patch "/api/users/#{user.id}", params: {user: {username: "abi123456789", bio: "a", password: "1234"}}, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { is_expected.to have_key("error")}
    end

    context 'when user is not updated successfully because it is not found' do
      subject do
        patch "/api/users/1000", params: {user: {username: "abi123456789", bio: "a", password: "1234"}}, headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"user not found") }
    end
  end

  describe 'destroy' do

    context 'when user is destroyed successfully' do
      let(:user2) { User.create(username: "abc", bio: "another user", password: "1234") }

      subject do
        delete "/api/users/#{user2.id}", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("message"=>"user destroyed") }
    end

    context 'when user is not found' do
      subject do
        delete "/api/users/1000", headers: { "Authorization" => "#{token}" }
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"user not found") }
    end
  end
end
