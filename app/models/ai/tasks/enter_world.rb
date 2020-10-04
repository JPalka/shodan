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
        game_service.enter_world(@args[:world_name])

        player_info = game_service.player_info
        world = World.find_by(name: @args[:world_name])
        # create player if its not found in local db for whatever reason
        unless player = world.players.find_by(external_id: player_info['player_id'].to_i)
          binding.pry
          player = Player.new(world: world, name: player_info['name'], external_id: player_info['player_id'].to_i)
        end

        player.account = Account.find(@args[:account_id])
        player.save!
        true
      end
    end
  end
end
