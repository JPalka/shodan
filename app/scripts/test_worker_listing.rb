# frozen_string_literal: true

client = ListWorkers.new('worker_manager')

puts ' [x] Requesting worker list'
response = client.call

puts " [.] Got #{response}"
