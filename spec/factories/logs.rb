# frozen_string_literal: true

FactoryBot.define do
  factory :log, class: AI::Log do
    sequence(:message) { |n| "Log message nr. #{n}" }

    trait :info do
      severity { 'INFO' }
    end

    trait :debug do
      severity { 'DEBUG' }
    end

    trait :warn do
      severity { 'WARN' }
    end
  end
end
