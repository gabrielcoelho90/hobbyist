class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :interests, dependent: :destroy
  has_many :communities, through: :interests, source: :interestable, source_type: "Community"
  has_many :subcommunities, through: :interests, source: :interestable, source_type: "Subcommunity"
  has_many :messages_as_sender, class_name: "Message", foreign_key: :sender_id
  has_many :messages_as_receiver, class_name: "Message", foreign_key: :receiver_id
  has_many :groupchats, through: :communities, source: :interestable, source_type: "Groupchat"
  has_many :private_chatrooms_as_sender, class_name: "PrivateChatroom", foreign_key: :sender_id, dependent: :destroy
  has_many :private_chatrooms_as_receiver, class_name: "PrivateChatroom", foreign_key: :receiver_id, dependent: :destroy

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
