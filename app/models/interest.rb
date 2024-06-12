class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :interestable, polymorphic: true

  validates :user, uniqueness: { scope: :interestable, message: "interests must be unique. This interest already exists." }
end
