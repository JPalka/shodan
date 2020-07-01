class MasterServer < ApplicationRecord
  has_many :accounts
  has_many :worlds

  validates :link, presence: true
end
