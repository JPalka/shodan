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
    temp.id
  end

  def stop_worker(worker_id)
    victim = @workers.find { |worker| worker.id == worker_id }
    if victim.nil?
      @logger.warn "Worker not found: #{worker_id}"
    else
      victim.stop
      @workers.delete(victim)
      @logger.info "Deleted worker: #{worker_id}"
      @logger.info "Active Workers: #{@workers.count}"
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
    consumer = @queue.subscribe(block: false) do |delivery_info, props, body|
      @logger.info "Received message: #{body} - #{delivery_info} - #{props}"
      body = JSON.parse(body)
      case body['action']
      when 'kill_yourself'
        @exit = true
        consumer.cancel
      when 'start_worker'
        klass = body['worker_class'].safe_constantize
        if [Worker, AI::Engine].include? klass
          response = start_worker(klass)
          @channel.default_exchange.publish(response, routing_key: props.reply_to, correlation_id: props.correlation_id)
        else
          @logger.warn "Invalid worker class: #{body['worker_class']} - #{klass}"
          @channel.default_exchange.publish('Invalid worker class', routing_key: props.reply_to, correlation_id: props.correlation_id)
        end
      when 'stop_worker'
        stop_worker(body['worker_id'])
      when 'list_workers'
        worker_list = if @workers.empty?
                        {}
                      else
                        @workers.each_with_object({}) { |worker, hash| hash[worker.id] = worker.class }
                      end
        response = JSON.generate(worker_list)
        @channel.default_exchange.publish(response, routing_key: props.reply_to, correlation_id: props.correlation_id)
      else
        @logger.warn "Invalid action received: ${body['action']}"
      end
    end
  end
end
