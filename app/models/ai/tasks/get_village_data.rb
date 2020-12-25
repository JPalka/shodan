# frozen_string_literal: true

module AI
  module Tasks
    class GetVillageData < TaskBase
      def check_args
        raise ArgumentError, 'Argument "village_id" missing' unless @args[:village_id]
      end

      private

      def do_task(client)
        game_service = GameActionsService.new(client)
        village = Village.find(@args[:village_id])

        resources = game_service.village_resources.symbolize_keys
        village.village_resources = VillageResources.new(resources)
        village.save
      end
    end
  end
end
