# frozen_string_literal: true

module AI
  class Engine
    attr_reader :id

    def initialize(id)
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
      # Setup worker
      @channel.default_exchange.publish({ 'action' => 'start_worker', 'worker_class' => 'Worker' }.to_json,
                                        routing_key: 'worker_manager')
    end

    def stop
      @connection.close
      @logger.info('AI stopped')
    end
  end
end
