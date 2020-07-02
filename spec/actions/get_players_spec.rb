# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetPlayers do
  let(:client) { double }
  let(:browser) { double }
  let(:subject) { described_class.new(client) }
  let(:player_list) do
    { players: [{ name: 'wannat8',
                  id: 110_622,
                  tribe_id: 0,
                  village_count: 1,
                  points: 68,
                  rank: 420 },
                { name: 'calaca',
                  id: 173_973,
                  tribe_id: 0,
                  village_count: 1,
                  points: 540,
                  rank: 210 }] }
  end
  let(:player_list_final) do
    [{ name: 'wannat8',
      external_id: 110_622,
      tribe_id: 0,
      village_count: 1,
      points: 68,
      rank: 420 },
    { name: 'calaca',
      external_id: 173_973,
      tribe_id: 0,
      village_count: 1,
      points: 540,
      rank: 210 }]
  end

  describe '#execute' do
    context 'command succeeds' do
      before do
        allow(client).to receive(:browser).and_return(browser)
        allow(browser).to receive(:load_page)
        allow(browser).to receive(:extract).and_return(player_list)
      end

      it { expect(subject.execute).to eq(player_list_final) }
    end

    context 'command fails' do
      before { allow(client).to receive(:browser).and_raise(Exception) }

      it { expect(subject.execute).to eq(nil) }
    end
  end
end
