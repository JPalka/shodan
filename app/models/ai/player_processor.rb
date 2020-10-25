# frozen_string_literal: true

module AI
  # Processes 'turn' for player
  class PlayerProcessor
    def initialize(task_dispatcher, player, managers)
      @task_dispatcher = task_dispatcher
      @player = player
      @managers = managers
    end

    def initialize_player
      dispatch_task(Tasks::Login.new)
      dispatch_task(
        Tasks::EnterWorld.new(
          account_id: @player.account.id, world_name: @player.world.name
        )
      )
    end

    def process_player_turn
      create_tasks.each(&method(:dispatch_task))
    end

    private

    def dispatch_task(task)
      @task_dispatcher.send_task(task)
    end

    def create_tasks
      # here comes all managers mumbo jumbo stuff
      managers.each_with_object([]) do |manager, tasks|
        tasks << manager.process(@player)
      end
    end
  end
end
