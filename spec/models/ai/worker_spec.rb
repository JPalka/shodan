# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AI::Worker, type: :model do
  describe '#handle_task' do
    it 'executes and saves task to db' do
      account = FactoryBot.create(:account)

      task = instance_double(AI::Tasks::TaskBase)
      allow(task).to receive(:execute)
      allow(task).to receive(:serialize).and_return(
        {
          task_class: AI::Tasks::TaskBase.name,
          status: 'finished',
          args: { argument_uno: 'topkek' },
        }.to_json
      )
      allow(Tribes::Client).to receive(:new).and_return(double)
      worker = AI::Worker.new(1, account: account)
      worker.handle_task(task)

      expect(TaskLog.all.count).to eq(1)
      expect(TaskLog.first.worker_id).to eq('1')
      expect(TaskLog.first.account).to eq(account)
      expect(TaskLog.first.task_class).to eq(AI::Tasks::TaskBase.name)
      expect(TaskLog.first.status).to eq('finished')
      expect(TaskLog.first.error).to eq('')
      expect(TaskLog.first.args).to eq({'argument_uno' => 'topkek'})
    end

    it 'it handles tasks that raise exception' do
      account = FactoryBot.create(:account)

      task = instance_double(AI::Tasks::TaskBase)
      allow(task).to receive(:execute).and_raise(Exception.new("random exception"))
      allow(task).to receive(:serialize).and_return(
        {
          task_class: AI::Tasks::TaskBase.name,
          status: 'failed',
          args: { argument_uno: 'topkek' },
        }.to_json
      )
      allow(Tribes::Client).to receive(:new).and_return(double)
      worker = AI::Worker.new(1, account: account)
      worker.handle_task(task)

      expect(TaskLog.all.count).to eq(1)
      expect(TaskLog.first.worker_id).to eq('1')
      expect(TaskLog.first.account).to eq(account)
      expect(TaskLog.first.task_class).to eq(AI::Tasks::TaskBase.name)
      expect(TaskLog.first.status).to eq('failed')
      expect(TaskLog.first.error).to eq('random exception')
      expect(TaskLog.first.args).to eq({'argument_uno' => 'topkek'})
    end
  end
end
