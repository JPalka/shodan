# frozen_string_literal: true

module AI
  class MainLoop
    attr_reader :status

    def initialize(account_processor)
      @account_processor = account_processor
      @logger = Logger.new(STDOUT)
    end

    def start
      @status = 'running'
      @logger.info('Main loop started')
      @account_processor.initialize_accounts
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
