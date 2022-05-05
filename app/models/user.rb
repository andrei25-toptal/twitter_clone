class User < ApplicationRecord
  has_secure_password
  
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet
  
  has_many :followed_follows, dependent: :destroy, foreign_key: :following_user_id, class_name: "Follow"
  has_many :following_follows, dependent: :destroy, foreign_key: :followed_user_id, class_name: "Follow"

  has_many :followed_users, through: :followed_follows
  has_many :following_users, through: :following_follows

  validates :username, presence: true
  validates :bio, length: { minimum: 5, maximum: 50 }

  scope :users_who_like_tweet, ->(tweet_id) {where(id: Like.select(:user_id).where( tweet_id: tweet_id))}

  scope :user_by_username, ->(username) { where('username = ?', username).first }
end
