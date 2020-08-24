# frozen_string_literal: true

class CreateWorlds < ActiveRecord::Migration[6.0]
  def change
    create_table :worlds do |t|
      t.string :name, null: false
      t.string :link, null: false
      t.text :world_config
      t.text :unit_config
      t.text :building_config
      t.references :master_server, null: false, foreign_key: true

      t.timestamps
    end
  end
end
