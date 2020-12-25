# frozen_string_literal: true

module AI
  module Managers
    class Data
      def initialize(world_data_interval: 60, logger: Logger.new(STDOUT))
        @world_data_interval = world_data_interval
        @logger = logger
      end

      def process(player)
        player.reload
        world = player.world.name
        # check when world data was last updated
        last_update = TaskLog.finished.where(task_class: 'AI::Tasks::GetWorldData').order(created_at: :desc).select do |task|
          task.args['world_name'] == world
        end.first&.created_at

        @tasks = []
        @tasks << Tasks::GetWorldData.new(world_name: world) if update?(last_update)

        @tasks << Tasks::GetWorldConfigs.new(world_name: world) unless player.world.config_present?

        update_village_data(player)
        @tasks
      end

      private

      def update_village_data(player)
        # TODO: change it to something less bogus. For now multiple villages are not supported
        village_id = player.villages.first&.id
        return if village_id.nil?

        last_update = TaskLog.finished.where(task_class: 'AI::Tasks::GetVillageData').order(created_at: :desc).select do |task|
          task.args['village_id'] == village_id
        end.first&.created_at
        @logger.debug("Village resources last updated at: #{last_update}")
        return unless !last_update || last_update < 1.minute.ago

        @logger.info("Updating village resources for village: #{village_id}")
        @tasks << AI::Tasks::GetVillageData.new(village_id: village_id)
      end

      def update?(last_update)
        !last_update || last_update < @world_data_interval.minute.ago
      end
    end
  end
end
