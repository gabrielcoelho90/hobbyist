class Community < ApplicationRecord
  has_many :subcommunities
  has_many :interests, as: :interestable
end
