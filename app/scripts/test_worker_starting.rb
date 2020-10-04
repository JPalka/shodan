# frozen_string_literal: true

puts ' [x] Starting AI'
service = WorkerManagerService.new('worker_manager')
response = service.create_worker(29708)
puts " [.] Got #{response}"
