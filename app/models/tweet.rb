class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :users_likes, through: :likes, source: :user

  validates :content, presence: :true

  scope :tweets_of_user, ->(user_id) {where(user_id: user_id)}
  scope :have_min_likes, ->(nr_likes) {where(id: Like.select(:tweet_id).group(:tweet_id).having('count(*) > ?', nr_likes))}

  scope :ordered_by_created_at, -> {order(created_at: :asc)} 
  scope :ordered_by_updated_at, -> {order(updated_at: :asc)}
  scope :ordered_by_likes, -> {order(likes_count: :asc)}
  scope :ordered_by_usernames, -> {joins(:user).order('users.username')}
end
