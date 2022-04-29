class Follow < ApplicationRecord
  # follower?
  belongs_to :followed_user, class_name: "User"
  # followee?
  belongs_to :following_user, class_name: "User"
end
