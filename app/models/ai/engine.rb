# frozen_string_literal: true

module AI
  class Engine
    include Concurrent::Async
    attr_reader :id

    def initialize(account_id:)
      @account = Account.find(account_id)
      @id = "#{@account.id}-#{@account.active_worlds.first.name}"
      @logger = Logger.new(AI::Log)
      @logger.debug!
      @logger.formatter = proc do |severity, _datetime, _progname, msg|
        {
          severity: severity,
          msg: msg,
          origin: id,
          account: @account.login,
          world: @account.active_worlds.first.name
        }
      end
      @logger.info("Created ai with uuid: #{@id} for account id #{@account.id}")
    end

    def start
      @logger.info('Starting AI engine...')
      @task_dispatcher = TaskDispatcher.new(setup_worker)
      @player_processor = PlayerProcessor.new(@task_dispatcher, @account, managers, logger: @logger)
      async.start_ai_loop
    end

    def stop
      @main_loop.stop
      @logger.info('AI stopped')
    end

    def start_ai_loop
      @logger.info('Starting AI main loop')
      @main_loop = AI::MainLoop.new(@player_processor, logger: @logger)
      @main_loop.start
    rescue Exception => e # rubocop:disable Lint/RescueException
      @logger.error("Wybiło szambo: #{e}")
      WorkerManagerService.new('worker_manager').stop_worker(id)
    end

    private

    def setup_worker
      @logger.info('Setting up worker...')
      worker = AI::Worker.new(@id, account: @account, logger: @logger)
      @logger.info("Created worker for account: #{@account.login}")
      worker
    end

    def managers
      [AI::Managers::Data.new(logger: @logger)]
    end
  end
end
