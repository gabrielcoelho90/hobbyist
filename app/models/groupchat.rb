class Groupchat < ApplicationRecord
  belongs_to :groupchatable, polymorphic: true
  has_many :messages, as: :messageable
end
