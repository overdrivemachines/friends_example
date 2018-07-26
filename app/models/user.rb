# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
	has_many :friend_requests, dependent: :destroy #outgoing friend requests
	has_many :incoming_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id"
	
end
