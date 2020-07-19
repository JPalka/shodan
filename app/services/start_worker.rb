# frozen_string_literal: true

class StartWorker < RPCService
  def call(worker_class, login = nil, password = nil, server = nil)
    super('start_worker', worker_class: worker_class, args: { login: login, password: password, master_server: server })
  end
end
