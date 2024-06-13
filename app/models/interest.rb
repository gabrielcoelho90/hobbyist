class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :interestable, polymorphic: true

  validates :user, uniqueness: { scope: :interestable, message: "interests must be unique. This interest already exists." }

  include PgSearch::Model
  pg_search_scope :global_search,
    against: [:interestable],
    associated_against: {
      subcommunities: [:name]
    },
    using: {
      tsearch: { prefix: true }
    }
end
