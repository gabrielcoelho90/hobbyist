class CreateGroupchats < ActiveRecord::Migration[7.1]
  def change
    create_table :groupchats do |t|
      t.string :name
      t.references :groupchatable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
