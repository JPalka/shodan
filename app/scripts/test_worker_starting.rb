# frozen_string_literal: true

puts ' [x] Starting worker'
client = StartWorker.new('worker_manager')
response = client.call('Worker')
puts " [.] Got #{response}"

puts ' [x] Starting AI'
client = StartWorker.new('worker_manager')
response = client.call('AI::Engine')
puts " [.] Got #{response}"
