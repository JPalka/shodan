# frozen_string_literal: true

class Village < ApplicationRecord
  belongs_to :owner, class_name: 'Player'
  belongs_to :world

  validates :name, presence: true
  validates :points, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :external_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :external_id, uniqueness: { scope: :world_id }
  validates :x_coord, :y_coord, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :maximum_coordinates

  def maximum_coordinates
    return if world.nil? || world.world_config.nil?

    max_coord = world.world_config['coord']['map_size'].to_i
    errors.add(:x_coord, "must be less than or equal to #{max_coord}") if x_coord > max_coord
    errors.add(:y_coord, "must be less than or equal to #{max_coord}") if y_coord > max_coord
  end
end
