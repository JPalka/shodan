# frozen_string_literal: true

class AddTribeToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_reference :players, :tribe, foreign_key: true
  end
end
