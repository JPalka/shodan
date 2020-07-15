# frozen_string_literal: true

client = StartWorker.new('worker_manager')

puts ' [x] Requesting worker list'
response = client.call('Worker')

puts " [.] Got #{response}"
