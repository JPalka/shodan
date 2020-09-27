# frozen_string_literal: true

service = WorkerManagerService.new('worker_manager')

puts ' [x] Requesting worker list'
response = service.worker_list

puts " [.] Got #{response}"
