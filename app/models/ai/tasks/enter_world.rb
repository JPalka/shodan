# frozen_string_literal: true

module AI
  module Tasks
    class EnterWorld < TaskBase
      # login does not require args
      def check_args
        raise ArgumentError, 'Argument "world_name" missing' unless @args[:world_name]

        raise ArgumentError, 'Argument "account_id" missing' unless @args[:account_id]

        Account.find(@args[:account_id])
      end

      private

      def do_task(client)
        game_service = GameActionsService.new(client)
        world = World.find_by(name: @args[:world_name])
        game_service.enter_world(world.name)
        world.add_player(**game_service.player_info, account_id: @args[:account_id])
        true
      end
    end
  end
end
