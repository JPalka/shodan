# frozen_string_literal: true

FactoryBot.define do
  factory :engine, class: AI::Engine do
    skip_create
    account
    initialize_with { AI::Engine.new(account_id: account.id) }
  end
end
