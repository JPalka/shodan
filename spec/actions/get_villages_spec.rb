# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetVillages do
  let(:client) { double }
  let(:browser) { double }
  let(:subject) { described_class.new(client) }
  let(:village_list) do
    { villages: [{ id: 1,
                   name: 'Sammie+C.',
                   x: 496,
                   y: 524,
                   player_id: 8_061_098,
                   points: 3096,
                   rank: 0 },
                 { id: 2,
                   name: 'Mayham',
                   x: 495,
                   y: 528,
                   player_id: 8_049_221,
                   points: 10_019,
                   rank: 0 },
                 { id: 3,
                   name: 'Barbarian+village',
                   x: 515,
                   y: 483,
                   player_id: 0,
                   points: 1514,
                   rank: 0 }] }
  end
  let(:village_list_final) do
    [{ external_id: 1,
       name: 'Sammie+C.',
       x_coord: 496,
       y_coord: 524,
       owner: 8_061_098,
       points: 3096,
       rank: 0 },
     { external_id: 2,
       name: 'Mayham',
       x_coord: 495,
       y_coord: 528,
       owner: 8_049_221,
       points: 10_019,
       rank: 0 },
     { external_id: 3,
       name: 'Barbarian+village',
       x_coord: 515,
       y_coord: 483,
       owner: 0,
       points: 1514,
       rank: 0 }]
  end

  describe '#execute' do
    context 'command succeeds' do
      before do
        allow(client).to receive(:browser).and_return(browser)
        allow(browser).to receive(:load_page)
        allow(browser).to receive(:extract).and_return(village_list)
      end

      it { expect(subject.execute).to eq(village_list_final) }
    end

    context 'command fails' do
      before { allow(client).to receive(:browser).and_raise(Exception) }

      it { expect(subject.execute).to eq(nil) }
    end
  end
end
