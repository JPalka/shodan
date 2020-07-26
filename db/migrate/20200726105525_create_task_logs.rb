class CreateTaskLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :task_logs do |t|
      t.integer :worker_id
      t.references :account, null: false, foreign_key: true
      t.string :task_class
      t.string :args
      t.string :status
      t.string :error

      t.timestamps
    end
  end
end
