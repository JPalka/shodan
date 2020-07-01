class GetWorldListGlobal
  def initialize(client)
    @client = client
  end

  def execute
    @client.world_list_global
  rescue Exception => ex
    nil
  end
end