# frozen_string_literal: true

module AI
  module Tasks
    class GetWorldData < TaskBase
      def check_args
        raise ArgumentError, 'Argument "world_name" missing' unless @args[:world_name]
      end

      private

      def do_task(client)
        game_service = GameActionsService.new(client)
        world = World.find_by(name: @args[:world_name])

        players = game_service.players
        villages = game_service.villages
        tribes = game_service.tribes

        world.save_players(players)
        world.save_villages(villages)
        world.save_tribes(tribes)
        world.save!
        true
      end
    end
  end
end
