class Friendship < ApplicationRecord
  enum status: { pending: 0, active: 1, archived: 2 }

  belongs_to :asker, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validate :unique_friend_pair, on: :create

  validates :asker, comparison: { other_than: :receiver, message: "cannot create friendship with self" }

  def self.find_friendship(options = {})
    friendship_arr = Friendship.where(asker: options[:lookup_asker], receiver: options[:lookup_receiver]) |
                     Friendship.where(asker: options[:lookup_receiver], receiver: options[:lookup_asker])

    friendship_arr.first
  end

  private

  def unique_friend_pair
    if Friendship.exists?(asker: asker, receiver: receiver) || Friendship.exists?(asker: receiver, receiver: asker)
      errors.add(:base, "Friendship between these users already exists")
    end
  end
end
