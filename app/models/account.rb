# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :master_server
  has_and_belongs_to_many :active_worlds, class_name: 'World'

  validates :login, presence: true, length: { minimum: 4 }
  validates :password, presence: true, tribalwars_password: true
  validates :email, presence: true
  validates :master_server, presence: true
  validates :premium_points, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }

  validate :active_worlds_belong_to_same_server

  def active_worlds_belong_to_same_server
    active_worlds.each do |world|
      if master_server.id != world.master_server.id
        errors.add(:active_worlds, 'World must belong to the same server as account')
      end
    end
  end
end
