# frozen_string_literal: true

module AI
  class TaskDispacher
    attr_reader :workers

    def initialize(workers)
      @workers = workers
      @connection = Bunny.new(hostname: 'localhost')
      @connection.start
      @channel = @connection.create_channel
      @exchange = @channel.default_exchange
    end

    def send_task(account_id, task)
      worker = find_worker(account_id)
      @exchange.publish("TEST: #{task}", routing_key: worker)
    end

    def find_worker(account_id)
      @workers[account_id]
    end

    def destroy
      @connection.close
    end

    def check_queue(worker_id)
      Bunny::Queue.new(@channel, worker_id.to_s, auto_delete: true).status
    end
  end
end
