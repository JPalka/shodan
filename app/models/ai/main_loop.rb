# frozen_string_literal: true

module AI
  class MainLoop
    attr_reader :status

    def initialize(task_dispatcher, accounts)
      @task_dispatcher = task_dispatcher
      @accounts = accounts
      @logger = Logger.new(STDOUT)
    end

    def start
      @status = 'running'
      @logger.info('Main loop started')
      # login ze accounts to game server and into ze first active world
      @accounts.each do |account|
        @task_dispatcher.send_task(account.id, Tasks::Login.new)
        @logger.info("Entering world #{account.active_worlds.first}")
        @task_dispatcher.send_task(account.id, Tasks::EnterWorld.new(world_name: account.active_worlds.first.name))
      end
      while @status != 'stopped'
        # @accounts.each { |account| @logger.info(@task_dispatcher.check_queue(@task_dispatcher.find_worker(account.id))) }
        sleep(1)
        if @status == 'stopping'
          @logger.info('Shutting down main loop')
          initiate_shutdown
        end
      end
      @logger.info('Main loop stopped.')
    end

    def stop
      @status = 'stopping'
      sleep(0.5) until @status == 'stopped'
    end

    private

    def initiate_shutdown
      # DO SOME STUFF ON SHUTDOWN
      @status = 'stopped'
    end
  end
end
