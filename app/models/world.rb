class World < ApplicationRecord
  belongs_to :master_server
  has_many :players

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

  def download_players
    client = Tribes::Client.new(master_server: master_server.link)
    client.change_world('', world_url: link)
    new_players = GetPlayers.new(client).execute
    return nil if players.nil?

    new_players.each do |player|
      player.delete(:tribe_id)
      player.delete(:village_count)
      old = players.find_by(external_id: player[:external_id])
      if old
        players.update(old.id, player)
      else
        players.create!(player)
      end
    end
    self
  end
end
