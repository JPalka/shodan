# frozen_string_literal: true

class WorkerManager
  attr_reader :workers

  def initialize
    @logger = Logger.new(STDOUT)
    @connection = Bunny.new(hostname: 'localhost')
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue('worker_manager')
    @workers = []
  end

  def start_worker(worker)
    temp = worker.new(SecureRandom.uuid)
    temp.start
    @workers.push(temp)
  end

  def stop_worker(worker_id)
    victim = @workers.find { |worker| worker.id == worker_id }
    if victim.nil?
      @logger.warn "Worker not found: #{worker_id}"
    else
      victim.stop
    end
  end

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
      body = JSON.parse(body)
      case body['action']
      when 'kill_yourself'
        @exit = true
        consumer.cancel
      when 'start_worker'
        if [Worker, AI::Engine].include? body['worker_class'].safe_constantize
          start_worker(body['worker_class'].constantize)
        else
          @logger.warn "Invalid worker class: #{body['worker_class']} - #{body['worker_class'].safe_constantize}"
        end
      when 'stop_worker'
        stop_worker(body['worker_id'])
      when 'list_workers'
      else
        @logger.warn "Invalid action received: ${body['action']}"
      end
    end
  end
end
