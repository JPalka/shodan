# frozen_string_literal: true

module AI
  class Engine
    include Concurrent::Async
    attr_reader :id

    def initialize(id, account_id:)
      @id = id
      @logger = Logger.new(STDOUT)
      @logger.info!
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        "#{severity}, ai-#{id} #{datetime}: - #{msg}\n"
      end
      @account = Account.find(account_id)
      @logger.info("Created ai with uuid: #{@id} for account id #{@account.id}")
    end

    def start
      @logger.info('Starting AI engine...')
      @task_dispatcher = TaskDispatcher.new(setup_worker)
      @player_processor = PlayerProcessor.new(@task_dispatcher, @account, managers)
      async.start_ai_loop
    end

    def stop
      @main_loop.stop
      @task_dispatcher.destroy
      @logger.info('AI stopped')
    end

    def start_ai_loop
      @logger.info('Starting AI main loop')
      @main_loop = MainLoop.new(@player_processor)
      @main_loop.start
    rescue Exception => e
      @logger.error("Wybiło szambo: #{e}")
      WorkerManagerService.new('worker_manager').stop_worker(id)
    end

    private

    def setup_worker
      @logger.info('Setting up worker...')
      worker = Worker.new(@id, account: @account)
      @logger.info("Created worker for account: #{@account.login}")
      worker
    end

    def managers
      [Managers::Data.new]
    end
  end
end
