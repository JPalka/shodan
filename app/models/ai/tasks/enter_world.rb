# frozen_string_literal: true

module AI
  module Tasks
    class EnterWorld < TaskBase
      # login does not require args
      def check_args
        raise ArgumentError, 'Argument "world_name" missing' if @args['world_name'].nil?
      end

      private

      def do_task(client)
        ::EnterWorld.new(client).execute(@args['world_name'])
        true
      end
    end
  end
end
