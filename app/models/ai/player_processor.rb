# frozen_string_literal: true

module AI
  # Processes 'turn' for player
  class PlayerProcessor
    def initialize(task_dispatcher, account, managers)
      @task_dispatcher = task_dispatcher
      @account = account
      initialize_account
      @player = account.active_worlds.first.players.find_by(account_id: account.id)
      @managers = managers
    end

    def process_player_turn
      create_tasks.each(&method(:dispatch_task))
    end

    private

    def initialize_account
      dispatch_task(Tasks::Login.new)
      dispatch_task(
        Tasks::EnterWorld.new(
          account_id: @account.id, world_name: @account.active_worlds.first.name
        )
      )
    end

    def dispatch_task(task)
      @task_dispatcher.send_task(task)
    end

    def create_tasks
      # here comes all managers mumbo jumbo stuff
      @managers.inject([]) do |tasks, manager|
        tasks + manager.process(@player)
      end
    end
  end
end
