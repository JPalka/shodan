class GetPlayers
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'player_list'
    players = @client.browser.extract[:players]
    players.each do |player|
      player[:external_id] = player.delete(:id)
    end
    players
  rescue Exception => ex
    nil
  end
end