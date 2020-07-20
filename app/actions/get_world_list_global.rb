# frozen_string_literal: true

class GetWorldListGlobal
  def initialize(client)
    @client = client
  end

  def execute
    @client.worlds_global
  end
end
