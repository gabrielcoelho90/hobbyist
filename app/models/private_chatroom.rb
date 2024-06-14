class PrivateChatroom < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, as: :messageable

  validates :sender, uniqueness: { scope: :receiver, message: "already has this Private Chatroom" }
  validates :receiver, uniqueness: { scope: :sender, message: "already has this Private Chatroom" }
  #validates :sender, comparison: { other_than: :sender, message: "cannot create chat with self" }
end
