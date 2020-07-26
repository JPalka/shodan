# frozen_string_literal: true

class GetBuildingConfig
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'building_info'
    sleep(1)
    @client.browser.extract[:config]
  end
end
