class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true
  # belongs_to :private_chatroom
  belongs_to :user
end
