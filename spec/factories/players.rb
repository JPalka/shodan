# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    sequence(:external_id, 100)
    name { 'Player' }
    points { 0 }
    rank { 0 }
    world
    account { nil }

    factory :player_with_villages do
      after(:create) do |player, _evaluator|
        create_list(:village, 5, owner: player)
      end
    end
  end
end
