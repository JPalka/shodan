# frozen_string_literal: true

class WorkerManager
  def initialize
    @logger = Rails.logger
    @connection = Bunny.new(hostname: 'localhost')
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue('worker_manager')
  end

  def start_worker(worker); end

  def stop_worker(worker_id); end

  def workers; end

  def run
    @logger.info 'Starting worker manager'
    begin
      listen
      sleep(5) while @exit != true
    ensure
      @logger.info 'Exiting worker manager'
      @connection.close
    end
  end

  private

  def listen
    @logger.info 'Listening for messages...'
    consumer = @queue.subscribe(block: false) do |delivery_info, properties, body|
      @logger.info "Received message: #{body} - #{delivery_info} - #{properties}"
      if body == 'kill_yourself'
        @exit = true
        consumer.cancel
      end
    end
  end
end
