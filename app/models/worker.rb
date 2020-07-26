# frozen_string_literal: true

require 'logger'

class Worker
  include Concurrent::Async
  attr_reader :id

  def initialize(id, account_id:)
    super()
    @id = id
    @logger = Logger.new(STDOUT)
    @logger.info!
    @account = Account.find(account_id)
    @account_id = account_id
    @logger.info("Worker params - login: #{@account.login} - pass: #{@account.password} - server: #{@account.master_server.link}")
    @client = Tribes::Client.new(login: @account.login, password: @account.password, master_server: @account.master_server.link)
    @logger.info("Created worker with uuid: #{@id}")
  end

  def start
    @logger.info('Starting worker...')
    @connection = Bunny.new(hostname: 'localhost')
    @connection.start
    @channel = @connection.create_channel
    # eat one crap at the time
    @channel.prefetch(1, true)
    @queue = @channel.queue(id.to_s, durable: false, auto_delete: true)
    @consumer = @queue.subscribe(block: false, manual_ack: true) do |delivery_info, properties, body|
      @logger.info "Received message: #{body} - #{delivery_info} - #{properties}"
      handle_task(JSON.parse(body))
      sleep(5)
      @channel.ack(delivery_info.delivery_tag)
    end
    @logger.info('Worker listening for messages')
  end

  def stop
    @consumer.cancel
    @connection.close
    @logger.info('Worker stopped')
  end

  private

  def handle_task(msg)
    task = msg['task_class'].constantize.new(**msg['args'].merge('account_id' => @account.id))
    task.execute(@client)
    save_task(task)
  rescue Exception => e # rubocop:disable Lint/RescueException
    save_task(task, e)
  end

  def save_task(task, error = nil)
    task_hash = JSON.parse(task.serialize).symbolize_keys
    TaskLog.create!(worker_id: @id,
                    account: @account,
                    task_class: task_hash[:task_class],
                    status: task_hash[:status],
                    error: error.to_s,
                    args: task_hash[:args])
  end
end
