# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AI::Managers::Data, type: :model do
  describe '#process' do
    it 'updates world data if it was not updated at all' do
      manager = AI::Managers::Data.new
      player = create(:player)

      expect(manager.process(player).count).to eq(1)
      expect(manager.process(player).first.class).to eq AI::Tasks::GetWorldData
    end

    it 'updates world data if it was not updated in last x minutes' do
      manager = AI::Managers::Data.new(world_data_interval: 1)
      player = create(:player)
      create(:task_log, task_class: 'AI::Tasks::GetWorldData', status: 'finished', args: { 'world_name' => player.world.name })

      Timecop.freeze(DateTime.now + 1.minute) do
        create(:task_log, task_class: 'AI::Tasks::GetWorldData', status: 'failed', args: { 'world_name' => player.world.name })
        expect(manager.process(player).count).to eq(1)
        expect(manager.process(player).first.class).to eq AI::Tasks::GetWorldData
      end
    end

    it 'does not update world data if it was updated in last x minutes' do
      manager = AI::Managers::Data.new(world_data_interval: 1)
      player = create(:player)
      create(
        :task_log,
        task_class: 'AI::Tasks::GetWorldData',
        status: 'finished',
        args: { 'world_name' => player.world.name }
      )

      Timecop.freeze(DateTime.now) do
        expect(manager.process(player).count).to eq(0)
      end
    end
  end
end
