class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :interestable, polymorphic: true

  validates :user_id, uniqueness: { scope: :interestable_id, message: "interests must be unique. This interest already exists." }
end
