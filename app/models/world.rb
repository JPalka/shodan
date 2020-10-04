# frozen_string_literal: true

class World < ApplicationRecord
  belongs_to :master_server
  has_many :players
  has_many :villages
  has_many :tribes

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

  # :reek:FeatureEnvy :reek:DuplicateMethodCall
  def add_player(**params)
    players.where(external_id: params['player_id'].to_i)
           .first_or_create do |player|
             player.name = params['name']
             player.external_id = params['player_id'].to_i
             player.account = Account.find(params['account_id'])
           end
  end

  def player_count
    players.count
  end

  def village_count
    villages.count
  end

  def download_players
    client = Tribes::Client.new(master_server: master_server.link)
    client.change_world('', world_url: link)
    new_players = GetPlayers.new(client).execute
    return nil if new_players.nil?

    save_players(new_players.deep_dup)
  end

  def download_villages
    client = Tribes::Client.new(master_server: master_server.link)
    client.change_world('', world_url: link)
    new_villages = GetVillages.new(client).execute
    return nil if new_villages.nil?

    save_villages(new_villages.deep_dup)
  end

  def download_tribes
    client = Tribes::Client.new(master_server: master_server.link)
    client.change_world('', world_url: link)
    new_tribes = GetTribes.new(client).execute
    return nil if new_tribes.nil?

    save_tribes(new_tribes.deep_dup)
  end

  def save_tribes(new_tribes)
    new_tribes.each do |tribe|
      tribe[:world_id] = id
    end
    Tribe.import new_tribes, on_duplicate_key_update: {
      conflict_target: %i[world_id external_id], columns: %i[name tag points rank]
    }
    true
  end

  def save_players(new_players)
    tribes_hash = build_tribes_hash
    new_players.each do |player|
      player[:tribe_id] = tribes_hash[player.delete(:tribe_id)]
      player.delete(:village_count)
      player[:world_id] = id
    end
    Player.import new_players, on_duplicate_key_update: {
      conflict_target: %i[world_id external_id], colums: %i[name points rank tribe_id]
    }
    add_barbarian_player
    true
  end

  def save_villages(new_villages)
    players_hash = build_players_hash
    new_villages.map! do |village|
      village[:owner_id] = players_hash[village.delete(:owner)]
      village.delete(:rank)
      Village.new(village).tap { |vil| vil.world = self }
    end
    Village.import new_villages, on_duplicate_key_update: {
      conflict_target: %i[world_id external_id], columns: %i[owner_id points name]
    }
    true
  end

  private

  def build_players_hash
    players.each_with_object({}) do |player, hash|
      hash[player.external_id] = player.id
    end
  end

  def build_tribes_hash
    tribes.each_with_object({}) do |tribe, hash|
      hash[tribe.external_id] = tribe.id
    end
  end

  def add_barbarian_player
    return if players.find_by(external_id: 0)

    players.create!(name: 'Barbarian', external_id: 0, points: 0, rank: 0)
  end
end
