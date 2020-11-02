# frozen_string_literal: true

require 'logger'

module AI
  class Worker
    attr_reader :id

    def initialize(id, account:, logger: Logger.new(STDOUT))
      @id = id
      @logger = logger
      @account = account
      @logger.debug("Worker params - login: #{@account.login} - pass: #{@account.password} - server: #{@account.master_server.link}")
      @client = Tribes::Client.new(
        login: account.login,
        password: account.password,
        master_server: account.master_server.link
      )
      @logger.info("Created worker with uuid: #{@id}")
    end

    def handle_task(task)
      task.execute(@client)
      save_task(task)
    rescue Exception => e # rubocop:disable Lint/RescueException
      save_task(task, e)
    end

    private

    def save_task(task, error = nil)
      task_hash = JSON.parse(task.serialize).symbolize_keys
      TaskLog.create!(worker_id: @id,
                      account: @account,
                      task_class: task_hash[:task_class],
                      status: task_hash[:status],
                      error: error.to_s,
                      args: task_hash[:args])
    end
  end
end
