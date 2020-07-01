class GetWorldListGlobal
  def initialize(client)
    @client = client
  end

  def execute
    @client.world_list_global
  rescue Exception => ex
    { error: 'Failed to download global world list' }
  end
end