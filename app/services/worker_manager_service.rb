# frozen_string_literal: true

class WorkerManagerService
  def initialize(server_queue_name)
    @queue_name = server_queue_name
  end

  def worker_list
    service.call('list_workers', args: {})
  end

  def create_worker(worker_class: AI::Engine, account_id: nil)
    service.call('start_worker', worker_class: worker_class, args: { account_id: account_id })
  end

  def stop_worker(worker_id:)
    service.call('stop_worker', worker_id: worker_id)
  end

  private

  def service
    RPCService.new(@queue_name)
  end
end
