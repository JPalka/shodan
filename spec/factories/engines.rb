# frozen_string_literal: true

FactoryBot.define do
  factory :engine, class: AI::Engine do
    skip_create
    id { SecureRandom.uuid }
    account
    initialize_with { AI::Engine.new(id, account_id: account.id) }
  end
end
