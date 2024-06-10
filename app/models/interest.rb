class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :interestable, polymorphic: true
end
