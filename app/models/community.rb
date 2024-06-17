class Community < ApplicationRecord
  has_many :subcommunities, dependent: :destroy
  has_many :interests, as: :interestable
  has_one :groupchat, as: :groupchatable
end
