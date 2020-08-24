# frozen_string_literal: true

class CreateVillages < ActiveRecord::Migration[6.0]
  def change
    create_table :villages do |t|
      t.integer :external_id, null: false
      t.integer :x_coord
      t.integer :y_coord
      t.references :owner, null: false, foreign_key: { to_table: :players }
      t.references :world, null: false, foreign_key: true
      t.integer :points
      t.string :name, null: false

      t.timestamps
    end
  end
end
