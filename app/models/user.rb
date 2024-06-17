class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :interests, dependent: :destroy

  has_many :communities, through: :interests, source: :interestable, source_type: "Community"
  has_many :subcommunities, through: :interests, source: :interestable, source_type: "Subcommunity"

  has_many :messages, dependent: :destroy
  has_many :private_chatrooms_as_sender, class_name: "PrivateChatroom", foreign_key: :sender_id, dependent: :destroy
  has_many :private_chatrooms_as_receiver, class_name: "PrivateChatroom", foreign_key: :receiver_id, dependent: :destroy

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  has_one_attached :photo
end
