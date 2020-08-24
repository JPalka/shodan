# frozen_string_literal: true

module AI
  class Engine
    include Concurrent::Async
    attr_reader :id

    def initialize(id, *)
      @id = id
      @logger = Logger.new(STDOUT)
      @logger.info!
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        "#{severity}, ai-#{id} #{datetime}: - #{msg}\n"
      end
      @logger.info("Created worker-ai with uuid: #{@id}")
    end

    def start
      @logger.info('Starting AI engine...')
      async.start_ai_loop
    end

    def stop
      @main_loop.stop
      @task_dispatcher.destroy
      @logger.info('AI stopped')
    end

    def start_ai_loop
      workers = setup_workers
      @task_dispatcher = TaskDispacher.new(workers)
      @account_processor = AccountProcessor.new(@task_dispatcher)
      @logger.info('Starting AI main loop')
      @main_loop = MainLoop.new(@account_processor)
      @main_loop.start
    rescue Exception => e
      @logger.error("Wybiło szambo: #{e}")
    end

    def setup_workers
      @logger.info('Setting up workers...')
      # fetch accounts to be played
      accounts = Account.all

      # Setup 1 worker per account and map them to accounts
      workers = accounts.each_with_object({}) do |account, hash|
        hash[account.id] = StartWorker.new('worker_manager')
                                      .call('Worker', account.id)
      end
      @logger.info("Created workers for accounts: #{accounts.map(&:login)}")
      workers
    end
  end
end
