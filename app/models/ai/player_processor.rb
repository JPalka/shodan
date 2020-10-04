# frozen_string_literal: true

module AI
  # Processes 'turn' for player
  class PlayerProcessor
    def initialize(task_dispatcher, player)
      @task_dispatcher = task_dispatcher
      @player = player
    end

    def initialize_player
      @task_dispatcher.send_task(Tasks::Login.new)
      @task_dispatcher.send_task(
        Tasks::EnterWorld.new(
          account_id: @player.account.id, world_name: @player.world.name
        )
      )
    end
  end
end
