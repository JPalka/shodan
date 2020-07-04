# frozen_string_literal: true

class AddIndexToPlayer < ActiveRecord::Migration[6.0]
  def change
    add_index :players, %i[world_id external_id], unique: true
  end
end
