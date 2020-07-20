# frozen_string_literal: true

class GetWorldConfig
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'world_config'
    @client.browser.extract[:config]
  end
end
