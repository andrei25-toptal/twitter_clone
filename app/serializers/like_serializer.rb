class LikeSerializer < ActiveModel::Serializer
  attributes :id, :username

  def username
    object.user.username
  end

  # belongs_to :user
  # belongs_to :tweet

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
  end

  class TweetSerializer < ActiveModel::Serializer
    attributes :id, :content
  end
end
