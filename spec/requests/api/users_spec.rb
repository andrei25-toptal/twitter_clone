RSpec.describe 'Api Users', type: :request do
  describe 'index' do
    subject do
      get '/api/users'
      JSON.parse(response.body)
    end

    context 'when has some users' do
      let!(:user) { User.create(username: "abi1234", bio: "another user") }

      specify { expect(subject).to match([hash_including({"id" => user.id, "username" => "abi1234", "bio" => "another user"})]) }
    end

    context 'when no users exist' do
      specify { is_expected.to eq([])}
    end
  end

  describe 'show' do

    context 'when user exists' do
      let!(:user) { User.create(username: "abi1234", bio: "another user") }
      subject do
        get "/api/users/#{user.id}"
        JSON.parse(response.body)
      end

      specify { expect(subject).to match(hash_including({"id" => user.id, "username" => "abi1234", "bio" => "another user"})) }
    end

    context 'when user does not exists' do
      subject do
        get "/api/users/1000"
      end
      
      specify { expect(subject).to eq( 200 ) }
      # specify do
      #   expect { get "/api/users/1000" }.to raise_error(ActiveRecord::RecordNotFound) 
      # end
    end
  end

  describe 'create' do

    context 'when user is created successfully' do
      subject do
        post "/api/users", params: {user: {username: "abi1234", bio: "another user"} }
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
    let!(:user) { User.create(username: "abi1234", bio: "another user") }

    context 'when user is updated successfully' do
      subject do
        patch "/api/users/#{user.id}", params: {user: {username: "abi123456789", bio: "another bio - edited"}}
        JSON.parse(response.body)
      end

      specify { is_expected.to match(hash_including({"username" => "abi123456789", "bio" => "another bio - edited"})) }
    end

    context 'when user is not updated successfully because it has wrong fields' do
      subject do
        patch "/api/users/#{user.id}", params: {user: {username: "abi123456789", bio: "a"}}
        JSON.parse(response.body)
      end

      specify { is_expected.to have_key("error")}
    end

    context 'when user is not updated successfully because it is not found' do
      subject do
        patch "/api/users/1000", params: {user: {username: "abi123456789", bio: "a"}}
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"user not found") }
    end
  end

  describe 'destroy' do
    let!(:user) { User.create(username: "abi1234", bio: "another user") }

    context 'when user is destroyed successfully' do
      subject do
        delete "/api/users/#{user.id}"
        JSON.parse(response.body)
      end

      specify { expect{subject}.to change(User, :count).by(-1) }
    end

    context 'when user is not found' do
      subject do
        delete "/api/users/1000"
        JSON.parse(response.body)
      end

      specify { expect(subject).to include("error"=>"user not found") }
    end
  end
end
