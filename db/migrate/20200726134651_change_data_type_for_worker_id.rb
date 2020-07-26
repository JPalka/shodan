# frozen_string_literal: true

class ChangeDataTypeForWorkerId < ActiveRecord::Migration[6.0]
  def change
    change_column :task_logs, :worker_id, :string
  end
end
