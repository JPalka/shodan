# frozen_string_literal: true

class GetPlayerInfo
  def initialize(client)
    @client = client
  end

  def execute
    @client.player_info['result']
  end
end
