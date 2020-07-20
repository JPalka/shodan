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
      @connection = Bunny.new(hostname: 'localhost')
      @connection.start
      @channel = @connection.create_channel
      async.start_ai_loop
    end

    def stop
      @connection.close
      @main_loop.stop
      @logger.info('AI stopped')
    end

    def start_ai_loop
      setup_workers

      @logger.info('Starting AI main loop')
      @main_loop = MainLoop.new(@workers)
      @main_loop.start
    end

    def setup_workers
      @logger.info('Setting up workers...')
      # fetch accounts to be played
      accounts = Account.all

      # Setup 1 worker per account and map them to accounts
      @workers = accounts.each_with_object({}) do |account, hash|
        hash[account.id] = StartWorker.new('worker_manager')
                                      .call('Worker', account.login, account.password, account.master_server.link)
      end
      @logger.info("Created workers for accounts: #{accounts.map(&:login)}")
      true
    end
  end
end
