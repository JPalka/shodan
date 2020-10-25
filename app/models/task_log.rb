# frozen_string_literal: true

class TaskLog < ApplicationRecord
  belongs_to :account
  serialize :args

  scope :finished, -> { where(status: 'finished') }

  validates :worker_id, presence: true
  validates :task_class, presence: true
  validates :status, presence: true
end
