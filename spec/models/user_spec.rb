RSpec.describe User do
  describe 'associations' do
    specify { is_expected.to have_many(:tweets) }
    specify { is_expected.to have_many(:likes) }
    specify { is_expected.to have_many(:liked_tweets) }
    specify { is_expected.to have_many(:followed_users) }
    specify { is_expected.to have_many(:following_users) }
  end

  describe 'validations' do
    specify { is_expected.to validate_presence_of(:username)}
    specify { is_expected.to validate_length_of(:bio).is_at_least(5)}
    specify { is_expected.to validate_length_of(:bio).is_at_most(50)}
  end
end