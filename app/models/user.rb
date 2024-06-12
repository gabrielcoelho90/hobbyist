class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :interests, dependent: :destroy
  has_many :communities, through: :interests, source: :interestable, source_type: "Community"
  has_many :subcommunities, through: :interests, source: :interestable, source_type: "Subcommunity"

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  # include PgSearch::Model
  # pg_search_scope :global_search,
  #   against: [:name],
  #   associated_against: {
  #     interests: [:hobby_id]
  #   },
  #   using: {
  #     tsearch: { prefix: true }
  #   }
end
