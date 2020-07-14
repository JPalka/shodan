# frozen_string_literal: true

# require 'bunny'
# class TestWorkerClient
#   attr_accessor :call_id, :response, :lock, :condition, :connection,
#                 :channel, :server_queue_name, :reply_queue, :exchange

#   def initialize(server_queue_name)
#     @connection = Bunny.new(automatically_recover: false)
#     @connection.start

#     @channel = connection.create_channel
#     @exchange = channel.default_exchange
#     @server_queue_name = server_queue_name

#     setup_reply_queue
#   end

#   def call(action)
#     @call_id = generate_uuid
#     body = { 'action' => action }
#     exchange.publish(JSON.generate(body),
#                      routing_key: server_queue_name,
#                      correlation_id: call_id,
#                      reply_to: reply_queue.name)

#     # wait for the signal to continue the execution
#     lock.synchronize { condition.wait(lock) }

#     response
#   end

#   def stop
#     channel.close
#     connection.close
#   end

#   private

#   def setup_reply_queue
#     @lock = Mutex.new
#     @condition = ConditionVariable.new
#     that = self
#     @reply_queue = channel.queue('', exclusive: true)

#     reply_queue.subscribe do |_delivery_info, properties, payload|
#       if properties[:correlation_id] == that.call_id
#         that.response = payload

#         # sends the signal to continue the execution of #call
#         that.lock.synchronize { that.condition.signal }
#       end
#     end
#   end

#   def generate_uuid
#     # very naive but good enough for code examples
#     SecureRandom.uuid
#   end
# end

client = ListWorkers.new('worker_manager')

puts ' [x] Requesting worker list'
response = client.call

puts " [.] Got #{response}"
