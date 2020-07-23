# frozen_string_literal: true

class StartWorker < RPCService
  def call(worker_class, account_id = nil)
    super('start_worker', worker_class: worker_class, args: { account_id: account_id })
  end
end
