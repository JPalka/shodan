class MasterServer < ApplicationRecord
  has_many :accounts

  validates :link, presence: true
end
