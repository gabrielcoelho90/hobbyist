class Subcommunity < ApplicationRecord
  belongs_to :community
  has_many :interests, as: :interestable
end
