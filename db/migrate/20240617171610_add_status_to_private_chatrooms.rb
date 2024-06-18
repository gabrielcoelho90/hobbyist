class AddStatusToPrivateChatrooms < ActiveRecord::Migration[7.1]
  def change
    add_column :private_chatrooms, :status, :integer, default: 0
  end
end
