class Community < ApplicationRecord
  has_many :subcommunities
  has_many :interests, as: :interestable

  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [:name],
    using: {
      tsearch: { prefix: true }
    }
end
