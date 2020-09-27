# frozen_string_literal: true

service = WorkerManagerService.new('worker_manager')
id = service.create_worker

puts " [x] Stopping worker #{id}"
response = service.stop_worker(worker_id: id)

puts " [.] Got #{response}"

puts ' Stopping nonexistant worker'
response = service.stop_worker(worker_id: 'bogus_id')
puts " [.] Got #{response}"
