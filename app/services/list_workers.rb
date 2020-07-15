# frozen_string_literal: true

class ListWorkers < RPCService
  def call
    super('list_workers')
  end
end
