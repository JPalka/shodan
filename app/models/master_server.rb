class MasterServer < ApplicationRecord
  has_many :accounts
  has_many :worlds

  validates :link, presence: true

  def download_world_list
    client = Tribes::Client.new(master_server: link)
    action = GetWorldListGlobal.new(client)
    new_worlds = action.execute
    new_worlds.each do |key, value|
      next if worlds.find_by(name: key)

      worlds.create!(name: key, link: value)
    end
  end
end
