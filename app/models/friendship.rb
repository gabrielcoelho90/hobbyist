class Friendship < ApplicationRecord
  enum status: { pending: 0, active: 1, archived: 2 }

  belongs_to :asker, class_name: "User"
  belongs_to :receiver, class_name: "User"
end
