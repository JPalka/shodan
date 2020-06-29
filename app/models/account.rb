class Account < ApplicationRecord
  belongs_to :master_server

  validates :login, presence: true
  validates :password, presence: true
end
