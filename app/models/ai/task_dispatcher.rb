# frozen_string_literal: true

module AI
  class TaskDispatcher
    def initialize(worker)
      @worker = worker
    end

    def send_task(task)
      @worker.handle_task(task)
    end
  end
end
