# frozen_string_literal: true

FactoryBot.define do
  factory :task_log do
    worker_id { SecureRandom.uuid }
    account
    task_class { 'SampleTask' }
    status { 'pending' }
  end
end
