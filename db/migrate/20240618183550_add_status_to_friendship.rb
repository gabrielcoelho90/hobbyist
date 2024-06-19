class AddStatusToFriendship < ActiveRecord::Migration[7.1]
  def change
    add_column :friendships, :status, :integer, default: 0
  end
end
