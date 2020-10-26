# frozen_string_literal: true

module AI
  module Tasks
    class GetWorldConfigs < TaskBase
      def check_args
        raise ArgumentError, 'Argument "world_name" missing' unless @args[:world_name]
      end

      private

      def do_task(client)
        p 'GETTING WORLD CONFIG'
        game_service = GameActionsService.new(client)
        world = World.find_by(name: @args[:world_name])

        world.building_config = game_service.building_config
        world.unit_config = game_service.unit_config
        world.world_config = game_service.world_config
        world.save!
        true
      end
    end
  end
end
