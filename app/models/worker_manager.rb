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

  def start_worker(worker, args = {})
    puts(**args)
    temp = worker.new(SecureRandom.uuid, args.symbolize_keys)
    temp.start
    @workers.push(temp)
    temp.id
  end

  def stop_worker(worker_id)
    @workers.delete_if { |worker| worker.id == worker_id }
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

  def stop
    @exit = true
  end

  private

  def listen
    @logger.info 'Listening for messages...'
    @queue.subscribe(block: false) do |delivery_info, props, body|
      @logger.info "Received message: #{body} - #{delivery_info} - #{props}"
      body = JSON.parse(body)
      exchange.publish(
        handle_message(body: body),
        routing_key: props.reply_to,
        correlation_id: props.correlation_id
      )
    end
  end

  def worker_list
    worker_list = @workers.each_with_object({}) { |worker, hash| hash[worker.id] = worker.class }
    JSON.generate(worker_list)
  end

  def exchange
    @channel.default_exchange
  end

  # rubocop:disable Metrics/MethodLength
  def handle_message(body:)
    case body['action']
    when 'start_worker'
      worker_class = body['worker_class']
      klass = worker_class.safe_constantize
      if [Worker, AI::Engine].include? klass
        start_worker(klass, body['args'])
      else
        @logger.warn "Invalid worker class: #{worker_class} - #{klass}"
        'Invalid worker class'
      end
    when 'stop_worker'
      stop_worker(body['worker_id']).to_s
    when 'list_workers'
      worker_list
    else
      @logger.warn "Invalid action received: ${body['action']}"
      'Invalid action'
    end
  end
  # rubocop:enable Metrics/MethodLength
end
