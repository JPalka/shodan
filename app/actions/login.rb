# frozen_string_literal: true

class Login
  def initialize(client)
    @client = client
  end

  def execute
    @client.login
  end
end
