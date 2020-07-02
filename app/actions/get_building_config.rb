class GetBuildingConfig
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'building_info'
    @client.browser.extract[:config]
  rescue Exception => ex
    nil
  end
end