# frozen_string_literal: true

class GameActionsService
  def initialize(client)
    @client = client
    @browser = client.browser
  end

  def enter_world(world_name)
    raise ArgumentError, "World #{world_name} does not exist" unless @client.change_world(world_name)

    @client.login_to_world['result']
  end

  def building_config
    @browser.load_page 'building_info'
    sleep(1)
    @browser.extract[:config]
  end

  def player_info
    @client.player_info['result']
  end

  def players
    @browser.load_page 'player_list'
    sleep(5)
    @browser.extract[:players].map(&method(:players_mapping))
  end

  def tribes
    @browser.load_page 'tribe_list'
    sleep(5)
    @browser.extract[:tribes].map(&method(:tribes_mapping))
  end

  def unit_config
    @browser.load_page 'unit_info'
    sleep(1)
    @browser.extract[:config]
  end

  def villages
    @browser.load_page 'village_list'
    sleep(5)
    @browser.extract[:villages].map(&method(:villages_mapping))
  end

  def world_config
    @browser.load_page 'world_config'
    sleep(1)
    @browser.extract[:config]
  end

  def world_list_global
    @client.worlds_global
  end

  def login
    @client.login
  end

  private

  def villages_mapping(hash)
    remap_hash(hash, { id: :external_id, x: :x_coord, y: :y_coord, player_id: :owner })
  end

  def tribes_mapping(hash)
    remap_hash(
      hash.except(:member_count, :village_count, :points_top),
      { id: :external_id }
    )
  end

  def players_mapping(hash)
    remap_hash(hash, { id: :external_id })
  end

  def remap_hash(hash, mapping)
    hash.transform_keys do |key|
      mapping[key] || key
    end
  end
end
