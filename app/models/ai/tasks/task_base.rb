# frozen_string_literal: true

module AI
  module Tasks
    class TaskBase
      attr_reader :status

      def initialize(**args)
        check_args
        # store arguments passed for easier serialization
        @args = args
        @status = 'pending'
      end

      def execute(client)
        raise(ArgumentError, 'Client cant be nil') if client.nil?

        @status = do_task(client) ? 'finished' : 'failed'
        delay
      end

      def check_args
        raise(NotImplementedError, 'check_args')
      end

      def serialize
        { task_class: self.class.name, args: @args, status: @status }.to_json
      end

      def delay
        sleep(5)
      end

      private

      def do_task(_client)
        raise(NotImplementedError, 'do_task')
      end
    end
  end
end
