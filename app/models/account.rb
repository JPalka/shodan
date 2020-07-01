class Account < ApplicationRecord
  belongs_to :master_server

  validates :login, presence: true, length: { minimum: 4 }
  validates :password, presence: true, tribalwars_password: true
  validates :email, presence: true
  validates :master_server, presence: true
  validates :premium_points, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
end
