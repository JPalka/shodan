# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.integer :external_id
      t.string :name
      t.integer :points
      t.integer :rank
      t.references :world, null: false, foreign_key: true
      t.references :account, null: true, foreign_key: true

      t.timestamps
    end
  end
end
