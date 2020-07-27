module AI
  # Processes 'turn' for accounts
  class AccountProcessor
    def initialize(task_dispatcher)
      @task_dispatcher = task_dispatcher
      @accounts = Account.all
    end

    def initialize_accounts
      # login ze accounts to game server and into ze first active world
      # TODO: remember to handle playing on more than one world somehow
      @accounts.each do |account|
        @task_dispatcher.send_task(account.id, Tasks::Login.new)
        @task_dispatcher.send_task(account.id, Tasks::EnterWorld.new(world_name: account.active_worlds.first.name))
      end
    end
  end
end
