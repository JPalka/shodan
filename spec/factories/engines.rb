# frozen_string_literal: true

FactoryBot.define do
  factory :engine, class: AI::Engine do
    skip_create
    id { SecureRandom.uuid }
    player
    initialize_with { AI::Engine.new(id, player_id: player.id) }
  end
end
