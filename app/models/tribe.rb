# frozen_string_literal: true

class Tribe < ApplicationRecord
  belongs_to :world

  has_many :players

  validates :name, presence: true
  validates :points, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :rank, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :world, presence: true
  validates :external_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :external_id, uniqueness: { scope: :world_id }
end
