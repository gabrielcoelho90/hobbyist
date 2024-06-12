class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :messageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
