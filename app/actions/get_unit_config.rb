# frozen_string_literal: true

class GetUnitConfig
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'unit_info'
    @client.browser.extract[:config]
  end
end
