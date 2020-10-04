# frozen_string_literal: true

module AI
  module Tasks
    class Login < TaskBase
      # login does not require args
      def check_args; end

      private

      def do_task(client)
        GameActionsService.new(client).login
        true
      end
    end
  end
end
