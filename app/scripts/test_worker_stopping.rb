# frozen_string_literal: true

client = StartWorker.new('worker_manager')
id = client.call('Worker')

client = StopWorker.new('worker_manager')

puts " [x] Stopping worker #{id}"
response = client.call(id)

puts " [.] Got #{response}"

client = StopWorker.new('worker_manager')
puts " Stopping nonexistant worker"
response = client.call('bogus_id')
puts " [.] Got #{response}"