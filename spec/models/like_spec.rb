RSpec.describe Like do
  describe 'association' do
    specify { is_expected.to belong_to(:user) }
    specify { is_expected.to belong_to(:tweet) }
  end
end