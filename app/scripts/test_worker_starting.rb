# frozen_string_literal: true

puts ' [x] Starting AI'
service = WorkerManagerService.new('worker_manager')
response = service.create_worker(1)
puts " [.] Got #{response}"
