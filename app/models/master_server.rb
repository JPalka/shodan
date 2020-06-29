class MasterServer < ApplicationRecord
  has_many :accounts

  validates_presence_of :link
end
