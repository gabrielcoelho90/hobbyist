class Subcommunity < ApplicationRecord
  belongs_to :community
  has_many :interests, as: :interestable, dependent: :destroy
  has_one :groupchat, as: :groupchatable, dependent: :destroy
end
