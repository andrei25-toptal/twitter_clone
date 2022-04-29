class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :bio

  has_many :tweets 
  has_many :likes
  has_many :followed_users
  has_many :following_users

  # class TweetSerializer < ActiveModel::Serializer
  #   attributes :id, :content
  # end

  class LikeSerializer < ActiveModel::Serializer
    attributes :id
  end

  class TweetSerializer < ActiveModel::Serializer
    attributes :id, :content
  end
end
