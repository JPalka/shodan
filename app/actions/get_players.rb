# frozen_string_literal: true

class GetPlayers
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'player_list'
    sleep(5)
    players = @client.browser.extract[:players]
    players.each do |player|
      player[:external_id] = player.delete(:id)
    end
    players
  end
end
