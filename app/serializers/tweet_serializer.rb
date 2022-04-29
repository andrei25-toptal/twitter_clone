class TweetSerializer < ActiveModel::Serializer
  attributes :id, :content

  belongs_to :user
  has_many :likes

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
  end

  class LikeSerializer < ActiveModel::Serializer
    attributes :id
    # , :username
    
    # def username
    #   object.user.username
    # end
  end
end
