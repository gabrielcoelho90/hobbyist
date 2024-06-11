class CreatePrivateChatrooms < ActiveRecord::Migration[7.1]
  def change
    create_table :private_chatrooms do |t|
      t.string :name
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
