class World < ApplicationRecord
  belongs_to :master_server
  serialize :world_config
  serialize :unit_config
  serialize :building_config

  validates :name, presence: true
  validates :link, presence: true
  validates :master_server, presence: true

  def initialize_configs
    client = Tribes::Client.new(master_server: master_server.link)
    client.change_world('', world_url: link)
    config = GetWorldConfig.new(client).execute
    self.world_config = config if config

    unit = GetUnitConfig.new(client).execute
    self.unit_config = unit if unit

    building = GetBuildingConfig.new(client).execute
    self.building_config = building if building
    save!
    self
  end
end
