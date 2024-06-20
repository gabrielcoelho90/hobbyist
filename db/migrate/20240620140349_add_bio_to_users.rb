class AddBioToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :bio, :string
  end
end
