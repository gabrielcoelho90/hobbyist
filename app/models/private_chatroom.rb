class PrivateChatroom < ApplicationRecord
  enum status: { pending: 0, active: 1, archived: 2 }

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, as: :messageable

  validate :unique_chatroom_pair, on: :create

  validates :sender, comparison: { other_than: :receiver, message: "cannot create chat with self" }

  def self.find_chatroom(options = {})
    chat_arr = PrivateChatroom.where(sender: options[:user_one], receiver: options[:user_two]) |
               PrivateChatroom.where(sender: options[:user_two], receiver: options[:user_one])

    chat_arr.first
  end

  private

  def unique_chatroom_pair
    if PrivateChatroom.exists?(sender: sender, receiver: receiver) || PrivateChatroom.exists?(sender: receiver, receiver: sender)
      errors.add(:base, "Chatroom with these users already exists")
    end
  end
end
