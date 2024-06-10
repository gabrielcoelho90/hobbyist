class CreateSubcommunities < ActiveRecord::Migration[7.1]
  def change
    create_table :subcommunities do |t|
      t.string :name
      t.references :community, null: false, foreign_key: true

      t.timestamps
    end
  end
end
