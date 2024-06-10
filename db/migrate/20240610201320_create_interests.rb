class CreateInterests < ActiveRecord::Migration[7.1]
  def change
    create_table :interests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interestable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
