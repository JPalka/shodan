# frozen_string_literal: true

class GetTribes
  def initialize(client)
    @client = client
  end

  def execute
    @client.browser.load_page 'tribe_list'
    sleep(3)
    tribes = @client.browser.extract[:tribes]
    tribes.each do |tribe|
      tribe.except!(:member_count, :village_count, :points_top)
      tribe[:external_id] = tribe.delete(:id)
    end
    tribes
  rescue Exception => e
    nil
  end
end
