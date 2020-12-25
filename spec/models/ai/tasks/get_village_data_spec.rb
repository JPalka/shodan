# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AI::Tasks::GetVillageData, type: :model do
  describe '#execute' do
    context 'when village id is missing' do
      it 'raises error' do
        task = AI::Tasks::GetVillageData.new

        client = double
        game_actions = instance_double(GameActionsService)

        expect { task.execute(client) }.to raise_error(ArgumentError, 'Argument "village_id" missing')
      end
    end

    context 'when village has no village_resources object' do
      it 'updates village data' do
        player = create(:player_with_villages)
        task = AI::Tasks::GetVillageData.new(village_id: player.villages.first.id)
        village_resources = {
          'wood': 100,
          'stone': 150,
          'iron': 200,
          'wood_prod': 0.5,
          'stone_prod': 0.75,
          'iron_prod': 0.80,
          'max_storage': 500,
          'pop': 10,
          'max_pop': 100
        }

        client = double
        game_actions = instance_double(GameActionsService)
        allow(GameActionsService).to receive(:new).and_return(game_actions)
        allow(game_actions).to receive(:village_resources).and_return(village_resources)
        task.execute(client)
        new_resources = player.villages.first.village_resources

        aggregate_failures 'village resources match input hash' do
          expect(new_resources.wood).to eq(100)
          expect(new_resources.stone).to eq(150)
          expect(new_resources.iron).to eq(200)
          expect(new_resources.wood_prod).to eq(0.5)
          expect(new_resources.stone_prod).to eq(0.75)
          expect(new_resources.iron_prod).to eq(0.80)
          expect(new_resources.max_storage).to eq(500)
          expect(new_resources.pop).to eq(10)
          expect(new_resources.max_pop).to eq(100)
        end
      end
    end

    context 'when village had village_resources already' do
      it 'overrides old village_resources' do
        player = create(:player_with_villages)
        village = player.villages.first
        old_village_resources = {
          'wood': 10,
          'stone': 15,
          'iron': 20,
          'wood_prod': 0.4,
          'stone_prod': 0.74,
          'iron_prod': 0.70,
          'max_storage': 400,
          'pop': 20,
          'max_pop': 110
        }
        village.village_resources = VillageResources.new(old_village_resources)
        task = AI::Tasks::GetVillageData.new(village_id: village.id)
        village_resources = {
          'wood': 100,
          'stone': 150,
          'iron': 200,
          'wood_prod': 0.5,
          'stone_prod': 0.75,
          'iron_prod': 0.80,
          'max_storage': 500,
          'pop': 10,
          'max_pop': 100
        }

        client = double
        game_actions = instance_double(GameActionsService)
        allow(GameActionsService).to receive(:new).and_return(game_actions)
        allow(game_actions).to receive(:village_resources).and_return(village_resources)
        task.execute(client)
        new_resources = player.villages.first.village_resources

        aggregate_failures 'village resources match input hash' do
          expect(new_resources.wood).to eq(100)
          expect(new_resources.stone).to eq(150)
          expect(new_resources.iron).to eq(200)
          expect(new_resources.wood_prod).to eq(0.5)
          expect(new_resources.stone_prod).to eq(0.75)
          expect(new_resources.iron_prod).to eq(0.80)
          expect(new_resources.max_storage).to eq(500)
          expect(new_resources.pop).to eq(10)
          expect(new_resources.max_pop).to eq(100)
        end
      end
    end
  end
end
