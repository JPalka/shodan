FactoryBot.define do
  factory :world do
    name { "MyString" }
    link { "MyString" }
    master_server

    factory :world_with_players do
      after(:create) do |world, _evaluator|
        create_list(:player, 5, world: world)
      end
    end
  end
end
