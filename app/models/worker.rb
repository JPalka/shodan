# frozen_string_literal: true

require 'logger'

class Worker
  include Concurrent::Async
  attr_reader :id
  def initialize(id)
    super()
    @id = id
    @logger = Logger.new(STDOUT)
    @logger.info!
    @logger.info("Created worker with uuid: #{@id}")
  end

  def start
    @logger.info('Starting worker...')
    @connection = Bunny.new(hostname: 'localhost')
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue('worker', durable: false)
    @consumer = @queue.subscribe(block: false) do |delivery_info, properties, body|
      @logger.info "Received message: #{body} - #{delivery_info} - #{properties}"
    end
    @logger.info('Worker listening for messages')
  end

  def stop
    @consumer.cancel
    @connection.close
    @logger.info('Worker stopped')
  end
end
