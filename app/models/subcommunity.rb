class Subcommunity < ApplicationRecord
  belongs_to :community
  has_many :interests, as: :interestable
  include PgSearch::Model
  pg_search_scope :global_search,
    against: [:name],
    associated_against: {
      subcommunities: [:name]
    },
    using: {
      tsearch: { prefix: true }
    }
end
