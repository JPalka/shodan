# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AI::Engine, type: :model do
  describe '#initialize' do
    it 'craps out when player does not exist' do
      account = create(:account)
      create(:player, account: account, id: 1)

      expect { AI::Engine.new('id', player_id: 9090) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#start' do
    it 'does not crap out when everything is ok. what a garbage test description' do
      account = create(:account)
      player = create(:player, account: account)
      engine = build(:engine, player: player)

      expect { engine.start }.not_to raise_error
    end
  end
end
