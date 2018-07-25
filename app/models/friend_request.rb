# == Schema Information
#
# Table name: friend_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  # User needs to be present
  validates :user, presence: true
  

  # Friend needs to be present and prevent repeats of the same row
  # f = FriendRequest.create(user_id: 2, friend_id: 3)
  #   commit transaction
  # f = FriendRequest.create(user_id: 2, friend_id: 3)
  #   rollback transaction
  # f.errors.full_messages
  #  => ["Friend has already been taken"]
  validates :friend, presence: true, uniqueness: { scope: :user }

  validate :not_self # Don't allow friend requests to yourself
  validate :not_friends # Don't allow friend requests if already friends
  validate :not_pending # Don't allow friend requests if already pending

  # Don't allow friend requests to yourself
  # f = FriendRequest.create(user_id: 1, friend_id: 1)
  # f.errors.full_messages
  #   => ["Friend can't be equal to user"]
  def not_self
  	if (user_id == friend_id)
  		errors.add(:friend, "can't be equal to user")
  	end
  end

  def not_friends
  	# TODO
  end

  # Don't allow friend requests if already pending
  # Can't send a request to a friend who has already requested you to be thier friend
  # f = FriendRequest.create(user_id: 3, friend_id: 4)
  #   commit transaction
  # f = FriendRequest.create(user_id: 4, friend_id: 3)
  #   rollback transaction
  # f.errors.full_messages
  #   => ["Friend already requested friendship"]
  # u4.incoming_friend_requests.include?(u3.friend_requests)
  def not_pending
    if user.incoming_friend_requests.pluck(:user_id).include?(friend_id)
      errors.add(:friend, 'already requested friendship')
    end
  end

  def outgoing

  end

  def incoming
  	
  end
end
