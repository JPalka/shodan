# frozen_string_literal: true

class StartWorker < RPCService
  def call(worker_class)
    super('start_worker', worker_class: worker_class)
  end
end
