# frozen_string_literal: true

class StopWorker < RPCService
  def call(worker_id)
    super('stop_worker', worker_id: worker_id)
  end
end
