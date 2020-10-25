# frozen_string_literal: true

module AI
  module Managers
    class Data
      def initialize(world_data_interval: 60)
        @world_data_interval = world_data_interval
      end

      def process(player)
        # get data needed to make decision
        #
        # return array of tasks or something

        world = player.world.name
        # check when world data was last updated
        last_update = TaskLog.finished.where(task_class: 'AI::Tasks::GetWorldData').order(created_at: :desc).select do |task|
          task.args['world_name'] == world
        end.first&.created_at

        return [Tasks::GetWorldData.new(world_name: world)] if update?(last_update)

        []
      end

      private

      def update?(last_update)
        !last_update || last_update < @world_data_interval.minute.ago
      end
    end
  end
end
