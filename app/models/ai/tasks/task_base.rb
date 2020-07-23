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
        raise NotImplementedError.new("execute")
      end

      def check_args
        raise NotImplementedError.new("check_args")
      end

      def to_json
        {task_class: self.class, args: @args, status: @status}.to_json
      end
    end
  end
end
