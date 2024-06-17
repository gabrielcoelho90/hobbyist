class Community < ApplicationRecord
  has_many :subcommunities, dependent: :destroy
  has_many :interests, as: :interestable, dependent: :destroy
  has_one :groupchat, as: :groupchatable, dependent: :destroy
end
