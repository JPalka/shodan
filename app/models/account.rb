class Account < ApplicationRecord
  belongs_to :master_server

  validates_presence_of :login, :password
end
