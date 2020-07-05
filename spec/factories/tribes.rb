FactoryBot.define do
  factory :tribe do
    external_id { 1 }
    world
    name { "MyString" }
    tag { "MyString" }
    points { 1 }
    rank { 1 }
  end
end
