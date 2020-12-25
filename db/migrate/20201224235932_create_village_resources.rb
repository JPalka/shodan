class CreateVillageResources < ActiveRecord::Migration[6.0]
  def change
    create_table :village_resources do |t|
      t.integer :wood
      t.integer :stone
      t.integer :iron
      t.float   :wood_prod
      t.float   :stone_prod
      t.float   :iron_prod
      t.integer :max_storage
      t.integer :pop
      t.integer :max_pop
      t.timestamps

      t.references :village, null: false, foreign_key: true
    end
  end
end
