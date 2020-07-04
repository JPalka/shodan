# frozen_string_literal: true

class AddIndexToVillage < ActiveRecord::Migration[6.0]
  def change
    add_index :villages, %i[world_id external_id], unique: true
  end
end
