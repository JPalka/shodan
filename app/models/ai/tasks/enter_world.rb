# frozen_string_literal: true

module AI
  module Tasks
    class EnterWorld < TaskBase
      # login does not require args
      def check_args
        raise ArgumentError, 'Argument "world_name" missing' if @args['world_name'].nil?

        raise ArgumentError, 'Argument "account_id" missing' if @args['account_id'].nil?

        Account.find(@args['account_id'])
      end

      private

      def do_task(client)
        ::EnterWorld.new(client).execute(@args['world_name'])
        player_info = ::GetPlayerInfo.new(client).execute
        world = World.find_by(name: @args['world_name'])
        player = world.players.find_by(external_id: player_info['player_id'].to_i)
        # create player if its not found in local db for whatever reason
        if player.nil?
          player = Player.new(world: world, name: player_info['name'], external_id: player_info['player_id'].to_i)
        end

        player.account = Account.find(@args['account_id'])
        player.save!
        true
      end
    end
  end
end
