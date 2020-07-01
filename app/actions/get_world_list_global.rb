class GetWorldListGlobal
  def initialize(client)
    @client = client
  end

  def execute
    @client.worlds_global
  rescue Exception => ex
    nil
  end
end