class World < ApplicationRecord
  belongs_to :master_server
  serialize :world_config
  serialize :unit_config
  serialize :building_config

  validates :name, presence: true
  validates :link, presence: true
  validates :master_server, presence: true
end
