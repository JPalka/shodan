class CreateTribes < ActiveRecord::Migration[6.0]
  def change
    create_table :tribes do |t|
      t.integer :external_id
      t.references :world, null: false, foreign_key: true
      t.string :name
      t.string :tag
      t.integer :points
      t.integer :rank

      t.timestamps
    end
    add_index :tribes, %i[world_id external_id], unique: true
  end
end
