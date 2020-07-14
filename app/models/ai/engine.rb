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
      @queue = @channel.queue(id.to_s, durable: false)
      @consumer = @queue.subscribe(block: false) do |delivery_info, properties, body|
        @logger.info "Received message: #{body} - #{delivery_info} - #{properties}"
      end
      @logger.info('Worker listening for messages')
    end

    def stop
      @consumer.cancel
      @connection.close
      @logger.info('AI stopped')
    end
  end
end
