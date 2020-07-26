# frozen_string_literal: true

class EnterWorld
  def initialize(client)
    @client = client
  end

  def execute(world_name)
    raise ArgumentError, "World #{world_name} does not exist" unless @client.change_world(world_name)

    @client.login_to_world['result']
  end
end
