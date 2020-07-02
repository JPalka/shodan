FactoryBot.define do
  factory :player do
    external_id { 100 }
    name { "Player" }
    points { 0 }
    rank { 0 }
    world
    account { nil }
  end
end
