# frozen_string_literal: true

require 'rails_helper'

RSpec.describe World, type: :model do
  it { is_expected.to belong_to(:master_server) }
  it { is_expected.to have_many(:players) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:master_server) }
  it { is_expected.to validate_presence_of(:link) }

  it { is_expected.to serialize(:world_config) }
  it { is_expected.to serialize(:unit_config) }
  it { is_expected.to serialize(:building_config) }

  describe '#initialize_configs' do
    let(:client) { double }
    let(:config_action) { double }
    let(:unit_action) { double }
    let(:building_action) { double }

    before do
      allow(Tribes::Client).to receive(:new).and_return(client)
      allow(client).to receive(:change_world)
      allow(GetWorldConfig).to receive(:new).and_return(config_action)
      allow(GetUnitConfig).to receive(:new).and_return(unit_action)
      allow(GetBuildingConfig).to receive(:new).and_return(building_action)
      allow(config_action).to receive(:execute).and_return(
        {
          'xmlns' => '',
          'speed' => '3.5',
          'unit_speed' => '0.57',
          'moral' => '0',
          'build' => { 'destroy' => '1' },
          'misc' => { 'kill_ranking' => '2', 'tutorial' => '0', 'trade_cancel_time' => '300' },
          'commands' => { 'millis_arrival' => '1', 'command_cancel_time' => '600' }
        }
      )
      allow(unit_action).to receive(:execute).and_return(
        { 'xmlns' => '',
          'spear' =>
           { 'build_time' => '291.4285714',
             'pop' => '1',
             'speed' => '9.0225563920629',
             'attack' => '10',
             'defense' => '15',
             'defense_cavalry' => '45',
             'defense_archer' => '20',
             'carry' => '25' },
          'sword' =>
           { 'build_time' => '428.5714286',
             'pop' => '1',
             'speed' => '11.027568924959',
             'attack' => '25',
             'defense' => '50',
             'defense_cavalry' => '25',
             'defense_archer' => '40',
             'carry' => '15' } }
      )
      allow(building_action).to receive(:execute).and_return(
        { 'xmlns' => '',
          'main' =>
           { 'max_level' => '30',
             'min_level' => '1',
             'wood' => '90',
             'stone' => '80',
             'iron' => '70',
             'pop' => '5',
             'wood_factor' => '1.26',
             'stone_factor' => '1.275',
             'iron_factor' => '1.26',
             'pop_factor' => '1.17',
             'build_time' => '257.1428571',
             'build_time_factor' => '1.2' },
          'barracks' =>
           { 'max_level' => '25',
             'min_level' => '0',
             'wood' => '200',
             'stone' => '170',
             'iron' => '90',
             'pop' => '7',
             'wood_factor' => '1.26',
             'stone_factor' => '1.28',
             'iron_factor' => '1.26',
             'pop_factor' => '1.17',
             'build_time' => '514.2857143',
             'build_time_factor' => '1.2' } }
      )
    end

    context 'world url is valid' do
      let(:subject) { create(:world) }

      before { subject.initialize_configs }

      it 'sets world config' do
        expect(subject.world_config).to eq(config_action.execute)
      end
      it 'sets unit config' do
        expect(subject.unit_config).to eq(unit_action.execute)
      end
      it 'sets building config' do
        expect(subject.building_config).to eq(building_action.execute)
      end
    end
  end

  describe '#download_players' do
    let(:client) { double }
    let(:players_action) { double }
    let(:players) do
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

    before do
      allow(Tribes::Client).to receive(:new).and_return(client)
      allow(client).to receive(:change_world)
      allow(GetPlayers).to receive(:new).and_return(players_action)
      allow(players_action).to receive(:execute).and_return(players)
    end

    let(:subject) { create(:world) }

    before { subject.download_players }

    context 'no previous players exist' do
      it { expect(subject.players.count).to eq(2) }
      it { expect(subject.players.first.external_id).to eq(110_622) }
      it { expect(subject.players.first.world_id).to eq(subject.id) }
    end

    context 'players already exist' do
      before { subject.download_players }

      context 'with no changes' do
        it { expect(subject.players.count).to eq(2) }
        it { expect(subject.players.first.external_id).to eq(110_622) }
        it { expect(subject.players.first.world_id).to eq(subject.id) }
      end

      context 'player list is different' do
        let(:players) do
          [{ name: 'wannat8',
             external_id: 110_622,
             tribe_id: 0,
             village_count: 1,
             points: 500,
             rank: 420 },
           { name: 'calaca',
             external_id: 173_973,
             tribe_id: 0,
             village_count: 1,
             points: 540,
             rank: 300 }]
        end

        it { expect(subject.players.first.points).to eq(500) }
        it { expect(subject.players.last.rank).to eq(300) }
      end
    end
  end
end
