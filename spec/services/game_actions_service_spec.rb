# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameActionsService do
  describe '#enter_world' do
    context 'world exists on remote' do
      it 'enters the world' do
        expected_response = eval(file_fixture('world_login.hash').read)

        client = double
        allow(client).to receive(:browser)
        allow(client).to receive(:change_world).and_return(true)
        allow(client).to receive(:login_to_world).and_return(expected_response)
        allow(client).to receive(:villages)
        service = GameActionsService.new(client)

        expect(service.enter_world('en115')).to eq(expected_response['result'])
      end
    end

    context 'world does not exist' do
      it 'fails' do
        expected_response = eval(file_fixture('world_login.hash').read)
        client = double
        allow(client).to receive(:browser)
        allow(client).to receive(:change_world).and_return(false)
        allow(client).to receive(:login_to_world).and_return(expected_response)
        service = GameActionsService.new(client)

        expect { service.enter_world('bogusyolo') }.to raise_error(ArgumentError)
        expect(client).not_to receive(:login_to_world)
      end
    end
  end

  describe '#world_config' do
    it 'returns world configuration' do
      expected_response = eval(file_fixture('world_config.hash').read)
      client = double
      browser = double
      allow(client).to receive(:browser).and_return(browser)
      allow(browser).to receive_message_chain(:load_page).with('world_config')
      allow(browser).to receive(:extract).and_return(expected_response)
      service = GameActionsService.new(client)

      expect(service.world_config).to eq(expected_response[:config])
    end
  end

  describe '#unit_config' do
    it 'returns units configuration' do
      expected_response = eval(file_fixture('unit_config.hash').read)
      client = double
      browser = double
      allow(client).to receive(:browser).and_return(browser)
      allow(browser).to receive_message_chain(:load_page).with('unit_info')
      allow(browser).to receive(:extract).and_return(expected_response)
      service = GameActionsService.new(client)

      expect(service.unit_config).to eq(expected_response[:config])
    end
  end

  describe '#building_config' do
    it 'returns building config' do
      expected_response = eval(file_fixture('building_config.hash').read)
      client = double
      browser = double
      allow(client).to receive(:browser).and_return(browser)
      allow(browser).to receive_message_chain(:load_page).with('building_info')
      allow(browser).to receive(:extract).and_return(expected_response)
      service = GameActionsService.new(client)

      expect(service.building_config).to eq(expected_response[:config])
    end
  end

  describe '#player_info' do
    it 'returns player info' do
      client = double
      browser = double
      allow(client).to receive(:player_info).and_return(
        { 'result' => { 'name' => 'Korenchkin', 'player_id' => '11524178' } }
      )
      allow(client).to receive(:browser).and_return(browser)
      expected_response = { 'name' => 'Korenchkin', 'player_id' => '11524178' }
      service = GameActionsService.new(client)

      expect(service.player_info).to eq(expected_response)
    end
  end

  describe '#players' do
    it 'returns players list' do
      client = double
      browser = double
      allow(browser).to receive(:load_page).with('player_list')
      allow(browser).to receive(:extract).and_return(
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
      )
      expected_response = [{ name: 'wannat8',
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
      allow(client).to receive(:browser).and_return(browser)
      service = GameActionsService.new(client)

      expect(service.players).to eq(expected_response)
    end
  end

  describe '#tribes' do
    it 'returns tribes list' do
      browser = double
      client = double
      allow(browser).to receive(:load_page).with('tribe_list')
      allow(browser).to receive(:extract).and_return(
        { tribes: [{ id: 1,
                     name: 'Old+Skool',
                     tag: '.OS.',
                     member_count: 16,
                     village_count: 80,
                     points_top: 428_719,
                     points: 428_719,
                     rank: 33 },
                   { id: 2,
                     name: 'Four+Aces',
                     tag: '4A',
                     member_count: 25,
                     village_count: 236,
                     points_top: 1_344_920,
                     points: 1_344_920,
                     rank: 10 },
                   { id: 3,
                     name: 'Premium+Points+Only',
                     tag: 'PPO',
                     member_count: 11,
                     village_count: 13,
                     points_top: 40_307,
                     points: 40_307,
                     rank: 33 }] }
      )
      expected_response = [{ external_id: 1,
                             name: 'Old+Skool',
                             tag: '.OS.',
                             points: 428_719,
                             rank: 33 },
                           { external_id: 2,
                             name: 'Four+Aces',
                             tag: '4A',
                             points: 1_344_920,
                             rank: 10 },
                           { external_id: 3,
                             name: 'Premium+Points+Only',
                             tag: 'PPO',
                             points: 40_307,
                             rank: 33 }]
      allow(client).to receive(:browser).and_return(browser)
      service = GameActionsService.new(client)

      expect(service.tribes).to eq(expected_response)
    end
  end

  describe '#villages' do
    it 'returns villages list' do
      browser = double
      client = double
      allow(browser).to receive(:load_page).with('village_list')
      allow(browser).to receive(:extract).and_return(
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
      )
      expected_response = [{ external_id: 1,
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
      allow(client).to receive(:browser).and_return(browser)
      service = GameActionsService.new(client)

      expect(service.villages).to eq(expected_response)
    end
  end

  describe '#world_list_global' do
    it 'returns list of all servers available' do
      expected_response = { 'en107' => 'https://en107.tribalwars.net',
                            'en110' => 'https://en110.tribalwars.net',
                            'en111' => 'https://en111.tribalwars.net',
                            'en112' => 'https://en112.tribalwars.net',
                            'en113' => 'https://en113.tribalwars.net',
                            'en114' => 'https://en114.tribalwars.net',
                            'enc1' => 'https://enc1.tribalwars.net',
                            'enc2' => 'https://enc2.tribalwars.net',
                            'enc3' => 'https://enc3.tribalwars.net',
                            'enp6' => 'https://enp6.tribalwars.net',
                            'enp7' => 'https://enp7.tribalwars.net',
                            'enp8' => 'https://enp8.tribalwars.net',
                            'enp9' => 'https://enp9.tribalwars.net' }
      client = double
      allow(client).to receive(:browser)
      allow(client).to receive(:worlds_global).and_return(expected_response)
      service = GameActionsService.new(client)

      expect(service.world_list_global).to eq(expected_response)
    end
  end

  describe '#login' do
    it 'login successful' do
      expected_response = eval(file_fixture('login_success.hash').read)
      client = double
      allow(client).to receive(:login).and_return(expected_response)
      allow(client).to receive(:browser)
      service = GameActionsService.new(client)

      expect(service.login).to eq(expected_response)
    end
  end
end
