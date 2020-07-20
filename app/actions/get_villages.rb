# frozen_string_literal: true

class GetVillages
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'village_list'
    sleep(5)
    villages = @client.browser.extract[:villages]
    villages.each do |village|
      village[:external_id] = village.delete(:id)
      village[:x_coord] = village.delete(:x)
      village[:y_coord] = village.delete(:y)
      village[:owner] = village.delete(:player_id)
    end
    villages
  end
end
